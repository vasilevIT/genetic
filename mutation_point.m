function [ chromosome ] = mutation_point( chromosome )
%MUTATION_POINT Summary of this function goes here
%   Detailed explanation goes here
    n = size(chromosome, 2) - 1;
    rand_index = randi([1,n]);
    x = chromosome(rand_index);
    chromosome(rand_index) = chromosome(rand_index + 1)
    chromosome(rand_index + 1) = x

end

