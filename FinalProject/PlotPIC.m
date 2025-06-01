clear; close all;
%%
load('bathymetry_MATLAB.mat');
load('eta_generationPI.mat');

%%
eta_record_max = zeros(size(eta_s(:,:,1)));
for i = 1:size(eta_s,3)
    eta_record_max = max(eta_record_max, eta_s(:,:,i));
    disp(i)
end
figure('Position',[100,100,800,600]);
set(gcf,'Color','White');
mesh(X,Y,eta_record_max);
axis tight
colormap('jet')
shading interp;
colorbar
clim([0,10])
xlabel('Longitude $^\circ E$','Interpreter','latex');
ylabel('Latitude $^\circ N$', 'Interpreter', 'latex');
zlabel('$\eta_{max} (m)$','Interpreter','latex');
%%
figure('Position',[100,100,800,600]);
set(gcf,'Color','White');
pcolor(X,Y,eta_record_max);
shading interp
colormap('jet');clim([0,10]);
axis tight manual
xlabel('Longitude $^\circ E$','Interpreter','latex');
ylabel('Latitude $^\circ N$', 'Interpreter', 'latex');
c = colorbar;
c.Label.String = '\eta_{max} (m)';
