function [ population_normalize ] = normalize_population( population, gen_size )
%NORMALIZE_POPULATION Summary of this function goes here
%   Detailed explanation goes here
    
    population_normalize = [];
    population_size = size(population, 1);
    N = fix(size(population, 2)/gen_size);
    for i = 1:population_size
%         decoding
        gens = [];
        for j = 1:N
            gens(j) = chromosomeGetBitFloat(population(i,(j-1)*gen_size + 1:(j*gen_size)));
        end
%         normalize
        gens_norm = [];
        for j = 1:N
            gens_norm(j) = gens(j)/sum(gens);
        end
%         gens_norm
%         sum(gens_norm)
%         encoding
        chromosome = [];
        for j = 1:N
            chromosome((j-1)*gen_size + 1:j*gen_size) = chromosomeEncode(fix(gens_norm(j)*10000), gen_size);
%             chromosomeGetBitFloat(chromosome((j-1)*gen_size + 1:j*gen_size))
        end
        population_normalize(i, :) = chromosome;
%         return
    end


end

