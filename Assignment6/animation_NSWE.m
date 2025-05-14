% animation_NSWE.m
% show the NSWE's result
folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('NSWEdata%d.mat',1)),'x','eta_all','tlist_all');

M(1) = struct('cdata', [], 'colormap', []);
figure('Position', [100, 100, 900, 500]);
set(gcf, 'Color', 'white');

for i = 1:length(tlist_all)
    plot(x,eta_all(i,3:end-2),'k-','LineWidth',1,'DisplayName','cell-averaged data');
    axis([-4 8 0 0.4]);
    title(sprintf('t = %.2f (s)',tlist_all(i)));
    xlabel('x (m)','FontSize',12);
    ylabel('\eta (m)', 'FontSize', 12);
    M(i) = getframe(gcf);
end


xlabel('x (m)','FontSize',12);
ylabel('y (m)', 'FontSize', 12);
M(i) = getframe(gcf);

%%%% Create a VideoWriter object to save the movie
writerObj = VideoWriter('NSWEpropagation.avi');
writerObj.FrameRate = 24; % frame rate
writerObj.Quality=100; % Adjust the movie quality (100=best)
open(writerObj);

%%%% Write each frame to the video
for i = 1:length(M)
    writeVideo(writerObj, M(i));
end
%%%% Close the VideoWriter object
close(writerObj);
