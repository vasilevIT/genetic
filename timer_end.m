function [ output_args ] = timer_end( message )
%TIMER_END Summary of this function goes here
%   Detailed explanation goes here
    global DEBUG_VALUE;
    if (DEBUG_VALUE)
        if (message)
            disp(message)
        end
        disp(toc)
    end
        
end

