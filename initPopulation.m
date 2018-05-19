function result = initPopulation(n, size_chromosome)
result = zeros(n,size_chromosome);
for i = 1:n
%     chromosome = chromosomeEncode(abs(rand() * 10), size_chromosome);
    result(i, :) = randi([0,1],1,size_chromosome);
end