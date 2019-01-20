function [ output_args ] = timer_start( message )
%TIMER_START Summary of this function goes here
%   Detailed explanation goes here
    global DEBUG_VALUE;
    if (DEBUG_VALUE)
        tic
    end
end

