function [ u ] = chromosomeGetBitFloat( gen )
%CHROMOSOMEGETBITFLOAT Summary of this function goes here
%   Detailed explanation goes here
    l1 = chromosomeDecode(gen);
    u = l1/10000;

end

