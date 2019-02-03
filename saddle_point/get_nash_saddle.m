function [ fit_index ] = get_nash_saddle( population, M, verbose)
%GET_NASH Summary of this function goes here
%   Detailed explanation goes here

    if (nargin == 2)
        verbose = 0;
    end
    N = size(population, 1);
    b2 = zeros(N, 2);
    fit_index_vect = zeros(N, 2);
    fit_index = zeros(1, N);
%     Walk for population
    for i = 1:N
        T1 = population(i, 1:2)*M*population(i, 3:6)';
        if (verbose == 1)
            fprintf('Current u = %f \n', T1);
        end
%         Freeze first var
        u1 = population(i, 1:2);
%         Freeze second var
        u2 = population(i, 3:6);
        for j = 1:N
            if (i~=j)
                temp_result = population(j, 1:2)*M*u2';
                if (temp_result > T1)
                    if (verbose == 1)
                        fprintf('Best u for 1 player = %f \n', temp_result);
                    end
                   b2(i,1) =  b2(i,1) + 1;
                end
                temp_result = u1*M*population(j, 3:6)';
                if (temp_result < T1)
                    if (verbose == 1)
                         fprintf('Best u for 2 player = %f \n', temp_result);
                    end
                   b2(i,2) =  b2(i,2) + 1;
                end
            end
        end
        
%         Calculating fitness index
        fit_index_vect(i, 1) = 1/ (1 + (b2(i, 1)/ (N - 1)))^4;
        fit_index_vect(i, 2) = 1/ (1 + (b2(i, 2)/ (N - 1)))^4;
        fit_index(i) = (fit_index_vect(i, 1) + fit_index_vect(i, 2)) / 2;
    end
    if (verbose == 1)
        disp(fit_index_vect);
        disp(b2);
        disp(fit_index);
    end

end

