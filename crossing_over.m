function chromosome = crossing_over(parent1, parent2)
n = size(parent1, 2);
index = randi([1,n-2]);
% parent1(index) = parent2(index);
chromosome = [parent1(1:index) , parent2(index+1:n)];
chromosome = mutation(chromosome);