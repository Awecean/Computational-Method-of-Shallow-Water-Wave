clear; close all;
%%
load('bathymetry_MATLAB.mat');
load('eta_generationPI.mat');

%%
figure('Position',[100,100,800,600]);
set(gcf,'Color','White');

bathy_idx = bathy>0;
eta_max(bathy_idx) =NaN;
surf(X,Y,eta_max);
axis tight
colormap('jet')
shading interp;
colorbar
clim([0,10])
xlabel('Longitude $^\circ E$','Interpreter','latex');
ylabel('Latitude $^\circ N$', 'Interpreter', 'latex');
zlabel('$\eta_{max} (m)$','Interpreter','latex');
exportgraphics(gcf, 'maxeta3d.pdf', 'ContentType', 'image');
%%
figure('Position',[100,100,800,600]);
set(gcf,'Color','White');
eta_max_idx = eta_max>10;
eta_max(eta_max_idx) = 10;
contourf(X,Y,eta_max,'linecolor','none');
shading interp
colormap('jet');clim([0,10]);
axis tight manual
xlabel('Longitude $^\circ E$','Interpreter','latex');
ylabel('Latitude $^\circ N$', 'Interpreter', 'latex');
c = colorbar;
c.Label.String = '\eta_{max} (m)';
c.TickLabels = {'0','1','2','3','4','5','6,','7','8','9','>=10'};
exportgraphics(gcf, 'maxeta2d.pdf', 'ContentType', 'image');

%%
figure('Position',[100,100,800,600]);
set(gcf,'Color','White');
[Xmesh,Ymesh] = meshgrid(X,Y);
contourf(X,Y,eta_max,'linecolor','none');
h.ContourZLevel = 8000;
hold on
mesh(X,Y,bathy.*(bathy<0));
view(3)
shading interp
colormap('jet')
clim([0,10])
c = colorbar;
c.Label.String = '\eta_{max} (m)';
c.TickLabels = {'0','1','2','3','4','5','6,','7','8','9','>=10'};
xlabel('latitude $^\circ$ E','Interpreter','latex');
ylabel('longitude $^\circ$ N','Interpreter','latex');
exportgraphics(gcf, 'maxetacombine.pdf', 'ContentType', 'image');
