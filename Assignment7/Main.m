% Main.m
% This is the main program to call other subprogram
% B11501037 Po-Tao, Lin
% CE3
clear; close all;
%% Part 0
% using OpenFOAM to simulate
%% Part 1 read openFOAM result and resave file.
for i = 1:4 
    meshtype = i;
    processContour;
end
%%

% read the file with most high resolution
meshtype = 1;
processData; % use the program teacher offers.
clear; close all; 

%% Part 2 Plot
%% Part 2-1 different grid
% plot the figure of different grid resolution
% and also print the global error
figuregrid; %
%% Part 2-2 different moment
% plot the figure of different moment with high resolution
figuremoment
%% Part 2-3 finersolution
figuresolution; %
%% Part 2-3 group velocity
figuregroupvelocity; % plot group velocity by 
%% Part 2-4 pressure
figurepressure; %print and compare the pressure distribution