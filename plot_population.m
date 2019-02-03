function [ output_args ] = plot_population( population, epoch_number )
%PLOT_NASH Summary of this function goes here
%   Detailed explanation goes here
    N = size(population, 1);
    figure
    title(sprintf('Epoch #%d', epoch_number));
    chromosome_size = 64;
    chromosome_min_value = 0;
    chromosome_max_value = 79;
    hold on;
    for i = 1:N
        z = population(i,:);
        z1 = z(1:fix(chromosome_size/2));
        z2 = z(fix(chromosome_size/2)+1: chromosome_size);
        l1 = chromosomeDecode(z1);
        u1 = chromosomeGetFloat(l1, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
        l2 = chromosomeDecode(z2);
        u2 = chromosomeGetFloat(l2, chromosome_min_value, chromosome_max_value, fix(chromosome_size/2));
        
        plot(u1, u2, 'o','color', 'r');
        hold on;
    end
    hold on
    xlabel('u1');
    ylabel('u2');
    axis([-20 110 0 110]);
%     Draw circles
    plot_circle(20, 70, 20, 1, 2);
    plot_circle(20, 70, 50, 1, 2);
    plot_circle(20, 70, 90, 1, 2);
    plot_circle(20, 70, 120, 1, 2);
  
    plot_circle(70, 20, 20, 2, 1);
    plot_circle(70, 20, 50, 2, 1);
    plot_circle(70, 20, 90, 2, 1);
    plot_circle(70, 20, 120, 2, 1);
end
