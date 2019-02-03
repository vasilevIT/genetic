function [ pop_index ] = greed_step( chrom_l, population, chromosome, inc_matrix )
%GREED_STEP Summary of this function goes here
%   Detailed explanation goes here
    N = size(population, 2);
    population_size = size(population, 1);
    temp_dists = zeros(population_size, 1) + 99999;
    continues = 0;
    for i = 1:population_size
        chrom_l_index = find(population(i,:) == chrom_l, 1);
        chrom_r_index = chrom_l_index + 1;
        if (chrom_l_index == N)
            chrom_r_index = 1;
        end
        
        inc_i1 = population(i,chrom_l_index);
        inc_i2 = population(i, chrom_r_index);
        if (size(find(chromosome == inc_i2, 1), 2) == 1)
%             fprintf('continue gen %d in population %d\n', inc_i2, i);
%             disp(chromosome);
            continues = 1;
            continue;
        end
        temp_dists(i) = inc_matrix(inc_i1, inc_i2);
    end
    %{
 if (continues)
            disp(chromosome);
            fprintf('temp_dists\n');
            disp(temp_dists);
            fprintf('min temp_dists\n');
            disp(min(temp_dists));
end
    %}
    [C, min_index] = min(temp_dists);
%     fprintf('C = %d\n', C);
%     fprintf('empty values %d\n', sum(temp_dists == 99999));
    pop_index = min_index;
    if (C == 99999)
        pop_index = 0;
    end

end

