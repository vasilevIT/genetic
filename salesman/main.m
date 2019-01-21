clc
clear all

% Init params
chromosome_size = 64;
N = 50; % Quantity points
max_epoch = 50;
population_size = 15;
results = [];

% Gen circle
circle_center = 10;
circle_r = 5;
points = zeros(N+1, 3);

t = [0:pi/(N)*2:2*pi];
points(:, 1) = circle_r * cos(t) + circle_center; 
points(:, 2) = circle_r * sin(t) + circle_center; 
figure
title('Graph');
hold on
plot(points(:, 1), points(:, 2), 'o'); 

i = 1;
alpabet = [];
for c = 1:150
    alpabet(i) = c;
    i = i + 1;
end
for i = 1:N
    points(i, 3) = alpabet(i);
end

% Calc incidence matrix
inc_matrix = zeros(N);
for i = 1:N
    for j = 1:N
        if (i ~= j)
            p1 = points(i,:);
            p2 = points(j,:);
            dist = sqrt(((p2(1) - p1(1))^2 + (p2(2) - p1(2))^2));
%             hold on
%             plot([p1(1), p2(1)], [p1(2), p2(2)]);
    
            inc_matrix(i,j) = dist;
        end
    end
end

% Gen population
population = zeros(population_size, N);
for i = 1:population_size
    chromosome = zeros(N, 1);
    randindexes = randperm(N, N);
    for j = 1:N
        index =  randindexes(j);
        chromosome(j) = index;
    end
    population(i,:) = chromosome;
end

% plot first path
x = [];
y = [];
% first point
hold on 
plot(points(population(1,1),1), points(population(1,1),2), 'o', 'color', 'g');
dist = 0;
for i = 1:N
hold on
x(i) = points(population(1,i),1);
y(i) = points(population(1,i),2);
end
plot(x,y);

results(1) = evaluate_population(population, inc_matrix, points);


% Fit
for k = 1:max_epoch
%     Greed crossover
    new_population = zeros(population_size, N);
    for i = 1:population_size
        new_chromosome = create_new_chromosome(i, population, inc_matrix);
        new_population(i, :) = new_chromosome;
        
    end
    results(k+1) = evaluate_population(new_population, inc_matrix, points);
    population = new_population;
%     break;
end

figure
title('Fit summary')
plot(results)
