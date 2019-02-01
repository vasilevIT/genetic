function [ output_args ] = plot_circle( circle_center_x, circle_center_y, circle_r, horizontal, vertical )
%PLOT_CIRCLE Summary of this function goes here
%   Detailed explanation goes here
    
    N_points = circle_r*2;
    points = zeros(N_points+1, 3);

    t = [0:pi/(N_points)*2:2*pi];
    points(:, 1) = (circle_r * cos(t) + circle_center_x)  ./vertical; 
    points(:, 2) = (circle_r * sin(t) + circle_center_y) ./ horizontal;
    hold on
    plot(points(:, 1), points(:, 2), 'b.'); 

end

