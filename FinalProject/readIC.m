clear;
close all;
load('initialcompose.mat','xset','yset')
load('sensordata.mat','sensor_lats_in_m','sensor_lons_in_m','data_cell','station_names');
load('bathymetry_MATLAB.mat','X','Y','bathy');
X = X*90e3; Y = Y*111e3;
%% The inteplated data of moment
% by read the data from the stations to get the target djdata
eta_station = zeros(1,28);
t = 0:50:4000;
figure('Position',[100,100,1200,600])
set(gcf,'Color','White')
g = tiledlayout(2,4);
for i = 1:7
    nexttile;
    plot(data_cell{i}(1,:), data_cell{i}(2,:), 'b.-'); % 原始資料
    hold on
    x = data_cell{i}(1,:);    y = data_cell{i}(2,:);
    valid_idx = isfinite(x) & isfinite(y);
    x = x(valid_idx); y = y(valid_idx);
    eta_temp = interp1(x,y,t,'linear');

    eta_station(i) = interp1(x,y,500, 'linear');
    eta_station(i+7) = interp1(x,y,1500, 'linear');
    eta_station(i+14) = interp1(x,y,2500, 'linear');
    eta_station(i+21) = interp1(x,y,3500, 'linear');

    plot(t, eta_temp, 'r.-'); % 插值後
    if i ==6; legend('Original data', 'Interpolated'); end
    title(sprintf('%s', station_names{i}));
    xlabel('t (s)');
    ylabel('\eta (m)');
end
exportgraphics(gcf, 'Inteploationmoment.pdf', 'ContentType', 'image');
%% The inteploated data of position
% interp the elevation data via different initial condition setting
nx = 10; ny = 8;
ICresult = zeros(58,28);
count = 1;
for i = 1:3
    for j = 1:4
        load(['newdata\simulated_' sprintf('%d_%d.mat',i,j)]);
        for k = 1:4
            temp = cellresult(:,:,20*(k-1)+11); % the field value of each moment
            ICresult(count, 1+7*(k-1):7*k) = interp2(X,Y,temp,sensor_lons_in_m,sensor_lats_in_m);
        end
        fprintf('now end read of %d %d\n',i,j);
        count = count+1;
    end
end

for i = 4:nx
    for j = 1:ny
        load(['newdata\simulated_' sprintf('%d_%d.mat',i,j)]);
        for k = 1:4
            temp = cellresult(:,:,20*(k-1)+11); % the field value of each moment
            ICresult(count, 1+7*(k-1):7*k) = interp2(X,Y,temp,sensor_lons_in_m,sensor_lats_in_m);
        end
        fprintf('now end read of %d %d\n',i,j);
        count = count+1;
    end
end
% Coefficient Matrix
M = eta_station*pinv(ICresult);
save('MXA.mat','M','eta_station','ICresult');
%% Initial Field!!
load('MXA.mat','M','eta_station','ICresult');
load('initialcompose.mat','cloudset')
PI = zeros(size(cloudset{1,1}));
nx = 10; ny = 8;
for i = 1:3
    for j = 1:4
        PI = PI+M(4*(i-1)+j)*cloudset{i,j};
    end
end
for i = 4:nx
    for j = 1:ny
        PI = PI+ M(12+ny*(i-4)+j)*cloudset{i,j};
    end
end
save('PI.mat','PI');

figure('Position',[50,50,800,700])
set(gcf,'Color','White')
pcolor(X/90e3,Y/111e3,PI);
shading interp
colorbar;
hold on;
xlabel('Longitude $^\circ E $','Interpreter','latex')
ylabel('Latitude $^\circ N$ ','Interpreter','latex')
contour(X/90e3,Y/111e3,bathy,[0 0],'k-');
exportgraphics(gcf, 'PropableIC.pdf', 'ContentType', 'image');
save('MXA.mat','M','PI','ICresult');


