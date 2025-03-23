%Plot program- [smoothed-abrupt-animation]

%% make animation
M(20) = struct('cdata', [], 'colormap', []);
load("data\abruptsmoothed1.mat")
figure('Position', [100, 100, 900, 500]);
set(gcf, 'Color', 'white');
for tss = 1:size(tsecondary,1)-1  
    plot(x,wv.analyeta(x,h1,h2,tsecondary(tss),x0,xs),'r--','DisplayName',sprintf('analytical solution'));
    
    hold on
    plot(x,etasecondary(tss+1,3:end-2),'b-','DisplayName',sprintf('numerical solution')); 
    plot(x,-h(3:end-2),'o--','DisplayName','smoothed-bathmetry',"MarkerFaceColor","#D95319");
    xlim([0, 30])
    ylim([-1.2*h1, 0.05])
    
    legend(Location="west")
    xlabel(sprintf('x(m)'));
    ylabel(sprintf('\\eta(m)'))
    title(sprintf('the wave at moment t = %.2f s',tsecondary(tss)))
    M(tss) = getframe(gcf);
    hold off
end
%%%% Create a VideoWriter object to save the movie
writerObj = VideoWriter('abruptdepth.avi');
writerObj.FrameRate = 100; % frame rate
writerObj.Quality=100; % Adjust the movie quality (100=best)
open(writerObj);

%%%% Write each frame to the video
for i = 1:length(M)
    writeVideo(writerObj, M(i));
end
%%%% Close the VideoWriter object
close(writerObj);
