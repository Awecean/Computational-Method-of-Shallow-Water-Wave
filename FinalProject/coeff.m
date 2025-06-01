%%  計算此地形的衰減係數矩陣 (已執行一次即可)
close all
clear
%% 讀取數據
data1 = load('bathymetry_MATLAB.mat', 'X','Y','bathy','label');  % 地形
data2 = load('IC_MATLAB.mat','X','Y','eta0','label');  % 初始水體

%% 提取變數
X = data1.X; % 經度
Y = data1.Y; % 緯度
x = X*90*10^3 ; %換成m
y = Y*111*10^3; %換成m
bathy = data1.bathy;
eta0 = data2.eta0;

%
dx = x(2)-x(1); % m 
dy = y(2)-y(1); % m
xi = x(1); xf = x(end);
yi = y(1); yf = y(end);

Ls = 1000;  % 消波距離
%% 計算衰減係數
[alpha_R, alpha_L, alpha_U, alpha_D] = Alphacoeff(bathy, dx, dy, Ls);

%% 儲存為 .mat 檔案
%save('alpha_coeffs1km.mat', 'alpha_R', 'alpha_L', 'alpha_U', 'alpha_D');

%%
eta_coeff = alpha_R.*alpha_L.*alpha_U.*alpha_D;
U_coeff = alpha_R.*alpha_L;
V_coeff = alpha_U.*alpha_D;

figure;
surf(x, y, eta_coeff, 'EdgeColor','none');
colorbar;
title('eta_coeff');
xlabel('X');
ylabel('Y');
zlabel('Depth');
view(45,30);
axis tight;
grid on;

% Alpha East 3D
figure;
surf(x, y, U_coeff, 'EdgeColor','none');
colorbar;
title('U_coeff');
xlabel('X');
ylabel('Y');
zlabel('\alpha_E');
view(45,30);
axis tight;
grid on;

% Alpha East 3D
figure;
surf(x, y, V_coeff, 'EdgeColor','none');
colorbar;
title(' V_coeff');
xlabel('X');
ylabel('Y');
zlabel('\alpha_E');
view(45,30);
axis tight;
grid on;
%save('useCoeffs1km.mat', 'eta_coeff', 'U_coeff', 'V_coeff');

%% Bathymetry 3D圖
%close all
% 3D視覺化
figure;
surf(x, y, bathy, 'EdgeColor','none');
colorbar;
title('Bathymetry');
xlabel('X');
ylabel('Y');
zlabel('Depth');
view(45,30);
axis tight;
grid on;

% Alpha East 3D
figure;
surf(x, y, alpha_R, 'EdgeColor','none');
colorbar;
title('\alpha_R');
xlabel('X');
ylabel('Y');
zlabel('\alpha_E');
view(45,30);
axis tight;
grid on;

% Alpha West 3D
figure;
surf(x, y, alpha_L, 'EdgeColor','none');
colorbar;
title('\alpha_L');
xlabel('X');
ylabel('Y');
zlabel('\alpha_W');
view(45,30);
axis tight;
grid on;

% Alpha North 3D
figure;
surf(x, y, alpha_U, 'EdgeColor','none');
colorbar;
title('\alpha_U');
xlabel('X');
ylabel('Y');
zlabel('\alpha_N');
view(45,30);
axis tight;
grid on;

% Alpha South 3D
figure;
surf(x, y, alpha_D, 'EdgeColor','none');
colorbar;
title('\alpha_D');
xlabel('X');
ylabel('Y');
zlabel('\alpha_S');
view(45,30);
axis tight;
grid on;
