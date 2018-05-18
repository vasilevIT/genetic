clc
clear all
population_size = 20;
chromosome_size = 60;
chromosome_min_value = 0;
chromosome_max_value = 79;
f1 = '0.2 * (u1 - 70)^2 + 0.8 * (u2-20)^2';
f2 = '0.2 * (u1 - 10)^2 + 0.8 * (u2-70)^2';
epoch = 1;
population = initPopulation(population_size, chromosome_size);
epoch_index = 1;
trand = zeros(epoch, 2);
while(true)
    % rating
    f_results = zeros(population_size, 2);
    for i = 1:population_size
        z = population(i,:);
        z1 = z(1:fix(chromosome_size/2));
        z2 = z(fix(chromosome_size/2)+1: chromosome_size);
        l1 = chromosomeDecode(z1);
        u1 = chromosomeGetFloat(l1, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
        l2 = chromosomeDecode(z2);
        u2 = chromosomeGetFloat(l2, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
        f_value1 = Fx(f1,u1,u2);
        f_value2 = Fx(f2,u1,u2);
        f_results(i, :) = [f_value1, f_value2];
    end
    figure 
    plot(f_results(:,1), f_results(:,2), '.')
    % calc fit index
    b = zeros(1,population_size);
    fit_index = zeros(1,population_size);
    for i = 1:population_size
        for j = 1:population_size
            if ((i~=j) && ((f_results(i,1) > f_results(j,1)) && (f_results(i,2) > f_results(j,2))))
                b(i) = b(i) + 1;
            end
        end
        fit_index(i) = 1/ (1 + (b(i)/ (population_size - 1)))^1;
    end
    S = sum(fit_index);
    k = population_size;
    rn = randn(1,k);
    rn = rn + abs(min(rn));
    rn = rn * (S/max(rn));
    parents = zeros(k,chromosome_size);
    for i = 1:size(rn,2)
        k = 0;
        if (b(i) == 0)
            hold on
            plot(f_results(i,1),f_results(i,2), 'o')
        end
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
%     break

    % crossing over
    childs = zeros(population_size, chromosome_size);
    for i = 1:population_size
        parent1 = parents(randi([1,size(parents,1)]), :);
        parent2 = parents(randi([1,size(parents,1)]), :);
        chromosome = crossing_over(parent1, parent2);
        childs(i, :) = chromosome;
    end

    population = childs;
%     get new function value fromm childs
    f_results_childs = zeros(population_size, 2);
    for i = 1:population_size
        z = population(i,:);
        z1 = z(1:fix(chromosome_size/2));
        z2 = z(fix(chromosome_size/2)+1: chromosome_size);
        l1 = chromosomeDecode(z1);
        u1 = chromosomeGetFloat(l1, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
        l2 = chromosomeDecode(z2);
        u2 = chromosomeGetFloat(l2, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));

        f_value1 = Fx(f1,u1,u2);
        f_value2 = Fx(f2,u1,u2);
        f_results_childs(i, :) = [f_value1, f_value2];
    end
    trand(epoch_index,:) = min(f_results)';
    
    if (epoch_index == 1)
        disp(min(f_results))
        disp(min(f_results_childs))
    end
    % check quality
    if (epoch_index >= epoch)
        disp(min(f_results))
        disp(min(f_results_childs))
        break;
    end
    epoch_index = epoch_index + 1;
end

%  figure
%  plot(trand(:, 1),trand(:, 2), 'o');
%  legend('u1','u2');
%  fprintf('Best decision')
% population