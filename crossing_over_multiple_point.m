function [ chromosome ] = crossing_over_multiple_point( parent1, parent2, k )
%CROSSING_OVER_MULTIPLE_POINT Summary of this function goes here
%   Detailed explanation goes here
% @var integer k - number crossover blocks
    if (nargin == 2)
        k = 5;
    end
    
    chromosome = parent1;
    
    even_block = randi([0,1]);
    
    n = size(parent1, 2) - 1;
    rand_indexes = sort(unique(randi([1,n], 1,k)));
    prev_index = 1;
    for i = 1:size(rand_indexes,2)
        if (i == size(rand_indexes,2))
            end_index = size(chromosome, 2);
        else
            end_index = rand_indexes(i);
        end
        if (mod(i, 2) == ~even_block)
            chromosome(prev_index:end_index) = parent2(prev_index:end_index);
        end
        prev_index = rand_indexes(i);
    end

end

