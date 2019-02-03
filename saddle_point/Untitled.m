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
population_size = 120;
k_mutation = 0.95;
population = [];

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
    population(i,:) = [z1 z2 zb1 zb2 zb3 zb4];
    
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
    population_decode = decodePopulation(population, gen_size);
    u_sum = [];
    fit_index = [];
%     loop for A player
    for i = 1: population_size
        ui = 0;
        ui_a = 0;
        u_sum(i) = population_decode(i, 1:2)*M*population_decode(i, 3:6)';
    end
    
    if (mod(epoch, int8(N/5)) == 0 || epoch < 5)
        figure
        title(sprintf('Epoch %d', epoch));
    %     plot(u_sum);
        hold on
        plot([0, 1], [0, 1], '.')
        hold on
        plot(population_decode(:, 1),population_decode(:, 2), 'o')
        %{
        figure
        title(sprintf('Ua %d', epoch));
    %     plot(u_sum);
        hold on
        plot([0, 1], [0, 1], '.')
        hold on
        subplot(2,1,1);
        plot(u_sum_a, 'b')
        subplot(2,1,2);
        plot(u_sum_b, 'r')
        %}
        
    end
    
    u_mean(epoch) = mean(u_sum);
    u = mean(u_sum);

    for i = 1: population_size
        fit_index(i) = 0;
        for j = 1:population_size
           if (i~=j)
                if ((u_sum(i) > u_sum(j)))
%                  if ((u_sum_b(i)<u_sum_b(j)))
                   fit_index(i) = fit_index(i) + 1;
               end
           end
        end
        fit_index(i) = 1/(1 + fit_index(i)/(population_size-1));
    end
%     figure;
%     plot(u_sum_a, u_sum_b, '+');
%     return;
   
    % Choise parents 
    S = sum(fit_index);
    k = population_size;
    rn = randn(1,k);
    rn = rn + abs(min(rn));
    rn = rn * (S/max(rn));

    new_parents = [];
    for i = 1:population_size
            k = 0;
            rn0 = 0;
%             Parent A
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
    childs = [];
    for i = 1:population_size
        
%         Child item
        parent1 = new_parents(randi([1,size(new_parents,1)]), :);
        parent2 = new_parents(randi([1,size(new_parents,1)]), :);
    %             crossover 
        chromosome = crossing_over(parent1, parent2, 'multiple_point');
        childs(i, :) = chromosome;
    end
%         return
    population = childs;
    
    population = normalize_population2(population, gen_size);
end

figure
title('U')
hold on
plot(u_mean)
MEAN_a = mean(u_sum);
[C_a, I] = min(u_sum);
fprintf('\nU = %f\n', MEAN_a);
population_decode = decodePopulation(population, gen_size);
fprintf('p* = %f\n', population_decode(I,1:2))
fprintf('q* = %f\n', population_decode(I,3:6))
