

%% ==================== 基本設定 ================== %%
% 基本設定 [單位為MKS制]
g = 9.81;   % 重力加速度
CFL = 0.9;  % 庫朗數

% 設定水深 h(x) [3可調參數]
%bathymetrymode = 'ideal';
switch bathymetrymode
    case 'ideal'
        slope = 1/76; % 陸坡斜率
        h2 = 2510;    % 水深驟變處水深
        h3 = 5500;
        dx = 0.1e3;   % x-step
        [x, h, h_s, xa, h1, h2, h3] = wv.bg(slope, h2,h3, dx);
    case 'idealmany'
        dx = 0.1e3;   % x-step
        [x, h, h_s, xa, h1, h2, h3] = wv.bg(slope, h2,h3, dx);
    case 'chooseone'
        dx = 0.1e3;   % x-step
        [x, h, h_s, xa, h1, h2, h3] = wv.bg(1/81, 2510,5750, dx);
    case 'real'
        load("2025_midterm_bathymetry_meters.mat");
        xread = x';
        hread = h';
        dx = 0.1e3;
        xend = 500e3;   % 水平domain右端
        x = 0:dx:xend;  % 水平domain
        h1 = 10;
        h2 = 2510;
        h3 = 5500;
        h = interp1(xread, hread, x, 'linear');
        h_s = interp1(xread, hread, x, 'linear');
    case 'utopia'
        dx = 0.1e3;
       
        xa = 185e3;     % 輸出水深驟變的位置 
        xb = 230e3;
        xc = 290e3;
        xend = 500e3;   % 水平domain右端
        x = 0:dx:xend;  % 水平domain
        slopea = 1/58;
        slopeb = 1/10;
        slopec = 1/30;
        h3 = 5415;
        h2 = 2810;
        h = (2810+slopea*(x-xa)).*(x<=xa)+(7500+slopeb*(x-xb)).*((x<xb).*(x>xa))+(7500-slopec*(x-xb)).*((x>=xb).*(x<xc))+h3.*(x>=xc);% 製作理想海底
        h1 = 10;        % 陸棚水深
        h = max(h,h1);  % 最小水深限制
        
        % 使用高斯濾波進行平滑，選擇適當的sigma
        sigma = 0.6; % 可以根據需要調整 sigma
        h_s = imgaussfilt(h, sigma);  % 高斯濾波平滑
end

%% 初始條件/ incident wave 為孤立波 h = 0.2m,位於區域1的 x=0~20m
H0  = 1;  % 波高
x0 = 400*10^3;    % 波浪初始位置
L  = 100*10^3; % effective wavelength
K = 2*pi/L;  % characteristic wave number
C0 = sqrt(g*h3);        % 區域1的相速
eta_i = @(x,t) H0*sech(K*(x-x0+C0*t)).^2;   % 初始波型(水位高)，根據公式(9)計算
U_i   = @(x,t) -eta_i(x,t)*C0/h3;           % 初始速度，根據公式(8)計算
%% --A點波高與D點(準確而言是初始)波高之理論關係式
function Htarget = waveheight(direction, Hsource, h1, h2, h3)
    c3 = sqrt(9.81*h3);
    c2 = sqrt(9.81*h2);
    switch  direction
        case 'dtoa' %know D want A
            Htarget = 2*c3/(c3+c2)*(h2/h1)^(1/4)*Hsource;
        case 'atod' %know A want D
            Htarget = (c3+c2)/(2*c3)*(h1/h2)^(1/4)*Hsource;
    end
end
H_A = waveheight('dtoa', 1, h1, h2, h3);
H_D = waveheight('atod', 7.6, h1, h2, h3);
%fprintf('---------------理論上---------------\n');
%fprintf('理論上，若A點播高H_a = 7.6m，則D地水位高H_D為%.4f\n', H_D);


%% ===================  計算  =====================%
% ssprk3只能儲存所需時間點的數據，ssprk4可再同時儲存同一位置所有時間點的數據
% 使用sspRK5去完成所有的計算。
% 然後讀取每個數據。

%--#1 瞬時圖：儲存的時間點
t_save = [0:600:2400,3150];
if animationmode == 'yes';t_save = 0:10:4000;end;
%--#2 時序圖
x_loc = [10,100,200,300, 400]*1e3;    

[x1,eta1,t1,eta_t1] = sspRK4(dx, x(end) ,t_save,x_loc,4000 ,h_s,CFL,eta_i,U_i); % 瞬時圖+時序圖
%%
%--#3、#4 A點最大值、海嘯傳播時間
% A點最大波峰值
%[p_a,l_a] = findpeaks(eta_t1(1,:), 'MinPeakHeight', 0.001, 'MinPeakDistance', 1);
[p_a,l_a] = max(eta_t1(1,:));
Ha_max = p_a;
ta_max = t1(l_a);
% D點偵測到tsunami，以波峰作為判斷點
%[p_d,l_d] = findpeaks(eta_t1(4,:), 'MinPeakHeight', 0.001, 'MinPeakDistance', 1);
[p_d,l_d] = max(eta_t1(4,:));
Hd_max = p_d;
td_max = t1(l_d);
% D到A的間隔時間
Tarrive = ta_max-td_max;
Harrive = Ha_max/Hd_max;
%fprintf('---------------模型結果---------------\n');
%fprintf('若D點水位高eta_{D,max}若為%.2f [m]\n, 則A點eta_{A,max}為%.2f [m]\n', Hd_max, Ha_max)
%fprintf('波浪從浮標D傳遞至A依模型歷時 T= %.2f s\n', Tarrive);
%fprintf('Tarrive = %.2f,Harrive =  %.2f', Tarrive, Harrive)
