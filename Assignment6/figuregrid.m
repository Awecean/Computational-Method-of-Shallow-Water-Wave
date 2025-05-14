%% figuregrid.m
% this program's target:
% for each different space with NSWE-data
% plot the result at t = 3.5s

clear;
folderPath = fullfile(pwd, 'data');

% figure
figure('Position',[100,100,1200,600])
set(gcf, 'Color','White');

lineform = {'k.-','r.-','b.-','g.-','m.-'};

load(fullfile(folderPath, sprintf('NSWEdata%d.mat',1)),'x','eta','dx');
plot(x,eta{8}(3:end-2),lineform{1},'LineWidth',1,'DisplayName',sprintf('\\Delta x = %.4f m',dx));

hold on
for dx_index = 2:5
    load(fullfile(folderPath, sprintf('NSWEdata%d.mat',dx_index)),'x','eta','dx');
    plot(x,eta{8}(3:end-2),lineform{dx_index},'LineWidth',1,'DisplayName',sprintf('\\Delta x = %.3f m',dx));
end
hold off
xlim([3.5, 7.5])
xlabel('x (m)','Fontsize',14); ylabel('\eta (m)','FontSize',14)
legend('location','northwest','FontSize',14);
grid on
exportgraphics(gcf, 'Fig1.pdf', 'ContentType', 'vector');
