clc,clear all
% Quantity epoch
N= 100;
M = [5,4,3,2;
    1,4,4,7];
p_reference = [0.6, 0.4];
q_reference = [0.2, 0, 0.8, 0];
u_reference = 3.4;
p = zeros(2,1);
p = p + [0.9; 0.1];
p2 = [0.1; 0.9];
p3 = [0.4; 0.6];
p4 = [0.7; 0.3];
q = zeros(4,1)+1/4;
q2 = [0.5; 0.2; 0.1; 0.2];
q3 = [0.4; 0.2; 0.1; 0.3];
q4 = [0.2; 0.4; 0.3; 0.1];
u = 0;
population_size = 20;
N = 350;
k_mutation = 0.95;
population = [];

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
   population(i, :) =  [temp_p' temp_q'];
end

game_length = 100;
u_mean = [];
% calculate
for epoch = 1:N
    u_sum = [];
    fit_index = [];
    for i = 1: population_size
        ui = 0;
        for k = 1: game_length
            p1 = rand();
            q1 = rand(); 
            ai = 1;
            ai2 = 2;
            if (p1>population(i,1))
                ai = 2;
                ai2 = 1;
            end
            bi = 1;
            r0 = 0;
            for j = 1:4
                if (q1>r0 && q1<r0+population(i,2+j))
                    bi = j;
                    break;
                end
                r0 = r0 + population(i,2+j);
            end
            u1 = M(ai, bi);
            u2 = M(ai2, bi);
            ui = ui + (u1 + u2)/2;
        end
        u_sum(i) = ui/game_length;
    end
    if (mod(epoch, int8(N/5)) == 0 || epoch < 5)
        figure
        title(sprintf('Epoch %d', epoch));
    %     plot(u_sum);
        hold on
        plot([0, 1], [0, 1], '.')
        hold on
        plot(population(:,1),population(:,2), 'o')
    end
    
    u_mean(epoch) = mean(u_sum);

    for i = 1: population_size
        fit_index(i) = 0;
        for j = 1:population_size
           if (i~=j)
               if (u_sum(i) > u_sum(j))
                   fit_index(i) = fit_index(i) + 1;
               end
           end
        end
        fit_index(i) = 1/(1 + fit_index(i)/population_size)^5;
    end


    % Choise parents
    S = sum(fit_index);
    k = population_size;
    rn = randn(1,k);
    rn = rn + abs(min(rn));
    rn = rn * (S/max(rn));
    temp_parent = [];

    new_parents = zeros(k,6);
    for i = 1:size(rn,2)
            k = 0;
            rn0 = 0;
            for j = 1:population_size
                k = j;
                if ((rn(i) >= rn0) && (rn(i) < (rn0 + fit_index(j))))
    %                 fprintf('get %f rand parent %f, index %d\n', rn(i) , rn0, k)
                    break
                end
                rn0 = rn0 + fit_index(j);
            end
            chromosome = population(k,:);
            new_parents(i, :) = chromosome;
    end

    childs = zeros(population_size, 6);
    for i = 1:population_size
        parent1 = new_parents(randi([1,size(new_parents,1)]), :);
        parent2 = new_parents(randi([1,size(new_parents,1)]), :);
    %             crossover
        chromosome = parent1 + parent2;
        chromosome = chromosome / 2;
        if (randi(2) == 1)
        chromosome(1:2) = parent1(1:2);
        else
        chromosome(3:6) = parent2(3:6);
        end
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
        
        r = rand();
        if (r>k_mutation)
            rni = randperm(4, 2) + 2;
            temp = chromosome(rni(1));
             if (chromosome(rni(1)) > chromosome(rni(2)))
                z = chromosome(rni(1)) / 4;
             else 
                 z = chromosome(rni(2)) / 4;
             end
            chromosome(rni(1)) = chromosome(rni(2));
            chromosome(rni(2)) = temp;
        end

        childs(i, :) = chromosome;
    end
    population = childs;
end

figure
title('U')
hold on
plot(u_mean)
MEAN = mean(u_sum);
[C, I] = min(u_sum);
fprintf('\nU = %f\n', MEAN);
fprintf('p* = %f\n', population(I,1:2))
fprintf('q* = %f\n', population(I,3:6))
