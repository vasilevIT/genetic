function [ chromosome ] = create_new_chromosome(i, population, inc_matrix)
%CREATE_NEW_CHROMOSOME Summary of this function goes here
%   Detailed explanation goes here
    N = size(population, 2);
    population_size = size(population, 1);
    index = randi(N);
    if (index == 1)
        index = index + 1;
    end
    if (index == N)
        index = index -1;
    end
    temp_dists = [];
    chrom_l = population(i,index);
    chromosome = zeros(1, N);
    k = 1;
    for i = 1:N-1
        pop_index = greed_step(chrom_l, population, chromosome, inc_matrix);
        if (pop_index == 0)
            chromosome = refit(i, population, chromosome, inc_matrix);
            break;
%             chromosome(N) = chromosome(1);
        end
            
%         disp(pop_index);
%         chromosome
        chrom_l_index = find(population(pop_index,:) == chrom_l, 1);
        chrom_r_index = chrom_l_index + 1;
        if (chrom_l_index == N)
            chrom_r_index = 1;
        end
%         fprintf('\nitem #%d\n', k);
%         fprintf('best population #%d\n', pop_index);
%         fprintf('left chromosome %d\n',population(pop_index, chrom_l_index));
%         fprintf('right chromosome %d\n',population(pop_index, chrom_r_index));
        if (k == 1)
            chromosome(k) = population(pop_index, chrom_l_index); 
            k = k + 1;
        end
        chromosome_item = population(pop_index, chrom_r_index);
%         disp(chromosome_item);
        disp(find(chromosome == chromosome_item, 1));
        if (size(find(chromosome == chromosome_item, 1),2) == 1)
            disp('error');
            disp(pop_index);
            disp(chrom_l);
            disp(chromosome_item);
            disp(chromosome);
            continue
        end
        chromosome(k) = chromosome_item;
        k = k + 1;
        chrom_l = population(pop_index, chrom_r_index); 
%         fprintf('added chromosome %d', chrom_l);
    end
    
%     Make mutation
    rn = rand(1);
    if (rn > 0.98)
        rni = randperm(N, 2);
        temp = chromosome(rni(1));
        chromosome(rni(1)) = chromosome(rni(2));
        chromosome(rni(2)) = temp;
        fprintf('\nMutation\n');
    end
    
end

