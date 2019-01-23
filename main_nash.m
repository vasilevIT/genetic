clc
clear all

DEBUG_VALUE = true;

timer_start()
max_epoch = 1500;
population_size = 50;
chromosome_size = 64;
chromosome_min_value = 0;
chromosome_max_value = 79;
stop_condition = 0.9;
f1 = '0.2 * (u1 - 70)^2 + 0.8 * (u2-20)^2';
f2 = '0.2 * (u1 - 10)^2 + 0.8 * (u2-70)^2';
f1 = inline(f1);
f2 = inline(f2);
populations = {};
f_results_full = {};
population = initPopulation(population_size, chromosome_size);
populations = [populations, population];
epoch_index = 1;
trand = zeros(max_epoch, 2);
timer_end('init_params')
while(true) 
    % rating
    timer_start()
    f_results = zeros(population_size, 2);
    f_vars = zeros(population_size, 2);
    for i = 1:population_size
        z = population(i,:);
        z1 = z(1:fix(chromosome_size/2));
        z2 = z(fix(chromosome_size/2)+1: chromosome_size);
        l1 = chromosomeDecode(z1);
        u1 = chromosomeGetFloat(l1, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
        l2 = chromosomeDecode(z2);
        u2 = chromosomeGetFloat(l2, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
        f_value1 = Fuu1(u1,u2);
        f_value2 = Fuu2(u1,u2);
        f_results(i, :) = [f_value1, f_value2];
        f_vars(i, :) = [u1, u2];
    end
    timer_end('calc values for population')

    % calc fit index
    timer_start();
    fit_index = get_nash(f_results, f_vars);
    f_results_full = [f_results_full, fit_index];
    S = sum(fit_index);
    k = population_size;
    rn = randn(1,k);
    rn = rn + abs(min(rn));
    rn = rn * (S/max(rn));
    timer_end('calculating nash set')
    
    accuracy = sum(fit_index >= 0.9)/size(fit_index, 2);
    
    parents = zeros(k,chromosome_size);
    timer_start();
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
        parents(i, :) = chromosome;
    end
    timer_end('Form parent list')
    if ((epoch_index == 1) || (epoch_index >= max_epoch) || accuracy > stop_condition)
         plot_nash(f_results, fit_index,epoch_index);
    end

    % crossing over
    timer_start()
    childs = zeros(population_size, chromosome_size);
    for i = 1:population_size
        parent1 = parents(randi([1,size(parents,1)]), :);
        parent2 = parents(randi([1,size(parents,1)]), :);
        chromosome = crossing_over(parent1, parent2, 'multiple_point');
        childs(i, :) = chromosome;
    end
    timer_end('Crossing over')

    population = childs;
    populations = [populations, population];
%     get new function value fromm childs

    if (epoch_index == 1 || epoch_index >= max_epoch || accuracy > stop_condition)
        f_results_childs = zeros(population_size, 2);
        for i = 1:population_size
            z = population(i,:);
            z1 = z(1:fix(chromosome_size/2));
            z2 = z(fix(chromosome_size/2)+1: chromosome_size);
            l1 = chromosomeDecode(z1);
            u1 = chromosomeGetFloat(l1, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
            l2 = chromosomeDecode(z2);
            u2 = chromosomeGetFloat(l2, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));

            f_value1 = Fuu1(u1,u2);
            f_value2 = Fuu2(u1,u2);
            f_results_childs(i, :) = [f_value1, f_value2];
        end
    end
    
    if (epoch_index == 1)
       % disp(min(f_results))
       % disp(min(f_results_childs))
    end
    % check end cycle
    if ((epoch_index >= max_epoch) || (accuracy > stop_condition))
       % disp(min(f_results))
        %disp(min(f_results_childs))
        break;
    end
    epoch_index = epoch_index + 1;
end
disp(f_vars);
