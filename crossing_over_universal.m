function [ chromosome ] = crossing_over_universal( parent1, parent2 )
%CROSSING_OVER_UNIVERSAL Summary of this function goes here
%   Detailed explanation goes here

    n = size(parent1, 2);
    mask = randi([0,1],1,n);
    if (randi([0,1]))
        chromosome = xor(parent1, mask);
    else
        chromosome = xor(parent2, mask);
    end

end

