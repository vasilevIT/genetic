function [ chromosome ] = mutation_multiple_point( chromosome, k)
%MUTATION_MULTIPLE_POINT Summary of this function goes here
%   Detailed explanation goes here
% @var integer k - number point mutation
    if (nargin == 1)
        k = 5;
    end

    n = size(chromosome, 2) - 1;
    rand_indexes = randi([1,n], 1,k);
    for i = 1:k
        x = chromosome(rand_indexes(i));
        chromosome(rand_indexes(i)) = chromosome(rand_indexes(i) + 1);
        chromosome(rand_indexes(i) + 1) = x;
    end

end

