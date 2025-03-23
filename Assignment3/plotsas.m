%Plot program- [smoothed-abrupt-snapshot]

%% a1:plot (Picture range[Large])
tss= key_moment;
load("data\abruptsmoothed1.mat")
figure('Position', [100, 100, 900, 500]);
set(gcf, 'Color', 'white');
analysolution = wv.analyeta(x,h1,h2,tss,x0,xs);

Hi = max(wv.analyeta(x,h1,h2,0,x0,xs)); 
Hta = max(analysolution(x>xs));
Htn = max(etaprimary(tss+1,x>xs));
Cta = Hta/Hi; Ctn = Htn/Hi; % transmission coefficient
Hra = max(analysolution(x<xs));
Hrn = max(analysolution(x<xs));
Cra = Hra/Hi; Crn = Hrn/Hi; % reflection corfficient

plot(x,analysolution,'r--','DisplayName',sprintf('analytical solution, H_r/H_i = %.3f, H_t/H_i = %.3f',Cra,Cta));
hold on
plot(x,etaprimary(tss+1,3:end-2),'b-','DisplayName',sprintf('numerical solution,  H_r/H_i = %.3f, H_t/H_i = %.3f',Crn,Ctn)); 
plot(x,-h(3:end-2),'o--','DisplayName','smoothed-bathmetry',"MarkerFaceColor","#D95319");

xlim([0, 30])
ylim([-1.2*h1, 0.05])
xline(xs,'k--','label',sprintf('x_s = %.2f m',xs),'LabelOrientation','horizontal','LabelVerticalAlignment','middle', 'HandleVisibility', 'off');
yline(-h1,'k--','label',sprintf('h_1 = %.2f m',h1), 'HandleVisibility', 'off','LabelVerticalAlignment','bottom');
yline(-h2,'k--','label',sprintf('h_2 = %.2f m',h2), 'HandleVisibility', 'off','LabelVerticalAlignment','bottom');
legend(Location="best")
xlabel(sprintf('x(m)'));
ylabel(sprintf('\\eta(m)'))
title(sprintf('the wave at moment t = %d s',tss))
exportgraphics(gcf, fullfile(fullfile(pwd, 'figure'), sprintf('Fig4snapshot%d.pdf',tss)), 'ContentType', 'vector');
