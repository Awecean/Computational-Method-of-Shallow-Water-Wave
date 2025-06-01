% point cloud wave
% 這個程式用以產生大量的初始座標去進行模擬

%% initial point
clear
load('bathymetry_MATLAB.mat');
%load('sensordata.mat')
%%
figure('Position',[50,50,800,700])
set(gcf,'Color','White');
lat = X; lon = Y;
lat_in_m = 90e3*X; lon_in_m = 111e3*Y;
pcolor(lat_in_m, lon_in_m, bathy);
shading interp
nx = 10; ny = 8;
xset = 90e3*linspace(141.5, 144.5, nx);
yset = 111e3*linspace(36.0, 39.5, ny);
Lx = 2*(xset(2)-xset(1)); Ly = 2*(yset(2)-yset(1));
fprintf('Lx = %.2f [km]',Lx/1e3);
fprintf('%.2f [km]',Ly/1e3);
hold on
[XGG, YGG] = meshgrid(xset, yset);
cloudset = cell(nx,ny);
cloudweight = length(size(XGG,1)*size(XGG,2));

[LAT, LON] = meshgrid(lat_in_m,lon_in_m); 

scatter(XGG, YGG,'black','filled');

for i = 1:nx
    Xfactor = -(LAT-xset(i)).^2./((Lx/2).^2);
    for j = 1:ny
        Yfactor = -(LON-yset(j)).^2./((Ly/2).^2);
        cloudset{i,j} = exp(Xfactor+Yfactor);
    end
end
save('initialcompose.mat','cloudset','xset','yset');
line([xset(1) xset(2)], [yset(8) yset(8)], 'Color', 'r');
text((xset(1)+xset(2))/2,yset(8)+15e3,'L_x','FontSize',12,'FontWeight','bold','Color','red');
line([xset(1) xset(1)], [yset(5) yset(6)], 'Color', 'r');
text(xset(1)-15e3,(yset(5)+yset(6))/2,'L_y','FontSize',12,'FontWeight','bold','Color','red');
exportgraphics(gcf, 'I.C.pdf', 'ContentType', 'image');
disp('fin stage 1')
%% plot IC of single wave
figure('Position',[100,100,800,750])
set(gcf,'Color','White');
t = tiledlayout(3,3);
[~,idx] = min(abs(lat_in_m-xset(3)));
[~,idy] = min(abs(lon_in_m-yset(6)));
ax1 = nexttile(1,[2,2]);
pcolor(lat_in_m, lon_in_m, cloudset{3,6});

shading interp;
xticklabels('');ylabel('y (m)');
ax2 = nexttile(3,[2,1]);
plot(cloudset{3,6}(:,idx),lon_in_m);
xlabel('\eta (m)');yticklabels('');
ax3 = nexttile(7,[1,2]);
plot(lat_in_m,cloudset{3,6}(idy,:));
xlabel('x (m)');ylabel('\eta (m)');
exportgraphics(gcf, 'ICsingle.pdf','ContentType','image')

%% save data
