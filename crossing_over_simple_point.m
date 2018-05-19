function [ chromosome ] = crossing_over_simple_point( parent1, parent2 )
%CROSSING_OVER_SIMPLE_POINT Summary of this function goes here
%   Detailed explanation goes here

    n = size(parent1, 2);
    index = randi([1,n-2]);
    chromosome = [parent1(1:index) , parent2(index+1:n)];

end

