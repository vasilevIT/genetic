function [ min_dist ] = evaluate_population( population, inc_matrix, points, epoch )
%EVALUATE_POPULATION Summary of this function goes here
%   Detailed explanation goes here
    N = size(population, 2);
    population_size = size(population, 1);
    dists = zeros(population_size, 1);
    for i = 1:population_size
        dist = 0;
        for j = 1:N-1
            dist = dist + inc_matrix(population(i,j), population(i,j+1));
        end
        dists(i) = dist;
%         fprintf('Path length is %f for %d population item\n', dist, i);
    end
    [C,best_i] = min(dists);
    fprintf('Epoch #%d Min lenfth %f of %d item\n', epoch, C, best_i);
    min_dist = C;
    % plot best path
    x = [];
    y = [];
    % first point
    if (mod(epoch, 5) == 0)
        figure
        title(sprintf('Epoch #%d\nGraph min length %f', epoch, C));
        hold on
        plot(points(:, 1), points(:, 2), 'o'); 
        hold on 
        plot(points(population(best_i,1),1), points(population(best_i,1),2), 'o', 'color', 'g');
        dist = 0;
        for i = 1:N
        hold on
        x(i) = points(population(best_i,i),1);
        y(i) = points(population(best_i,i),2);
        end
        plot(x,y);
    end
end

