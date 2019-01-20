function [ output_args ] = timer_end( message )
%TIMER_END Summary of this function goes here
%   Detailed explanation goes here
   return
    if (message)
        disp(message)
    end
    disp(toc)

        
end

