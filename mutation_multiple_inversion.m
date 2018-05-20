function [ chromosome ] = mutation_multiple_inversion( chromosome, k )
%MUTATION_MULTIPLE_INVERSION Summary of this function goes here
%   Detailed explanation goes here
% @var integer k - number point mutation
    if (nargin == 1)
        k = 10;
    end

    n = size(chromosome, 2) - 1;
    rand_indexes = sort(unique(randi([1,n], 1,k)));
    prev_index = 1;
    for i = 1:size(rand_indexes,2)
        if (i == size(rand_indexes,2))
            end_index = size(chromosome, 2);
        else
            end_index = rand_indexes(i + 1);
        end
        if (mod(i, 2) == 0)
            chromosome(prev_index:end_index) = [chromosome(prev_index:rand_indexes(i)), fliplr(chromosome(rand_indexes(i) + 1:end_index))];
        end
        prev_index = rand_indexes(i);
    end
  

end

