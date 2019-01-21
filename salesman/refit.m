function [ chromosome ] = refit( i, population, chromosome, inc_matrix )
%REFIT Summary of this function goes here
%   Detailed explanation goes here

            
            N = size(population, 2);
            population_size = size(population, 1);
            for j = 1:N
                if (size(find(population(1,j) == chromosome,1),2) == 0)
                    chrom_l = population(1,j);
                end  
            end
%             fprintf('\n\nAdd new gen %d, index %d\n', chrom_l, i);
%             fprintf('In population %s\n', chromosome);
    
            if (sum(chromosome == 0) == 1)
                chromosome(N) = chrom_l;
            end
            if (sum(chromosome == 0) > 1)
                
                    chromosome(i) = chrom_l;
                    i = i + 1;
                    while (i <= N)
                    pop_index = greed_step(chrom_l, population, chromosome, inc_matrix);
                    if (pop_index == 0)
                        chromosome = refit(i, population, chromosome, inc_matrix);
                        return;
                    end
                    
                    chrom_l_index = find(population(pop_index,:) == chrom_l, 1);
                    chrom_r_index = chrom_l_index + 1;
                    if (chrom_l_index == N)
                        chrom_r_index = 1;
                    end
                    chromosome_item = population(pop_index, chrom_r_index);
%                     fprintf('\n--recursive-- Add new gen %d, index %d\n', chrom_l,i);
%                     fprintf('--recursive-- In population %s\n', chromosome);
                    chromosome(i) = chromosome_item;
                    i = i + 1;
                    end
                
            end

end

