% pradialsymmetry.m
% This program sims to analyze the simulated result is symmertic in radial

load("data\pdataflatfull1.mat",'eta','theta','R','Lx','Ly','X','Y','tlist')
selecttime = 20;
[~,tidx] = min(abs(tlist-selecttime));
eta_analyze = eta{tidx};
thetalist = pi:-2*pi/7:-pi+2*pi/7;
theta_tolerance = 0.005;
labellist = {'\pi','5\pi/7','3\pi/7','\pi/7','-\pi/7','-3\pi/7','-5\pi/7'};
lineform = {'k-','g-','b-','r-','k--','r--','b--'}; % set line's form
idxlist = cell(length(thetalist),1);
for i = 1:length(thetalist)
    theta_target = thetalist(i);
    idx = abs(theta - theta_target)<theta_tolerance;
    rsample = R(idx);
    etasample = eta_analyze(idx);
    [r_sorted, sort_idx] = sort(rsample);
    eta_sorted = etasample(sort_idx);
    idxlist{i} = idx;
    if i ==1 
        figure('Position',[100,100,700,650]);
        set(gcf,'Color','White');
    end
    plot(r_sorted, eta_sorted,lineform{i},'LineWidth',2,'DisplayName',sprintf('%s',labellist{i}));
    if i ==1; hold on; end
end
legend(location = 'best',fontsize = 12)
xlabel('r (m)','FontSize',12);
ylabel(sprintf('\\eta (m)'),'FontSize',12)
xlim([0,Lx])
hold off
exportgraphics(gcf, "figure\Fig33a_radialsymmetry.pdf", 'ContentType', 'vector');
axis([203.8 204.5 0.09035 0.0907])
%set(gca, 'Position',[100,100,700,650])

exportgraphics(gcf, "figure\Fig33b_radialsymmetry.pdf", 'ContentType', 'vector');

%%
figure('Position',[100,100,700,650]);
        set(gcf,'Color','White');
pcolor(X,Y,eta_analyze,'Linestyle','none');
colormap('bone')
clim([-0.14,0.14])
hold on
for i = 1:length(thetalist)
    plot(X(idxlist{i}),Y(idxlist{i}),lineform{i},'LineWidth',2);
end
axis equal
axis([-Lx,Lx,-Ly,Ly])
xlabel('x(m)','FontSize',12);
ylabel('y(m)','FontSize',12);
title(sprintf('\\eta(x,y,20) (m)'),'FontSize',12)
text(-75,20,'2\pi/7','BackgroundColor','White','FontSize',12)
hold off
exportgraphics(gcf, "figure\Fig33c_radialsymmetry.pdf", 'ContentType', 'image');