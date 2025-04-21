folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('pdata%s%s%d.mat',bathymetrytype,region,spaceindex)));
%load('data\pdataflatfull1.mat')
selecttime = [5,10,20];
tidx = zeros(1,length(selecttime));
for i = 1:length(selecttime)
    [~,tidx(i)] = min(abs(tlist-selecttime(i)));
end
%%
figure('Position',[100,100,1200,500])
set(gcf,'Color','White')
tiledlayout(1,3, 'TileSpacing', 'compact');
axcell = cell(1, 3);
for i = 1:3
    axcell{i} = nexttile(i, [1 1]);
    pcolor(X,Y,eta{tidx(i)},'LineStyle','none');
    if i == 1; ylabel('y(m)','FontSize',12); end
    colorbar('location','northoutside');
    axis equal

    xlabel('x (m)','FontSize',12)
    xlim([-Lx, Lx]);
    ylim([-Ly, Ly]);
    clim([-0.14,0.14]);
    colormap("turbo")
    title(axcell{i},sprintf('\\eta(x,y,%d) (m)',tlist(tidx(i))),...
        'Position',[0,450],'FontSize',12)
end

exportgraphics(gcf, fullfile("figure",sprintf("Fig41a_etafield%s.pdf",bathymetrytype)), 'ContentType', 'image');
