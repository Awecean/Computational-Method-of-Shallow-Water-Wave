function [x, h, h_s, xa, h1, h2, h3] = bg(slope, h2, h3, dx)
% 此函數需要輸入(長度因次皆為公尺)
% ---------------
% slope:大陸坡的斜率(輸入正值)
% h2: 水深驟變處高度
% h3; 初始水深
% dx: 水平精度(步長)
% ---------------    
    xa = 200e3;     % 輸出水深驟變的位置 
    xend = 500e3;   % 水平domain右端
    x = 0:dx:xend;  % 水平domain

    h = (h2+slope*(x-xa)).*(x<=xa)+h3.*(x>xa); % 製作理想海底
    h1 = 10;        % 陸棚水深
    h = max(h,h1);  % 最小水深限制

    % 使用高斯濾波進行平滑，選擇適當的sigma
    sigma = 0.6; % 可以根據需要調整 sigma
    h_s = imgaussfilt(h, sigma);  % 高斯濾波平滑
    %save("batymetry1.mat");
end

