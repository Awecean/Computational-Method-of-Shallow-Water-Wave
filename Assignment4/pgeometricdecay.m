% pgeometricdecay
% This program aims to analyze the eta will decay with the rate r^-0.5

load('data\pdataflatfull1.mat')
[etamaxlist, rmaxlist] = deal(zeros(1,21));
for i = 1:21
    eta_temp = eta{i}(:);
    [etamax, etamaxidx] = max(eta_temp);
    rreform = R(:);
    rmax = rreform(etamaxidx);
    etamaxlist(i) = etamax;
    rmaxlist(i) = rmax;
end
rlisttemp = linspace(0,max(rmaxlist),100);
etalisttemp = 1*rlisttemp.^(-0.5);
close all

figure('Position', [100,100,550,500])
set(gcf, 'Color', 'White')
plot(rmaxlist,etamaxlist,'ko-','DisplayName','data');
hold on 
plot(rlisttemp, etalisttemp*sqrt(2),'r--','DisplayName','trend','LineWidth',2);
legend(location = 'best',fontsize = 12);
xlabel(sprintf('x (m)'),'FontSize',12);
ylabel(sprintf('\\eta (m)'),'FontSize',12);
hold off
exportgraphics(gcf, "figure\Fig32a_geometrydecay.pdf", 'ContentType', 'vector');

figure('Position', [100,100,550,500])
set(gcf, 'Color', 'White')
loglog(rmaxlist, etamaxlist,'ko-','DisplayName','data');
hold on
etaend = etamaxlist(2)*(250/rmaxlist(2))^(-0.5); 
loglog([rmaxlist(2),rmaxlist(end)],[etamaxlist(2),etaend],'r--','DisplayName','trend')
loglog([rmaxlist(2),rmaxlist(2)],[etamaxlist(2),etaend],'r-','HandleVisibility','off')
loglog([rmaxlist(2),rmaxlist(end)],[etaend,etaend],'r-','HandleVisibility','off')
text(rmaxlist(2)*1.1,sqrt(etamaxlist(2)*etaend),'-1/2','Color','red','FontSize',12);
text(sqrt(rmaxlist(2)*rmaxlist(end)),1.1*etaend,'1','Color','red','FontSize',12)
grid on
xlabel('r (m)','FontSize',12)
ylabel(sprintf('\\eta (m)'),'FontSize',12)
legend(location = 'best',fontsize = 12)
axis([5,260,0.07,0.6])
exportgraphics(gcf, "figure\Fig32b_geometrydecay.pdf", 'ContentType', 'vector');
