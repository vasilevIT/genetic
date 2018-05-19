function [ chromosome ] = mutation_multiple_bit( chromosome, k)
%MUTATION_POINT Function is make multiple point mutation in chromosome
% @var integer[] chromosome - array bit
% @var integer k - number point mutation
    if (nargin == 1)
        k = 5;
    end
    
    n = size(chromosome, 2);
    rand_indexes = randi([1,n], 1,k);
    for i = 1:k
        if (chromosome(rand_indexes(i)) == 0)
            chromosome(rand_indexes(i)) = 1;
        else
            chromosome(rand_indexes(i)) = 0;
        end
    end

end

