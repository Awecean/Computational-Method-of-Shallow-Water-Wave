% Plot program- [flat-error analysis]

%% figure a: plot eta versus x of different dx
tss = 6;
%%% a1:plot: (Picture range[Large])
load("data\flat1.mat")
figure('Position', [100, 100, 600, 500]);
set(gcf, 'Color', 'white');
plot(x,wv.analyeta(x,h1,h1,tss,x0,xs),'k-','DisplayName','analytical');
styleform = {'k--','r-','b-','r--','b--'};
hold on
for index = 1:5
    load(fullfile(fullfile(pwd, 'data'), sprintf('flat%d.mat',index)));
    plot(x,etaprimary(tss+1,3:end-2),styleform{index},'DisplayName',sprintf('\\Delta x = %.2f m', dx)); 
end
xlim([14, 14.8])
ylim([0.027, 0.031])
legend(Location="northeast",FontSize=12)
xlabel(sprintf('x(m)'));
ylabel(sprintf('\\eta(m)'))
title(sprintf('the wave at moment t = %d s',tss))
exportgraphics(gcf, "figure\Fig1a1.pdf", 'ContentType', 'vector');

%%% figure a2:plot eta versus x of different dx (Picture range[Medium])

xlim([11, 18])
ylim([0, 0.03])
exportgraphics(gcf, "figure\Fig1a2.pdf", 'ContentType', 'vector');
hold off
%% figure b: plot global error 
tss = 6;

%%% figrue b1, dx^3
gerrorlist = zeros(1,5);
dxlist = zeros(1,5);
for index = 1:5
    load(fullfile(fullfile(pwd, 'data'), sprintf('flat%d.mat',index)));
    gerrorlist(index) = gerror(tss);
    dxlist(index) = dx;
end
dx3list = dxlist.^3;
figure('Position', [100, 100, 600, 500]);

set(gcf, 'Color', 'white');
plot(dx3list, gerrorlist,'ko-','DisplayName','data','LineWidth',1.5);
hold on
m = (gerrorlist(2)-gerrorlist(1))/(dx3list(2)-dx3list(1));
gerrorlineartrend = gerrorlist(1)+([dx3list, 1.1e-3]-dx3list(1)).*m;
plot([dx3list, 1.1e-3],gerrorlineartrend,'r--','DisplayName','linear trend','LineWidth',1.5);

xlabel(sprintf('\\Delta x^3 (m^3)'));
ylabel('gloabal error (m)');
legend(Location="northwest",FontSize=14)
exportgraphics(gcf, "figure\Fig1b1.pdf", 'ContentType', 'vector');


%%% figure b2, loglog plot
figure('Position', [100, 100, 600, 500]);
loglog(dxlist,gerrorlist,'ko-','DisplayName','data','LineWidth',1.5);
hold on
loglog([dxlist(1), 0.12], [gerrorlist(1), gerrorlist(1)*(0.12/dxlist(1))^3],'r--','DisplayName','cubic trend','LineWidth',1.5);
loglog([dxlist(1),0.12],[gerrorlist(1), gerrorlist(1)],'r--', 'HandleVisibility', 'off')
loglog([0.12,0.12],[gerrorlist(1), gerrorlist(1)*(0.12/dxlist(1))^3],'r--', 'HandleVisibility', 'off')

%this hide program is for plot an asymptote
%k = log(gerrorlist(2)/gerrorlist(1))/log(dxlist(2)/dxlist(1));
%gerrortrend = gerrorlist(1)*([dxlist, 0.12]/dxlist(1)).^k; 
%loglog([dxlist, 0.12],gerrortrend,'r--','DisplayName','trend','LineWidth',1.5);
%loglog([dxlist(1),0.12],[gerrortrend(1), gerrortrend(1)],'r--', 'HandleVisibility', 'off')
%loglog([0.12,0.12],[gerrortrend(1), gerrortrend(end)],'r--', 'HandleVisibility', 'off')

set(gcf, 'Color', 'white');
set(gca, 'XScale', 'log', 'YScale', 'log');
xlim([1e-2, 2e-1]);
ylim([8e-7, 5e-4]);
grid on
xlabel(sprintf('\\Delta x (m)'));
ylabel('gloabal error (m)');
text(5e-2,1e-6,'1','Color','red' );
text(1.3e-1,1.5e-5,'3','Color','red' );

legend(Location="northwest",FontSize=14)
exportgraphics(gcf, "figure\Fig1b2.pdf", 'ContentType', 'vector');
hold off
