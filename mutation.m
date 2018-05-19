function [ chromosome ] = mutation( chromosome , mutation_type)
%MUTATION Mutation factory
    if (nargin == 1)
        mutation_type = 'bit';
    end
    if (randi([1,10]) ~= 5)
        return;
    end
    if (strcmp(mutation_type, 'bit'))
        chromosome = mutation_bit(chromosome);
    end
    if (strcmp(mutation_type, 'multiple_bit'))
        chromosome = mutation_multiple_bit(chromosome);
    end
    if (strcmp(mutation_type,'point'))
        chromosome = mutation_point(chromosome);
    end
    if (strcmp(mutation_type, 'multiple_point'))
        chromosome = mutation_multiple_point(chromosome);
    end
    if (strcmp(mutation_type, 'inversion'))
        chromosome = mutation_point_inversion(chromosome);
    end
    if (strcmp(mutation_type, 'multiple_inversion'))
        chromosome = mutation_multiple_inversion(chromosome);
    end


end

