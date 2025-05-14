%% figuremoment.m
% this program's target:
% for each different t with NSWE-data
% plot the dx = 0.025m situation

clear;
folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('NSWEdata%d.mat',1)),'x','eta','tlist');

% figure
figure('Position',[100,100,1200,600])
set(gcf, 'Color','White');

lineform = {'k-','r-','b-','g-','k--','r--','b--','g--'};

plot(x,eta{1}(3:end-2),lineform{1},'LineWidth',1,'DisplayName',sprintf('t = %.2f s',tlist(1)));
hold on
for i = 2:8
    plot(x,eta{i}(3:end-2),lineform{i},'LineWidth',1,'DisplayName',sprintf('t = %.2f s',tlist(i)));
end
hold off
xlim([-4, 8])
xlabel('x (m)','Fontsize',14); ylabel('\eta (m)','FontSize',14)
legend('location','best','FontSize',14);
grid on
exportgraphics(gcf, 'Fig2.pdf', 'ContentType', 'vector');
