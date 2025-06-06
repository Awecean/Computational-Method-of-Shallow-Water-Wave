%% This is the Main program of Final Project
clear
clear; close all;

%% Plot the bathymetry
load('bathymetry_MATLAB.mat');
load('sensordata.mat')

figure('Position',[50,50,800,700])
set(gcf,'Color','White')
lat = X; lon = Y;
lat_in_m = 90e3*X; lon_in_m = 111e3*Y;
bathy_mask = bathy>0;
bathy_ocean = bathy;
bathy_ocean(bathy_mask) = NaN;

pcolor(lat, lon, bathy_ocean);

hold on

shading interp             % 插值使圖像平滑
colormap(jet);
c = colorbar('Location',"southoutside");
c.Label.String = 'h (m)'; 
ticks = c.Ticks;
c.TickLabels = arrayfun(@(x) num2str(-x), ticks, 'UniformOutput', false);
%surf(X, Y, -5*ones(size(bathy)), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'black')
for i = 1:length(station_names)-1
    text(sensor_lons(i), sensor_lats(i), station_names{i}, 'VerticalAlignment','top', 'HorizontalAlignment','left');
end
xlabel('Longitude $^\circ E $','Interpreter','latex')
ylabel('Latitude $^\circ N$ ','Interpreter','latex')
title('Bathymetry Map')
scatter(sensor_lons, sensor_lats,'Marker','^','MarkerFaceColor','black');
[X,Y] = meshgrid(lat,lon);
contour(X,Y, bathy,[0 0],'k-');
exportgraphics(gcf, 'Bathymetry Map.pdf', 'ContentType', 'image');

load('initialcompose.mat','xset','yset');
[Xset,Yset] = meshgrid(xset,yset);
scatter(Xset/90e3,Yset/111e3,'black','filled');
exportgraphics(gcf, 'Bathymetry with ICs.pdf', 'ContentType', 'image');
%%
figure('Position',[50,50,800,700])
set(gcf,'Color','White')
contour(X,Y,bathy,[0 0],'k-');
hold on
xlabel('Longitude $^\circ E $','Interpreter','latex')
ylabel('Latitude $^\circ N$ ','Interpreter','latex')
scatter(sensor_lons, sensor_lats,'Marker','^','MarkerFaceColor','blue');
scatter(Xset/90e3,Yset/111e3,'black','filled');
exportgraphics(gcf, 'Bathymetry BW.pdf', 'ContentType', 'image');

%%
for i = 1:7
    figure
    plot(data_cell{i}(1,:), data_cell{i}(2,:),'*-')
    xlabel('t (s)'); ylabel('\eta (m)')
    title(sprintf('%s',station_names{i}));
end
load('Bathymetry Map.pdf')

