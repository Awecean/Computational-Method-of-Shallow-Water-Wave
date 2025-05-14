% Main Program
% This is the main program of Assignment 6
% B11501037 Po-Tao, Lin
clear; close all;
%% -------Part 1 initial condition--------
%% Part 1 InitialCondtion
dxlist = [0.0125,0.025, 0.05, 0.1, 0.2]; % the x-space(dx), in meter
for dx_index = 1:5
    dx = dxlist(dx_index); % set dx
    initialparameter % run this program generate initial data
end
%% -------Part 2 Simulate Procedure-------
%% Part 2-1 Nonlinear shallow water equation(NSWE)
for dx_index = 1:5
   fprintf('start run dx_index = %d\n', dx_index);
   simulate_NSWE;% read, simulate, record
   fprintf('start simulation dx_index = %d\n', dx_index);
end
%% Part 2-2 Linear shallow water equation(LSWE)
for dx_index = 1:5
   fprintf('start run dx_index = %d\n', dx_index);
   simulate_LSWE; % read, simulate, record
   fprintf('start simulation dx_index = %d\n', dx_index);
end

%% -------Part 3 Visulization-------------
%% Part 3-1 Result with different grid space
% for each different space, plot the result at t = 3.5s
figuregrid; % read/save plot
%% Part 3-2 Result with different moment
% for the minimum dx, plot the result of different moments
figuremoment;
%% Part 3-3 Result with different moment
% for minimum dx, plot the result of NSWE and LSWE at t = 1, 2, 3 [s]
% to compare the result the wave propagation
figurealgorithm;
%% Part 3-4 Animation_NSWE
animation_NSWE;

