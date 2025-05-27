%% the following are show the revolution of wave
clear; close all;
load('contour1.mat');
lineform = {'k-','r.-','g.-','b:','k--'};
figure('Position',[100,100,800,400])
set(gcf, 'Color', 'White')
for i = 1:5
    [~,tidx] = min(abs(t-i));
    plot(FS{tidx}(1,:), FS{tidx}(2,:), lineform{i}, 'DisplayName',sprintf('t = %d s',i),'LineWidth',2);
    if i == 1; hold on; end
end
legend(location = 'best',FontSize=12)
axis([0 8 -0.005 0.03])
xlabel('x (m)'); ylabel('\eta (m)');
exportgraphics(gcf, 'Fig3.pdf', 'ContentType', 'vector');
