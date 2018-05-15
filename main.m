clc
clear all
population_size = 1;
chromosome_size = 10;
population = initPopulation(population_size, chromosome_size);
for i = 1:population_size
    z = population(i,:);
    l = chromosomeDecode(z);
    x = chromosomeGetFloat(l, 0, 79, chromosome_size);
end
