function [ fit_index ] = get_pareto( f_results )
%GET_PARETO Summary of this function goes here
%   Detailed explanation goes here
    N = size(f_results, 1);
    b = zeros(1,N);
    fit_index = zeros(1,N);
    for i = 1:N
        for j = 1:N
            if ((i~=j) && ((f_results(i,1) > f_results(j,1)) && (f_results(i,2) > f_results(j,2))))
                b(i) = b(i) + 1;
            end
        end
        fit_index(i) = 1/ (1 + (b(i)/ (N - 1)))^1;
    end

end

