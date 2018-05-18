function chromosome = crossing_over(parent1, parent2)
n = size(parent1, 2);
index = randi([1,n]);
parent1(index) = parent2(index);
chromosome = parent1;
if (randi([1,10]) == 5)
    rand_index = randi([1,n]);
    if (chromosome(rand_index) == 0)
        chromosome(rand_index) = 1;
    else
        chromosome(rand_index) = 0;
    end
end