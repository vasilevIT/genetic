function [ chromosome ] = mutation_point_inversion( chromosome)
%MUTATION_POINT_INVERSION Summary of this function goes here
%   Detailed explanation goes here
    n = size(chromosome, 2) - 1;
    rand_index = randi([1,n]);
    chromosome = [chromosome(1:rand_index), fliplr(chromosome(rand_index + 1:end))];
  
end

