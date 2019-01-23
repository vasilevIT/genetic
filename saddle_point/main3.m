clc,clear all
% Quantity epoch
N= 100;
game_length = 100;
M = [5,4,3,2;
    1,4,4,7];
p_reference = [0.6, 0.4];
q_reference = [0.2, 0, 0.8, 0];
u_reference = 3.4;
p = zeros(2,1);
p = [0.6; 0.4];
p2 = [0.1; 0.9];
p3 = [0.4; 0.6];
p4 = [0.7; 0.3];
q = [0.25; 0.25; 0.25; 0.25];
q2 = [0.5; 0.2; 0.1; 0.2];
q3 = [0.4; 0.2; 0.1; 0.3];
q4 = [0.2; 0.1; 0.6; 0.1];
u = 0;
population_size = 30;
k_mutation = 0.95;
population_a = [];
population_b = [];

disp('Win matrix:');
disp(M);
for i = 1:population_size
    temp_q = q;
    r0 = randi(4);
    if (r0 == 2)
        temp_q = q2;
    end
    if (r0 == 3)
        temp_q = q3;
    end
    if (r0 == 4)
        temp_q = q4;
    end
    temp_p = p;
    
    r0 = randi(4);
    if (r0 == 2)
        temp_p = p2;
    end
    if (r0 == 3)
        temp_p = p3;
    end
    if (r0 == 4)
        temp_p = p4;
    end
   population_a(i, :) =  temp_p';
   population_b(i, :) = temp_q';
end

u_mean = [];
u_mean_a = [];
u_mean_b = [];
% calculate
for epoch = 1:N
    u_sum = [];
    u_sum_a = [];
    u_sum_b = zeros(population_size, 1);
    fit_index = [];
%     loop for A player
    for i = 1: population_size
        ui = 0;
        ui_a = 0;
%         loop for B player
%         for m = 1: population_size
            ui_b = 0;
            for k = 1: game_length
                p1 = rand();
                q1 = rand(); 
                ai = 1;
                ai2 = 2;
                if (p1>population_a(i,1))
                    ai = 2;
                    ai2 = 1;
                end
                bi = 1;
                r0 = 0;
                for j = 1:4
                    if (q1>r0 && q1<r0+population_b(i,j))
                        bi = j;
                        break;
                    end
                    r0 = r0 + population_b(i,j);
                end
                u1 = M(ai, bi);
                u2 = M(ai, bi);
                ui = ui + (u1 + u2)/2;
                ui_a = ui_a + u1;
                ui_b = ui_b + u2;
            end
%         u_sum_b(m) = u_sum_b(m) + ui_b;
%         end
        u_sum(i) = ui/game_length;
        u_sum_a(i) = ui_a/game_length; % /population_size;
        u_sum_b(i) = ui_b/game_length; % /population_size;
    end
%     u_sum_b = u_sum_b/game_length/population_size;
    
    if (mod(epoch, int8(N/5)) == 0 || epoch < 5)
        figure
        title(sprintf('Epoch %d', epoch));
    %     plot(u_sum);
        hold on
        plot([0, 1], [0, 1], '.')
        hold on
        plot(population_a(:,1),population_a(:,2), 'o')
    end
    
    u_mean(epoch) = mean(u_sum);
    u_mean_a(epoch) = mean(u_sum_a);
    u_mean_b(epoch) = mean(u_sum_b);

    for i = 1: population_size
        fit_index_a(i) = 0;
        fit_index_b(i) = 0;
        for j = 1:population_size
           if (i~=j)
               if (u_sum_a(i) < u_sum_a(j))
                   fit_index_a(i) = fit_index_a(i) + 1;
               end
               if (u_sum_b(i) > u_sum_b(j))
                   fit_index_b(i) = fit_index_b(i) + 1;
               end
           end
        end
        fit_index_a(i) = 1/(1 + fit_index_a(i)/population_size)^5;
        fit_index_b(i) = 1/(1 + fit_index_b(i)/population_size)^5;
    end


    % Choise parents 
    S_a = sum(fit_index_a);
    S_b = sum(fit_index_b);
    k = population_size;
    rn_a = randn(1,k);
    rn_a = rn_a + abs(min(rn_a));
    rn_a = rn_a * (S_a/max(rn_a));
    
    rn_b = randn(1,k);
    rn_b = rn_b + abs(min(rn_b));
    rn_b = rn_b * (S_b/max(rn_b));
    temp_parent_a = [];
    temp_parent_b = [];

    new_parents_a = zeros(k,2);
    new_parents_b = zeros(k,4);
    for i = 1:population_size
            k = 0;
            rn0 = 0;
%             Parent A
            for j = 1:population_size
                k = j;
                if ((rn_a(i) >= rn0) && (rn_a(i) < (rn0 + fit_index_a(j))))
    %                 fprintf('get %f rand parent %f, index %d\n', rn(i) , rn0, k)
                    break
                end
                rn0 = rn0 + fit_index_a(j);
            end
            chromosome = population_a(k,:);
            new_parents_a(i, :) = chromosome;
            k = 0;
            rn0 = 0;
%             Parent B
            for j = 1:population_size
                k = j;
                if ((rn_b(i) >= rn0) && (rn_b(i) < (rn0 + fit_index_b(j))))
    %                 fprintf('get %f rand parent %f, index %d\n', rn(i) , rn0, k)
                    break
                end
                rn0 = rn0 + fit_index_b(j);
            end
            chromosome = population_b(k,:);
            new_parents_b(i, :) = chromosome;
    end
    
    childs_a = zeros(population_size, 2);
    childs_b = zeros(population_size, 4);
    for i = 1:population_size
        
%         Child item A
        parent1 = new_parents_a(randi([1,size(new_parents_a,1)]), :);
        parent2 = new_parents_a(randi([1,size(new_parents_a,1)]), :);
    %             crossover
        
        chromosome = parent1 + parent2;
        chromosome = chromosome / 2;
    %             mutation
        r = rand();
        if (r>k_mutation)
            rni = randperm(2, 2);
            temp = chromosome(rni(1));
            if (chromosome(rni(1)) > chromosome(rni(2)))
                z = chromosome(rni(1)) / 3;
            else 
                z = chromosome(rni(2)) / 3;
            end
            chromosome(rni(1)) = chromosome(rni(2)) + z;
            chromosome(rni(2)) = temp - z;
            
        end

        childs_a(i, :) = chromosome;
        
%         Child item B
        parent1 = new_parents_b(randi([1,size(new_parents_b,1)]), :);
        parent2 = new_parents_b(randi([1,size(new_parents_b,1)]), :);
    %             crossover
        chromosome = parent1 + parent2;
        chromosome = chromosome / 2;
    %             mutation
        r = rand();
        if (r>k_mutation)
            
            if (true)%randi(2) == 1)
%                 swap
                rni = randperm(4, 2);
                temp = chromosome(rni(1));
                if (chromosome(rni(1)) > chromosome(rni(2)))
                    z = chromosome(rni(1)) / 3;
                else 
                    z = chromosome(rni(2)) / 3;
                end
                chromosome(rni(1)) = chromosome(rni(2)) + z;
                chromosome(rni(2)) = temp - z;
            else
                
%             diff
                rni = randperm(4, 2);
                temp = chromosome(rni(1));
                if (chromosome(rni(1)) < chromosome(rni(2)))
                    z = chromosome(rni(1)) / 3;
                else 
                    z = chromosome(rni(2)) / 3;
                end
                chromosome(rni(1)) =  chromosome(rni(1)) + z;
                chromosome(rni(2)) = chromosome(rni(2)) - z;
                
            end
        end

        childs_b(i, :) = chromosome;
    end
%         return
    population_a = childs_a;
    population_b = childs_b;
end

figure
title('U')
hold on
plot(u_mean_a)
MEAN_a = mean(u_sum_a);
MEAN_b = mean(u_sum_b);
[C_a, I] = min(u_sum_a);
[C_b, I_b] = min(u_sum_b);
fprintf('\nU_a = %f\n', MEAN_a);
fprintf('U_b = %f\n', MEAN_b);
fprintf('p* = %f\n', population_a(I,:))
fprintf('q* = %f\n', population_b(I_b,:))
