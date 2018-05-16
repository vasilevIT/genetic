clc
clear all
population_size = 6;
chromosome_size = 20;
chromosome_min_value = 0;
chromosome_max_value = 79;
f1 = '0.2 * (u1 - 70)^2 + 0.8 * (u2-20)^2';
f2 = '0.2 * (u1 - 10)^2 + 0.8 * (u2-70)^2';

population = initPopulation(population_size, chromosome_size);
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

    % calc fit index
    b = zeros(1,population_size);
    fit_index = zeros(1,population_size);
    for i = 1:population_size
        for j = 1:population_size
            if ((i~=j) && (f_results(i,1) > f_results(j,1)) && (f_results(i,2) > f_results(j,2)))
                b(i) = b(i) + 1;
            end
        end
        fit_index(i) = 1/ (1 + (b(i)/ (population_size - 1)));
    end
    S = sum(fit_index);
    k = population_size / 2;
    rn = randn(1,k);
    rn = rn + abs(min(rn));
    rn = rn * (S/max(rn));
    parents = zeros(k,chromosome_size);
    for i = 1:size(rn,2)
        k = 0;
        rn0 = 0;
        for j = 1:population_size
            k = j;
            if ((rn(i) >= rn0) && (rn(i) < (rn0 + fit_index(j))))
                break
            end
            rn0 = rn0 + fit_index(j);
        end
        chromosome = population(k,:);
        parents(i, :) = chromosome;
    end

    % crossing over
    childs = zeros(population_size, chromosome_size);
    for i = 1:population_size
        parent1 = parents(randi([1,size(parents,1)]), :);
        parent2 = parents(randi([1,size(parents,1)]), :);
        chromosome = crossing_over(parent1, parent2);
        childs(i, :) = chromosome;
    end

    population = childs
    % check quality
    if (true)
        break;
    end
end
fprintf('Best decision')
population