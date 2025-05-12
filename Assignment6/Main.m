% Main Program
% This is the main program of Assignment 6
% B11501037 Po-Tao, Lin
clear; close all;
%% Part 1 InitialCondtion
dxlist = [0.05, 0.10, 0.15];
for dx_index = 1:3
    dx = dxlist(dx_index);
    initialparameter % run this program generate initial data
end
%% Part 2 Simulate Procedure
for dx_index = 1
   simulate % read and simulate, record each moment's profile
end
load(fullfile(folderPath, sprintf('pdata%d.mat',dx_index)));

disp(allcount)
% Part 3 Visulization
%% Part 3-1 Result with different grid space

figure('Position',[100,100,800,400])
set(gcf,'Color','white')
plot(x,eta{1}(3:end-2),'kx-','LineWidth',1,'DisplayName','cell-averaged data');

legend('Location','best','FontSize',14)
xlabel('x','FontSize',14)
ylabel('\\eta','FontSize',14)
hold off

%% Part 3-2 Result with specific moments
%figuretime
%% Part 3-3 Result of Wave propagation
M(20) = struct('cdata', [], 'colormap', []);
figure('Position', [100, 100, 900, 500]);
set(gcf, 'Color', 'white');
for i = 1:length(tlist)
    plot(x,eta{i}(3:end-2),'kx-','LineWidth',1,'DisplayName','cell-averaged data');
    title(sprintf('t = %.2f (s)',tlist(i)));
    axis([-4 8 -H0 4*H0]);

    xlabel('x (m)','FontSize',12);
    ylabel('y (m)', 'FontSize', 12);
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
