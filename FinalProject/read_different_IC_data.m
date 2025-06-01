clear;
close all;
load('initialcompose.mat','xset','yset')
load('sensordata.mat','sensor_lats_in_m','sensor_lons_in_m','data_cell');
load('bathymetry_MATLAB.mat','X','Y');
X = X*90e3; Y = Y*111e3;
%%
nx = 10; ny = 8;
ICresult = zeros(nx*ny,14);
for i = 1:1
    for j = 1:1
        count = ny*(i-1)+j;
        load(['newdata\simulated_' sprintf('%d_%d.mat',i,j)]);
        temp = cellresult(:,:,31); % the field value of each moment
        ICresult(count, 1:7) = interp2(X,Y,temp,sensor_lons_in_m,sensor_lats_in_m);
        temp = cellresult(:,:,51);
        ICresult(count, 8:14) = interp2(X,Y,temp,sensor_lons_in_m,sensor_lats_in_m);        
        fprintf('now end read of %d %d',i,j);
    end
end