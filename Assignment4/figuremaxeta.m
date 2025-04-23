folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('pdata%s%s%d.mat',bathymetrytype,region,spaceindex)),'eta_all','tlist_all','X','Y','Lx','Ly');
%%
recordmaxeta = zeros(size(eta_all{1}));
for i = 1:length(tlist_all)
    recordmaxeta = max(recordmaxeta,eta_all{i}); %take the higher value
end

figure('Position',[100,100,500,500])
set(gcf,'Color','White')

pcolor(X,Y,recordmaxeta,'LineStyle','none');
c = colorbar('location','eastoutside');
axis equal

ylabel('y(m)','FontSize',12);
xlabel('x (m)','FontSize',12)
xlim([-Lx, Lx]);
ylim([-Ly, Ly]);
clim([0,0.2]);
colormap("turbo")
c.Label.String = '\eta (m)';
c.Label.FontSize = 14;
%title(axcell{i},sprintf('\\eta(x,y,%d) (m)',tlist(tidx(i))),'Position',[0,450],'FontSize',12)


exportgraphics(gcf, fullfile("figure",sprintf("Fig44a_maxetafield%s.pdf",bathymetrytype)), 'ContentType', 'image');
