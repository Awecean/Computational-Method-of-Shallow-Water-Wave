%% plot the pressure distribution
clear; close all;
load_name = 'dataType1.mat';
load(load_name,'t','x','z','X','Z','eta','U','W','P','h0');

[~, tidx] = min(abs(t-5)); % take the moment  t = 5[s] to analysis pressure
%% 
figure('Position',[100,50,800,700])
set(gcf, 'Color','White')
t = tiledlayout(2,2, 'TileSpacing', 'compact'); 
% (i) Pressure_data read the pressure of data
ax1 = nexttile(1, [1 1]); 
contourf(x,z,P{tidx}, 'LineColor', 'none', 'HandleVisibility', 'off');
hold on 
plot(x, eta(:,tidx)+h0,'Color','Red','LineStyle','--','LineWidth',3,'DisplayName','Wave');
legend
xlabel('x (m)','Fontsize',14); ylabel('z (m)','Fontsize',14)
title('$P_{data}$','interpreter','latex', 'FontSize', 12)
axis([0 8 0 0.3])
cb = colorbar;
cb.Label.String = 'Pa';
% (ii) Pressure_Static:
% compute the static pressure
% The static pressure p_s = \rho g (\eta+h)
rho = 1000; % water density [kg/m^3]
g = 9.81; %gravitational accleration [m/s^2]
%p_s =  rho*g* ((eta(:,tidx).' + h0 - Z) .* (Z < (eta(:,tidx).' + h0)));
p_s =  rho*g* ( h0 - Z) .* (Z < (eta(:,tidx).' + h0));
ax2 = nexttile(2, [1 1]); 
contourf(x,z,p_s, 'LineColor', 'none', 'HandleVisibility', 'off');
hold on 
plot(x, eta(:,tidx)+h0,'Color','Red','LineStyle','--','LineWidth',3,'DisplayName','Wave');
legend
xlabel('x (m)','Fontsize',14); ylabel('z (m)','Fontsize',14)
title('$P_{static}$','interpreter','latex', 'FontSize', 12)
axis([0 8 0 0.3])
cb = colorbar;
cb.Label.String = 'Pa';
% (iii) difference between p_{data} and p_d in theroretical
ax3 = nexttile(3, [1 1]); 
contourf(x,z,P{tidx}-p_s, 'LineColor', 'none', 'HandleVisibility', 'off');
hold on 
plot(x, eta(:,tidx)+h0,'Color','Red','LineStyle','--','LineWidth',3,'DisplayName','Wave');
legend
xlabel('x (m)','Fontsize',14); ylabel('z (m)','Fontsize',14)
title('$P_{data}-P_{static}$','interpreter','latex', 'FontSize', 12)
axis([0 8 0 0.3])
cb = colorbar;
cb.Label.String = 'Pa';
% (iv) The dynamic pressure p_d = 1/2 \rho g h
%p_d = 1/2*rho*(U{tidx}.^2+W{tidx}.^2);
K = 1/0.2*sqrt(3*0.03/4/0.2);
p_d =  rho*g* eta(:,tidx).'.*(cosh(K*(Z))./cosh(K* h0)).* (Z < (eta(:,tidx).' + h0));
ax4 = nexttile(4, [1 1]); 
contourf(x,z,p_d, 'LineColor', 'none', 'HandleVisibility', 'off');
hold on 
plot(x, eta(:,tidx)+h0,'Color','Red','LineStyle','--','LineWidth',3,'DisplayName','Wave');
legend
xlabel('x (m)','Fontsize',14); ylabel('z (m)','Fontsize',14)
title('$P_{dynamic}$','interpreter','latex', 'FontSize', 12)
axis([0 8 0 0.3])
cb = colorbar;
cb.Label.String = 'Pa';

exportgraphics(gcf, 'Fig7.pdf', 'ContentType', 'vector');