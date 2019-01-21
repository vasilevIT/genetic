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
        disp(chromosome_item);
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
    
    return
    %{
    chrom_r = population(i,index + 1);
    temp_dists(1) = inc_matrix(chrom_l, chrom_r);
   
    for i = 2:population_size
        chrom_l_index = find(population(i,:) == chrom_l, 1);
        chrom_r_index = chrom_l_index + 1;
        inc_i1 = population(i,chrom_l_index);
        inc_i2 = population(i,chrom_r_index);
        temp_dists(i) = inc_matrix(inc_i1, inc_i2);
    end
    [C, min_index] = min(temp_dists);
    chrom_l_index = find(population(min_index,:) == chrom_l, 1);
    chrom_r_index = chrom_l_index + 1;
    chromosome(1) = population(min_index, chrom_l_index); 
    chromosome(2) = population(min_index, chrom_r_index);
%     next pass
    temp_dists2 = [];
    chrom_l = chromosome(2);
    chrom_r = population(min_index, chrom_r_index + 1);
    temp_dists(min_index) = inc_matrix(chrom_l, chrom_r);
    for i = 1:population_size
        chrom_l_index = find(population(i,:) == chrom_l, 1);
        chrom_r_index = chrom_l_index + 1;
        inc_i1 = population(i,chrom_l_index);
        inc_i2 = population(i,chrom_r_index);
        temp_dists2(i) = inc_matrix(inc_i1, inc_i2);
    end
    [C, min_index] = min(temp_dists);
    chrom_l_index = find(population(min_index,:) == chrom_l, 1);
    chrom_r_index = chrom_l_index + 1;
    chromosome(3) = population(min_index, chrom_r_index);
%}
end

