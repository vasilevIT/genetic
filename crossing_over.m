function chromosome = crossing_over(parent1, parent2, type)
% Crossover factory
% @var integer[] parent1 - first parent
% @var integer[] parent2 - second parent
% @var string type - crossover type
    if (nargin == 1)
        type = 'simply_point';
    end
    if (strcmp(type, 'simply_point'))
        chromosome = crossing_over_simple_point(parent1, parent2);
    end
    if (strcmp(type, 'multiple_point'))
        chromosome = crossing_over_multiple_point(parent1, parent2);
    end
    if (strcmp(type, 'sorting'))
        chromosome = crossing_over_sorting(parent1, parent2);
    end
    if (strcmp(type, 'partially'))
        chromosome = crossing_over_sorting(parent1, parent2);
    end
    if (strcmp(type, 'universal'))
        chromosome = crossing_over_universal(parent1, parent2);
    end
    if (strcmp(type, 'greed'))
        chromosome = crossing_over_greed(parent1, parent2);
    end
end