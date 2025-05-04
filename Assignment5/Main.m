% Main.m 
% This is the main program of Assignment 5
% CE B11501037 Po-Tao, Lin
clear; close all;

%% Part 1 MUSCL reconstruction
u1 = [0,0,1,4,-4,0,0,5,4,2,-1,2];
[u1L, u1R] = wv.muscl(u1);
x1 = 1:1:length(u1);
figure('Position',[100,100,800,400])
set(gcf,'Color','white')
plot(x1,u1,'kx-','LineWidth',1,'DisplayName','cell-averaged data');
hold on
scatter(x1-1/2,u1R,'red','Marker','>','LineWidth',1,...
    'DisplayName','reconstructed from the left')
scatter(x1+1/2,u1L,'blue','Marker','<','LineWidth',1,...
    'DisplayName','reconstructed from the right')
axis([min(x1)-1, max(x1)+1, min([u1,u1R,u1L])-1, max([u1,u1R,u1L])+1]);
legend('Location','best','FontSize',14)
xlabel('i','FontSize',14)
ylabel('u_i','FontSize',14)
hold off
exportgraphics(gcf, 'Fig1.pdf', 'ContentType', 'vector');
%%
u2 = [8, 4, 1, 0, 0,0, 4, 3, 0, -5, -5, 2];
[u2L, u2R] = wv.muscl(u2);
x2 = 1:1:length(u2);
figure('Position',[100,100,800,400])
set(gcf,'Color','white')
plot(x2,u2,'kx-','LineWidth',1,'DisplayName','cell-averaged data');
hold on
scatter(x2-1/2,u2R,'red','Marker','>','LineWidth',1,...
    'DisplayName','reconstructed from the left')
scatter(x2+1/2,u2L,'blue','Marker','<','LineWidth',1,...
    'DisplayName','reconstructed from the right')
axis([min(x2)-1, max(x2)+1, min([u2 u2R u2L])-1, max([u2,u2R,u2L])+1]);
legend('Location','best','FontSize',14)
xlabel('i','FontSize',14)
ylabel('u_i','FontSize',14)
hold off
exportgraphics(gcf, 'Fig2.pdf', 'ContentType', 'vector');
%%
disp('----MUSCL reconstruction data1----')
fprintf('x^+     ');fprintf('%.1f ,',[x1-0.5 x1(end)+0.5]);fprintf('\n');
fprintf('vec{u^+}');fprintf('%.2f,',u1R);fprintf('X'); fprintf('\n');
fprintf('vec{u^-}');fprintf('   X,');fprintf('%.2f,',u1L);fprintf('\n');

disp('----MUSCL reconstruction data2----')
fprintf('x^+      ');fprintf('%.1f ,',[x2-0.5 x2(end)+0.5]);fprintf('\n');
fprintf('vec{u^+}');fprintf('%.2f,',u2R);fprintf('X'); fprintf('\n');
fprintf('vec{u^-}');fprintf('    X,');fprintf('%.2f,',u2L);fprintf('\n');
%%
etam = [0.01, 0.01, 0.26, 0.32, -0.23, -0.23, -0.09];
etap = [0.01, 0.10, 0.32, -0.12, -0.23, -0.09, -0.09];
Um = [0.02, 0.08, 0.35, 0.41, -0.31, -0.32, 0.02];
Up = [-0.02, 0.16, 0.41, -0.21, -0.32, -0.17, -0.02];
h = 8*ones(size(Um));

[F,G] = wv.hllc(etam, etap, Um, Up, h);
disp('----HLLC data 1----')
fprintf('i     ');fprintf('    %d,',1:length(h));fprintf('\n');
fprintf('F    ');fprintf('%.2f,  ',F);fprintf('\n');
fprintf('G    ');fprintf('%.2f,  ',G);fprintf('\n');
%%
etam = [-0.01 -0.01 -0.33 -0.40 0.28 0.29 0.13];
etap = [-0.01 -0.13 -0.40 0.17 0.29 0.13 0.13];
Um = [-0.02 0.09 0.38 0.45 0.36 0.36 -0.02];
Up = [0.02 -0.18 -0.45 0.28 0.36 0.20 0.017];
h = 10*ones(size(Um));

[F,G] = wv.hllc(etam, etap, Um, Up, h);
disp('----HLLC data 2----')
fprintf('i     ');fprintf('    %d,',1:length(h));fprintf('\n');
fprintf('F    ');fprintf('%.2f,  ',F);fprintf('\n');
fprintf('G    ');fprintf('%.2f,  ',G);fprintf('\n');
