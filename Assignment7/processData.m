% This script is written by Prof. Lo. Modified some (with* comment)
% this script loads paraView processed .csv files, map the data to a 
% rectangular grid, determine the free surface elevation eta using a basic 
% vertical scanning method, and save the results as a .mat file
%close all, 
%clear,

% [CHANGE THESE VALUES] user inputs

SAVE_NAME='dataType1.mat'; % file name to save .MAT
t=linspace(0,10,201); % *time instants of saved data
h0=0.2; % still water depth
filepath = 'datadata1';
dx=0.005; % x spacing of plotting grid
dz=0.0025; % z spacing of plotting grid
x=(0+dx/2):dx:(8-dx/2); % range of x for plotting
z=(0+dz/2):dz:(0.3-dz/2); % range of z for plotting

% initialization
[X,Z]=meshgrid(x,z); % generate xz-grid
[nz,nx]=size(X); % get node numbers
nt=length(t);
eta=zeros(nx,nt); % gridded free surface elevation
ALPHA=cell(nt,1); % gridded volume fraction of water
U=cell(nt,1); % gridded horizontal velocity
W=cell(nt,1); % gridded vertical velocity
P=cell(nt,1); % gridded total pressure

%=== PROCESS ALL CSV FILES ===
for ti=1:nt-1 % ti starts from 1 -> skip the 0.0 file (*There is a corrected)
    
    % load CSV file
    FILE_NAME=[filepath '/data0.' num2str(ti) '.csv'];
    data = csvread(FILE_NAME,1,0); % skip first line header
    
    % get data from CSV [note: if you save additional variables in 
    % ParaView, you will need to change the indices below] 
    data_x=data(:,6); % x coordinate of cell center
    data_z=data(:,8); % z coordinate of cell center
    data_alpha=data(:,1); % fluid volume fraction of cell
    data_p=data(:,2); % cell-averaged total pressure
    % note: p_rgh in OpenFOAM is not physical; do not use it
    data_u=data(:,3); % cell-averaged x-velocity
    data_w=data(:,5); % cell-averaged w-velocity
    
    % convert data from vector to xz-grid
    fit_alpha=scatteredInterpolant(data_x,data_z,data_alpha,'linear',...
        'none'); % fit alpha; linear interpolation; extrpolation->NaN
    ALPHA{ti}=fit_alpha(X,Z); % map alpha to grid
    fit_u=scatteredInterpolant(data_x,data_z,data_u,'linear',...
        'none'); % fit u; linear interpolation; extrpolation->NaN
    U{ti}=fit_u(X,Z); % map u to grid
    fit_w=scatteredInterpolant(data_x,data_z,data_w,'linear',...
        'none'); % fit w; linear interpolation; extrpolation->NaN
    W{ti}=fit_w(X,Z); % map w to grid
    fit_p=scatteredInterpolant(data_x,data_z,data_p,'linear',...
        'none'); % fit p; linear interpolation; extrpolation->NaN
    P{ti}=fit_p(X,Z); % map p to grid
    
    % scan vertically for free surface eta (most basic method)
    for xi=1:nx
        for zi=(nz):-1:2 % top->down, air->water
            if ALPHA{ti}(zi,xi)<0.5 && ALPHA{ti}(zi-1,xi)>=0.5
                eta(xi,ti)=interp1([ALPHA{ti}(zi,xi) ALPHA{ti}(zi-1,xi)],...
                    [z(zi) z(zi-1)],0.5,'linear'); % get z where alpha=0.5
                break
            end
        end
    end
    
    % mask air velocity (make air velocity zero)
    U{ti}(ALPHA{ti}<0.5)=0;
    W{ti}(ALPHA{ti}<0.5)=0;
    
    % display progress
    fprintf('@@@@@ data processing progress: %d of %d @@@@@\n',ti,nt);
    
end

% define eta as free surface displacement from still water level
eta=eta-h0;

% save results as .MAT
save(SAVE_NAME,'t','x','z','X','Z','eta','ALPHA','U','W','P','h0');

