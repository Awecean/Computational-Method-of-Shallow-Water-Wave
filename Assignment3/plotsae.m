%Plot program- [smoothed-abrupt-error analysis]

%% figure a: the snapshot at t = 12s(after abrupt), dx = 0.02m
% Plot abrupt bathmetry, this is a snapshot at t = 12s

tss = 12;
load("data\abruptsmoothed1.mat")
figure('Position', [100, 100, 500, 500]);
set(gcf, 'Color', 'white');
plot(x,etaprimary(tss+1,3:end-2),'b-','DisplayName','numerical solution'); 
hold on
plot(x,wv.analyeta(x,h1,h2,tss,x0,xs),'r--','DisplayName','analytical solution');

xlim([20.5, 23])
ylim([-0.01 0.045])
xline(xs,'k--','label',sprintf('x_s = %.2f m',xs),'LabelOrientation','horizontal','LabelVerticalAlignment','middle', 'HandleVisibility', 'off');
yline(-h1,'k--','label',sprintf('h_1 = %.2f m',h1), 'HandleVisibility', 'off','LabelVerticalAlignment','bottom');
yline(-h2,'k--','label',sprintf('h_2 = %.2f m',h2), 'HandleVisibility', 'off','LabelVerticalAlignment','bottom');
legend(Location="best",FontSize=12)
xlabel(sprintf('x(m)'));
ylabel(sprintf('\\eta(m)'))
title(sprintf('the wave at moment t = %d s',tss))
exportgraphics(gcf, "figure\Fig3a2.pdf", 'ContentType', 'vector');

%%% a2: (Picture range[small])

set(gcf, 'Position', [100, 100, 900, 500]);
plot(x,-h(3:end-2),'o--','DisplayName','bathmetry',"MarkerFaceColor","#D95319");

xlim([0, 30])
ylim([-1.2*h1, 0.05])

exportgraphics(gcf, "figure\Fig3a1.pdf" ,'ContentType', 'vector');

%% figure b: the error analysis
tss = 12;
load("data\abruptsmoothed1.mat")
figure('Position', [100, 100, 600, 500]);
set(gcf, 'Color', 'white');
plot(x,wv.analyeta(x,h1,h2,tss,x0,xs),'k-','DisplayName','analytical');
styleform = {'k--','r-','b-','r--','b--'};
hold on
for index = 1:5
    load(fullfile(fullfile(pwd, 'data'), sprintf('abruptsmoothed%d.mat',index)));
    plot(x,etaprimary(tss+1,3:end-2),styleform{index},'DisplayName',sprintf('\\Delta x = %.2f m', dx)); 
end
xlim([14, 23])
ylim([0.00, 0.05])
legend(Location="best",FontSize=12)
xlabel(sprintf('x(m)'));
ylabel(sprintf('\\eta(m)'))
title(sprintf('the wave at moment t = %d s',tss))
exportgraphics(gcf, "figure\Fig3b1.pdf", 'ContentType', 'vector');

%% figure c: plot error analysis
gerrorlist = zeros(1,5);
dxlist = zeros(1,5);
for index = 1:5
    load(fullfile(fullfile(pwd, 'data'), sprintf('abruptsmoothed%d.mat',index)));
    gerrorlist(index) = gerror(12);
    dxlist(index) = dx;
end
figure('Position', [100, 100, 600, 500]);
loglog(dxlist,gerrorlist,'ko-','DisplayName','data','LineWidth',1.5);
hold on
k = log(gerrorlist(2)/gerrorlist(1))/log(dxlist(2)/dxlist(1));
gerrorcubictrend = gerrorlist(1)*([dxlist, 0.12]/dxlist(1)).^k; 
loglog([dxlist, 0.12],gerrorcubictrend,'r--','DisplayName','trend','LineWidth',1.5);

set(gcf, 'Color', 'white');
set(gca, 'XScale', 'log', 'YScale', 'log');
xlim([1.5e-2, 1.3e-1]);
ylim([6.8e-3, 6.86e-3]);
grid on
xlabel(sprintf('\\Delta x (m)'));
ylabel('gloabal error (m)');
legend(Location="best",FontSize=12)
exportgraphics(gcf, "figure\Fig3c1.pdf", 'ContentType', 'vector');
hold off
