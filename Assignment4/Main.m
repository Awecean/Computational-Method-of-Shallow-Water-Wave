% Main program
% This is the Main program to call other program run Assignment 4
% B11501037 Po-Tao, Lin
clear; close all;
% Part 1 Initialfield
%% Part 1-1 initial field with flat bathymety
bathymetrytype = 'flat';
region = 'full';
for spaceindex = 1:5
    initialfield;
end
spaceindex = 1;
region = 'half'; initialfield;
region = 'quarter'; initialfield;
% Part 2 Simulate procedure
%% Part 2-1 full circular wave
bathymetrytype = 'flat'; region = 'full'; 
for spaceindex = 1:5
    simulate
end
%% Part 2-2 half circular wave
bathymetrytype = 'flat'; region = 'half'; spaceindex = 1;
simulate; %simulate
%% Part 2-3 quarter circular wave
bathymetrytype = 'flat'; region = 'quarter'; spaceindex = 1;
simulate; %simulate
% Part 3 plot-characteristic-check
%% Part 3-1 Convergence test
pconvergence
%% Part 3-2 Geometric decay amplitude
pgeometricdecay
%% Part 3-3 Radial Symmetry Check
pradialsymmetry
% Part 4 result-figure/animation
%% Part 4-1 figure of eta field
bathymetrytype = 'flat'; region = 'full'; spaceindex = 1;
figureeta
%% Part 4-2 figure of velocity field
figurevelocity
%% Part 4-3 animation of eta
animationmode = 1;%make animation
bathymetrytype = 'flat';
region = 'full';
spaceindex = 1;
simulate;
animationeta;
%% Part 4-4 figure recorded max eta
bathymetrytype = 'flat'; region = 'full'; spaceindex = 1;
figuremaxeta;
% Part 5 other
%% Part 5-1 initial field with specific bathmetry
region = 'full';spaceindex = 1;
bathymetrytype = 'slide'; initialfield;
bathymetrytype = 'abrupt'; initialfield;
bathymetrytype = 'plat'; initialfield;
%% Part 5-2 simulation with specifc bathymetry
region = 'full'; spaceindex = 1;
bathymetrytype = 'slide'; simulate;
bathymetrytype = 'abrupt'; simulate;
bathymetrytype = 'plat'; simulate;
%% Part 5-3 figure eta field
bathymetrytype = 'flat'; spaceindex = 1;
region = 'half';figureeta;
region = 'quarter';figureeta;
region = 'full'; spaceindex = 1;
bathymetrytype = 'slide'; figureeta;
bathymetrytype = 'abrupt'; figureeta;
bathymetrytype = 'plat'; figureeta;
%% Part 6 figure sponge-boundary
figuresponge