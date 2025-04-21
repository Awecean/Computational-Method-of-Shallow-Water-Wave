clear
load('data\pdataflatfull1.mat')
selecttime = [5,10,20];
tidx = zeros(1,length(selecttime));
for i = 1:length(selecttime)
    [~,tidx(i)] = min(abs(tlist-selecttime(i)));
end
%%
for i = 1:length(selecttime)
    figure('Position',[100,100,650,650])
    set(gcf,'Color','White')
    Nskip = 8;
    Nscale = 100;
    quiver(X(1:Nskip:end,1:Nskip:end),...
        Y(1:Nskip:end,1:Nskip:end),...
        U{tidx(i)}(1:Nskip:end,1:Nskip:end)*Nscale,...
        V{tidx(i)}(1:Nskip:end,1:Nskip:end)*Nscale...
        ,0,'LineWidth',1,'Color','b');
    hold on 
    quiver(220,-250,0.5*Nscale,0,0,'LineWidth',1,'Color','r');
    text(220,-260,'0.5 m/s','FontSize',12),
    xlim([-Lx, Lx]);
    ylim([-Ly, Ly]);
    axis equal
    xlabel('x(m)','FontSize',12);
    ylabel('y(m)','FontSize',12);
    title(sprintf('velocity field at %d s', tlist(tidx(i))),'FontSize',14);
    exportgraphics(gcf, fullfile("figure",sprintf("Fig42a%d_velocityfield.pdf",i)), 'ContentType', 'image');
end