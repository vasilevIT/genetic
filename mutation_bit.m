function [ chromosome ] = mutation_bit( chromosome )
%MUTATION_POINT Function is make point mutation in chromosome
    n = size(chromosome, 2);
    rand_index = randi([1,n]);
    if (chromosome(rand_index) == 0)
        chromosome(rand_index) = 1;
    else
        chromosome(rand_index) = 0;
    end

end

