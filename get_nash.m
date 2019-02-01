function [ fit_index ] = get_nash( f_results, population)
%GET_NASH Summary of this function goes here
%   Detailed explanation goes here
    N = size(f_results, 1);
    b = zeros(1,N);
    b2 = zeros(N, 2);
    fit_index_vect = zeros(N, 2);
    fit_index = zeros(1, N);
%     Walk for func results
    for i = 1:N
        T1 = f_results(i,1);
%         Freeze first var
        u1 = population(i,1);
        T2 = f_results(i,2);
%         Freeze second var
        u2 = population(i,2);
        for j = 1:N
            if (i~=j)
                temp_result = Fuu1(population(j, 1), u2);
                if (temp_result < T1)
                   b2(i,1) =  b2(i,1) + 1;
                end
                temp_result = Fuu2(u1, population(j, 2));
                if (temp_result < T2)
                   b2(i,2) =  b2(i,2) + 1;
                end
            end
        end
        
%         Calculating fitness index
        fit_index_vect(i, 1) = 1/ (1 + (b2(i, 1)/ (N - 1)))^4;
        fit_index_vect(i, 2) = 1/ (1 + (b2(i, 2)/ (N - 1)))^4;
        fit_index(i) = (fit_index_vect(i, 1) + fit_index_vect(i, 2)) / 2;
    end

end

