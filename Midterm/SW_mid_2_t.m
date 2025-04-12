close all;
clear

dx = 0.1;
x = 0:dx:500; % 根據需要調整步長
%% ==================== 基本設定 ================== %%
% 設定水深 h(x)
h = zeros(size(x)); % 預設 h(x) 為 0
s = 1/76;           % h1~h2之間的斜率
h(x <= 200) = s*(x(x <= 200) -200)+2.51;
h(x >= 200) = 5.5;
% 水深最淺設定為0.01km
for i=1:length(x)   
    if h(i)<0.01
        h(i) = 0.01;
    elseif h(i)>=0.01
        break
    end
end
h = 10^3*h; % 換回單位m
x = 10^3*x; % 換回單位m
dx = 10^3*dx;

% 使用高斯濾波進行平滑，選擇適當的sigma
sigma = 0.6; % 可以根據需要調整 sigma
h_s = imgaussfilt(h, sigma);  % 高斯濾波平滑

% 基本設定 單位用m
g = 9.81;   % 重力加速度
CFL = 0.9;  % 庫朗數

% 初始條件/ incident wave 為孤立波 h = 0.2m,位於區域1的 x=0~20m
H  = 1;  % 波高
x0 = 400*10^3;    % 波浪初始位置
L  = 100*10^3; % effective wavelength
K = 2*pi/L;  % characteristic wave number
h0 = 5.5*10^3;  % 初始位置水深的水深
C0 = sqrt(g*h0);        % 區域1的相速
eta_i = @(x,t) H*sech(K*(x-x0+C0*t)).^2;   % 根據公式(9)計算
U_i   = @(x,t) -eta_i(x,t)*C0/h0;            % 根據公式(8)計算


%% ===================  計算  =====================%
% ssprk3只能儲存所需時間點的數據，ssprk4可再同時儲存同一位置所有時間點的數據
%--#1 瞬時圖：儲存的時間點
t_save = [0, 600, 1200, 1800, 2400, 3150]; 
%--#2 時序圖
x_loc = [10,100,200,300]*1e3;    
x_loc = 10^3*x_loc;
dxlist = [0.05, 0.10, 0.25, 0.40, 0.50]*1e3;
%h_s = 
x_all = cell(1, length(dxlist));
eta_all = cell(1, length(dxlist));
h_s_all = cell(1, length(dxlist));
for i = 1:length(dxlist)
    [~, ~, h_s_all{i}] = wv.bg(1/76, 2510, 5500, dxlist(i));
    [x_all{i}, eta_all{i}]= sspRK5(dxlist(i), 500e3 ,t_save,x_loc,3150 ,h_s_all{i},CFL,eta_i,U_i); % 瞬時圖+時序圖
end

%% ===================  繪圖  =====================%
figure(1);

%plot(x/1000, analyicaleta('methodC'),'M';'LineWidth';1.5);
[~, ~, h_s] = wv.bg(1/76, 2510, 5500, dxlist(1));
plot(x_all{1}/1000, wv.analyicaleta('methodC',1, h_s_all{1}, 2510, 5500, 1200, x_all{1}, 200e3),'M','LineWidth',1.5,'DisplayName','analytical');
%plot(x_all{1}/1000, eta_i(x_all{1},600),'M');
hold on;

styleform = {'k--','r-','b-','r--','b--'};

for i = 1:5    
    plot(x_all{i}/1000, eta_all{i}(3,:),styleform{i},'LineWidth',0.8,'DisplayName',sprintf('dx = %.2f [km]',dxlist(i)/1000));

end

xlabel('x (km)');
ylabel('\eta (m)');

%legend('analysis','dx = 100 m','dx = 150 m','dx = 200 m','dx = 250 m','dx = 300 m','FontSize',14,Location='northeast',box='on');
axis([0,500 ,-0.5,3.5]);
%set(gca, 'Position', [0.1, 0.36, 0.8, 0.4]);
set(gcf, 'Color', 'White');
% 設定圖形大小
set(gcf, 'Position', [100 200 900 600]);
legend()
exportgraphics(gcf, "08t1200snapshot.png");
%%
set(gcf, 'Position', [100 200 600 600]);
axis([259, 262 ,0.9975, 1.0005]);

exportgraphics(gcf, "05-2t600snapshot.png");
%print('C:/Users/USER/Desktop/大三下/2 淺水波計算方法/期中報告/不同時間點', '-dpng', '-r800');
%%
% /////////////////////////////////////////////////////////////////////// %

%-- 誤差
function y = Kerror(data1, datatrue1, xr)
    [~, xidx] = min(abs(xr-200e3));
    xidx = 1;
    data2 = data1(xidx:end);
    datatrue2 = datatrue1(xidx:end);
    disp(length(data2));
    disp(length(datatrue2));
    y = Gerror(data2,datatrue2);
end
function y = Gerror(data2,datatrue2)
    y = sqrt(1/length(data2).*sum(((data2-datatrue2).^2)));
end
E = zeros(size(dxlist));

for i = 1:5    
    E(i) = Kerror(eta_all{i}(2,:), eta_i(x_all{i},600),x_all{i});
end

Dx = dxlist; % 空間步長
%E = [E1 E2 E3 E4 E5];          % 對應誤差
Dx3 = Dx.^3; % deltax^3
% (1) 空間步長與誤差^3關係圖
% linear trend 一階誤差收斂速率
X = Dx(1):1:310 ; %1.2*(10^-3)
Y = ((E(2)-E(1)))/(Dx(2)-Dx(1))*(X-Dx(1))+E(1);

figure(2)
plot((Dx/1000) ,E,'o-k',X/1000,Y,'--r', 'LineWidth', 1);
hold on;
xlabel('$\Delta x^3 (km)$', 'Interpreter', 'latex');
ylabel('global error (m)');
legend('data','linear trend','FontSize',16,Location='best');
pbaspect([1 1 1]);
%axis([0,1.2*10^-3 ,0,1.4*10^-4]);
set(gcf, 'Color', 'White')
set(gcf,'Position',[400 100 600 600]);
exportgraphics(gcf, "06t600errorlinear.png");
% (2)雙對數圖 
% 理論上的3次方收斂趨勢線
X2 = Dx(1):1:310;
Y2 = E(1)/(Dx(1)^3)*X2.^3;

figure(3)
loglog(Dx,E,'o-k',X2, Y2, '--r', 'LineWidth', 1.2);
hold on;
grid on;
xlabel('$\Delta x (km)$', 'Interpreter', 'latex');
ylabel('global error (m)');
% **添加虛線三角形** 用來表示某個斜率
dx_point = X2(1);
E_point = Y2(1);
% 計算虛線三角形的座標
dx_offset = X2(end)-X2(1);   % 水平偏移
E_offset = Y2(end)-Y2(1);    % 垂直偏移，根據需要調整
% 畫虛線三角形
%plot([dx_point, dx_point + dx_offset], [E_point, E_point], 'r--', 'LineWidth', 0.3);         % 水平邊
%plot([dx_point + dx_offset, dx_point + dx_offset], [E_point, E_point + E_offset], 'r--', 'LineWidth', 0.3); % 垂直邊
% 顯示斜率標註
%text(dx_point + dx_offset*0.9, E_point + E_offset*0.05, '3', 'FontSize', 12, 'Color', 'red');
%text(dx_point+ dx_offset*0.35, E_point + E_offset/1000  , '1', 'FontSize', 12, 'Color', 'red');

%legend('data','cubic trend','FontSize',16,Location='northwest');
%pbaspect([1 1 1]);
%axis([6*10^-3,0.2 ,2*10^-9,1.2*10^-3]);
set(gcf, 'Color', 'White');
set(gcf,'Position',[600 100 600 600]);
exportgraphics(gcf, "0706t600errorlog.png");



slope = ( log10(E(2)) - log10(E(1)) )/(log10(Dx(2))-log10(Dx(1)));