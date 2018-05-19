function [ chromosome ] = crossing_over_sorting( parent1, parent2 )
%CROSSING_OVER_SORTING Summary of this function goes here
%   Detailed explanation goes here

    throw(MException('MYFUN:NotImplemented', 'Function not implemented'));
    n = size(parent1, 2);
    index = randi([1,n-2]);
    chromosome = [parent1(1:index) , parent2(index+1:n)];
end

