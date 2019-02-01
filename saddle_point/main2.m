clc,clear all
addpath('./..');
% Quantity epoch
N= 200;
gen_size = 16;
chromosome_size_a = gen_size * 2;
chromosome_size_b = gen_size * 4;
game_length = 400;
M = [5,4,3,2;
    1,4,4,7];
p_reference = [0.6, 0.4];
q_reference = [0.2, 0, 0.8, 0];
u_reference = 3.4;
u = 0;
population_size = 30;
k_mutation = 0.95;
population_a = [];
population_b = [];

disp('Win matrix:');
disp(M);   

% Init population
for i = 1:population_size 
%     Player A
    p1 = rand();
    p2 = 1 - p1;
    
%     Player B
    q1 = rand();
    q2 = rand();
    q2 = q2*(1-q1);
    q3 = rand();
    q3 = q3*(1-q1-q2);
    q4 = rand();
    q4 = (1-q1-q2-q3);
    
%     binary encode
    z1 = chromosomeEncode(fix(p1*10000), gen_size);
    z2 = chromosomeEncode(fix(p2*10000), gen_size);
    
    zb1 = chromosomeEncode(fix(q1*10000), gen_size);
    zb2 = chromosomeEncode(fix(q2*10000), gen_size);
    zb3 = chromosomeEncode(fix(q3*10000), gen_size);
    zb4 = chromosomeEncode(fix(q4*10000), gen_size);
    population_a(i,:) = [z1 z2];
    population_b(i,:) = [zb1 zb2 zb3 zb4];
    
%     Check chromosome value
%{
    q2
    l1 = chromosomeDecode(zb2);
    l1/10000
%}
  
end

u_mean = [];
u_mean_a = [];
u_mean_b = [];
% calculate
for epoch = 1:N
    if ((mod(epoch,fix(N/100)) == 0) || (mod(epoch,fix(N/10)) == 0))
        fprintf('\nEpoch #%d\nU=%f\n', epoch, u);
    end
    population_a_decode = decodePopulation(population_a, gen_size);
    population_b_decode = decodePopulation(population_b, gen_size);
    u_sum = [];
    u_sum_a = [];
    u_sum_b = zeros(population_size, 1);
    fit_index = [];
%     loop for A player
    for i = 1: population_size
        ui = 0;
        ui_a = 0;
%         loop for B player
        for m = 1: population_size
            ui_b = 0;
            for k = 1: game_length
                p1 = rand();
                q1 = rand(); 
                ai = 1;
                ai2 = 2;
                if (p1 > population_a_decode(i,1))
                    ai = 2;
                    ai2 = 1;
                end
                bi = 1;
                r0 = 0;
                for j = 1:4
                    pb = population_b_decode(m, j);
                    if ((q1 > r0) && (q1 < (r0 + pb)))
                        bi = j;
                        break;
                    end
                    r0 = r0 + pb;
                end
                u1 = M(ai, bi);
                u2 = M(ai, bi);
                ui = ui + (u1 + u2)/2;
                ui_a = ui_a + u1;
                ui_b = ui_b + u2;
            end
        u_sum_b(m) = u_sum_b(m) + ui_b;
        end
        u_sum(i) = ui/game_length;
        u_sum_a(i) = ui_a/game_length/population_size;
    end
    u_sum_b = u_sum_b/game_length/population_size;
    
    if (mod(epoch, int8(N/5)) == 0 || epoch < 5)
        figure
        title(sprintf('Epoch %d', epoch));
    %     plot(u_sum);
        hold on
        plot([0, 1], [0, 1], '.')
        hold on
        plot(population_a_decode(:, 1),population_a_decode(:, 2), 'o')
    end
    
    u_mean(epoch) = mean(u_sum);
    u_mean_a(epoch) = mean(u_sum_a);
    u_mean_b(epoch) = mean(u_sum_b);
    u = (u_mean_a(epoch) + u_mean_b(epoch)) / 2;

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
        fit_index_a(i) = 1/(1 + fit_index_a(i)/population_size);
        fit_index_b(i) = 1/(1 + fit_index_b(i)/population_size);
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

    new_parents_a = [];
    new_parents_b = [];
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
    childs_a = [];
    childs_b = [];
    for i = 1:population_size
        
%         Child item A
        parent1 = new_parents_a(randi([1,size(new_parents_a,1)]), :);
        parent2 = new_parents_a(randi([1,size(new_parents_a,1)]), :);
    %             crossover 
        chromosome = crossing_over(parent1, parent2, 'multiple_point');
        childs_a(i, :) = chromosome;
        
%         Child item B
        parent1 = new_parents_b(randi([1,size(new_parents_b,1)]), :);
        parent2 = new_parents_b(randi([1,size(new_parents_b,1)]), :);
    %             crossover
        chromosome = crossing_over(parent1, parent2, 'multiple_point');
        childs_b(i, :) = chromosome;
    end
%         return
    population_a = childs_a;
    population_b = childs_b;
    
    population_a = normalize_population(population_a, gen_size);
    population_b = normalize_population(population_b, gen_size);
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
population_a_decode = decodePopulation(population_a, gen_size);
population_b_decode = decodePopulation(population_b, gen_size);
fprintf('p* = %f\n', population_a_decode(I,:))
fprintf('q* = %f\n', population_b_decode(I_b,:))
