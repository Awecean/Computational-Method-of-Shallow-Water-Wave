%% figuremoment.m
% this program's target:
% for each different t with NSWE-data
% plot the dx = 0.05m situation

clear;
folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('NSWEdata%d.mat',1)),'x','eta','tlist');
eta_NSWE = eta;
load(fullfile(folderPath, sprintf('LSWEdata%d.mat',1)),'eta');
eta_LSWE = eta;
% figure
figure('Position',[100,100,1200,600])
set(gcf, 'Color','White');

lineform_NSWE = {'k-','r-','b-','g-'};
lineform_LSWE = {'k--','r--','b--','g--'};

plot(x,eta_NSWE{1}(3:end-2),lineform_NSWE{1},'LineWidth',1,'DisplayName',sprintf('Nonlinear, t = %.1f s', tlist(1)));
hold on
for i = 2:4
    plot(x,eta_NSWE{2*i-1}(3:end-2),lineform_NSWE{i},'LineWidth',1,'DisplayName',sprintf('Nonlinear, t = %.1f s', tlist(2*i-1)));
end
for i = 1:4
    plot(x,eta_LSWE{2*i-1},lineform_LSWE{i},'LineWidth',1,'DisplayName',sprintf('Linear, t = %.1f s', tlist(2*i-1)));
end
%plot(x,eta{1}(3:end-2),lineform{1},'LineWidth',1,'DisplayName',sprintf('t = %.2f s',tlist(1)));
%hold on
%for i = 2:8
%    plot(x,eta{i}(3:end-2),lineform{i},'LineWidth',1,'DisplayName',sprintf('t = %.2f s',tlist(i)));
%end
%hold off
xlim([-4, 8])
xlabel('x (m)','Fontsize',14); ylabel('\eta (m)','FontSize',14)
legend('location','best','FontSize',14);

exportgraphics(gcf, 'Fig3.pdf', 'ContentType', 'vector');
