function [] = plot_pareto( f_results, pareto, epoch_number )
%PLOT_PARETO Summary of this function goes here
%   Detailed explanation goes here
    f_results
    N = size(f_results, 1);
    figure
    title(sprintf('pareto #%d', epoch_number));
    for i = 1:N
        if (pareto(i) == 1)
            hold on
            plot(f_results(i, 1),f_results(i, 2), 'o','color', 'g');
        elseif (pareto(i) > 0.8) 
            hold on
            plot(f_results(i, 1),f_results(i, 2), 'o','color', 'y');
        elseif (pareto(i) > 0.7) 
            hold on
            plot(f_results(i, 1),f_results(i, 2), 'o','color', [1, 0.5, 0]);
        else 
            hold on
            plot(f_results(i, 1),f_results(i, 2), 'o','color', 'r');
        end
    end

end

