% animationeta
% This program aims to generate the animation of wave propagating
clear;close all;
load('data\pdataflatfull1.mat','X','Y','eta_all','tlist_all','h0','Lx','Ly','Ls')

M(20) = struct('cdata', [], 'colormap', []);
figure('Position', [100, 100, 900, 500]);
set(gcf, 'Color', 'white');
for i = 1:length(tlist_all)
    mesh(X,Y,eta_all{i});
    title(sprintf('t = %.2f (s)',tlist_all(i)));
    view(40, 25);
    axis([-(Lx+Ls) (Lx+Ls) -(Ly+Ls) (Ly+Ls) -0.05 0.1]);
    c=colorbar('FontSize',12);
    c.Label.String = '\eta (m)';
    xlabel('x (m)','FontSize',12);
    ylabel('y (m)', 'FontSize', 12);
    zlabel(sprintf('\\eta (m)'),"FontSize",12);
    clim([-0.14,0.14])
    M(i) = getframe(gcf);
end
%%%% Create a VideoWriter object to save the movie
writerObj = VideoWriter('2Dpropagating.avi');
writerObj.FrameRate = 24; % frame rate
writerObj.Quality=100; % Adjust the movie quality (100=best)
open(writerObj);

%%%% Write each frame to the video
for i = 1:length(M)
    writeVideo(writerObj, M(i));
end
%%%% Close the VideoWriter object
close(writerObj);