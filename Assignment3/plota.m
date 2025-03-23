% Plot program- [abrupt, Runge's phenomenon]

%% figure a
%%% a1:plot (Picture range[Large])
tss= 11;
load("data\abrupt1.mat")
figure('Position', [100, 100, 900, 500]);
set(gcf, 'Color', 'white');
plot(x,wv.analyeta(x,h1,h2,tss,x0,xs),'r--','DisplayName','analytical solution');
styleform = {'k--','r-','b-','r--','b--'};
hold on
plot(x,etaprimary(tss+1,3:end-2),'b-','DisplayName','numerical solution'); 

plot(x,-h(3:end-2),'o--','DisplayName','bathmetry',"MarkerFaceColor","#D95319");


xlim([0, 30])
ylim([-1.2*h1, 0.05])
xline(xs,'k--','label',sprintf('x_s = %.2f m',xs),'LabelOrientation','horizontal','LabelVerticalAlignment','middle', 'HandleVisibility', 'off');
yline(-h1,'k--','label',sprintf('h_1 = %.2f m',h1), 'HandleVisibility', 'off','LabelVerticalAlignment','bottom');
yline(-h2,'k--','label',sprintf('h_2 = %.2f m',h2), 'HandleVisibility', 'off','LabelVerticalAlignment','bottom');
legend(Location="best")
xlabel(sprintf('x(m)'));
ylabel(sprintf('\\eta(m)'))
title(sprintf('the wave at moment t = %d s',tss))
exportgraphics(gcf, "figure\Fig2a1.pdf", 'ContentType', 'vector');

%%% a2: (Picture range[small])
%set(gca, "CameraPosition", [100, 100, 500, 500])
set(gcf, 'Position', [100, 100, 500, 500]);
xlim([20.5, 23])
ylim([-0.01 0.045])
exportgraphics(gcf, "figure\Fig2a2.pdf", 'ContentType', 'vector');


