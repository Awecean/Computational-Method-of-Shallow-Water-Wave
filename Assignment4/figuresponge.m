figure('Position', [100, 100, 700, 650]);
set(gcf, 'Color', 'white');
load("data\initialflatfull1.mat",'X','Y','alpha_m')
mesh(X,Y,alpha_m);
axis([-(Lx+Ls) (Lx+Ls) -(Ly+Ls) (Ly+Ls) 0 1]);
c=colorbar('FontSize',12);
c.Label.String = '\alpha';
xlabel('x (m)','FontSize',12);
ylabel('y (m)', 'FontSize', 12);
zlabel(sprintf('\\alpha'),"FontSize",12);
exportgraphics(gcf, fullfile("figure",sprintf("Fig61a_spongelayerfull.pdf")), 'ContentType', 'image');

load("data\initialflathalf1.mat",'X','Y','alpha_m')
figure('Position', [100, 100, 700, 650]);
set(gcf, 'Color', 'white');
mesh(X,Y,alpha_m);
axis([-(Lx+Ls) (Lx+Ls) -(Ly+Ls) (Ly+Ls) 0 1]);
c=colorbar('FontSize',12);
c.Label.String = '\alpha';
xlabel('x (m)','FontSize',12);
ylabel('y (m)', 'FontSize', 12);
zlabel(sprintf('\\alpha'),"FontSize",12);
exportgraphics(gcf, fullfile("figure",sprintf("Fig61a_spongelayerhalf.pdf")), 'ContentType', 'image');

load("data\initialflatquarter1.mat",'X','Y','alpha_m')
figure('Position', [100, 100, 700, 650]);
set(gcf, 'Color', 'white');
mesh(X,Y,alpha_m);
axis([-(Lx+Ls) (Lx+Ls) -(Ly+Ls) (Ly+Ls) 0 1]);
c=colorbar('FontSize',12);
c.Label.String = '\alpha';
xlabel('x (m)','FontSize',12);
ylabel('y (m)', 'FontSize', 12);
zlabel(sprintf('\\alpha'),"FontSize",12);
exportgraphics(gcf, fullfile("figure",sprintf("Fig61a_spongelayerquarter.pdf")), 'ContentType', 'image');
