function [ population_decode ] = decodePopulation( population, gen_size )
%DECODEPOPULATION Summary of this function goes here
%   Detailed explanation goes here
    population_decode = [];
    population_size = size(population, 1);
    N = fix(size(population, 2)/gen_size);
    for i = 1:population_size
        for j = 1:N
            population_decode(i, j) = chromosomeGetBitFloat(population(i,(j-1)*gen_size + 1:(j*gen_size)));
        end
    end

end

