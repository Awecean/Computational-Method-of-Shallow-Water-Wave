% Assignment3
% b11501037 CE3
% Po-Tao, Lin
% These are also upload to https://github.com/Awecean/Computational-Method-of-Shallow-Water-Wave
clear all; close all;

%% Part 1 Parameter setting
%%% 1.1 data flat-bathmetry generarion 
baseset = 'flat';
for index = 1:5
    bathmetry; %generating the data x-step = [0.02*index]m with flat bathmetry       
end
clear all; % discard unncessary data;
%%% 1.2 data abrupt-depth-bathmetry generarion
baseset = 'abrupt'; index = 1; %only create a file x-step =0.02m
bathmetry;
clear all; % discard unncessary data;
%%% 1.3 data smoothed abrupt-depth-bathmetry generarion
baseset = 'abruptsmoothed';
for index = 1:5
    bathmetry; %generating the data x-step = [0.02*index]m      
end %this file will contain every moment's eta data
clear all; % discard unncessary data;

%% Part 2 Main Procedure (make plot)
if ~exist(fullfile(pwd, 'figure'), 'dir'), mkdir(fullfile(pwd, 'figure')); end 

key_abrupt = input('Is the bathmetry has abrupted(yes/no)','s');
switch key_abrupt
    case 'yes'
        key_smooth = input('smoothed abrupted depth(yes/no)','s');
        switch key_smooth
            case 'yes'
                disp('what is your need?');
                key_process = input('(e: error analysis/ s: snapshot of specifc integer time/ a: animation)','s');
                switch key_process
                    case 'e'
                        plotsae; % plot the moment t = 12s to analysis error
                        %case 
                    case 's'
                        disp('s')
                        disp('The specific integer moment?');
                        key_moment = str2num(input('(enter a integer in [0,20])','s'));
                        plotsas;
                    case 'a'
                        disp('It is an animation of wave propagation');
                        plotsaa;
                end               
            case 'no'
                plota; % this program plot a figure of Runge's phenomenon    
        end
    case 'no'
        ts = 6; % specific moment
        plotfe;
end
