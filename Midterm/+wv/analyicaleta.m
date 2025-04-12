function[etaresult, etaleft,xinitial, hslide] = analyicaleta(method, H0, h, h2, h3, Ttarget, x, xab)
% 此程式會藉由初始波高去對t = Ttarget時個點的波高去進行概算
% 需輸入變數如下
% --------------
% form:(考慮類型), h2, h3初始波高, xab: xabrupt處等, h為水深
% 目前僅考慮波海底平原到波高
% --------------

%% Part 0 輸入基礎參數
K = 2*pi/100e3; % 有效波數, L = 100e3
x0 = 400e3;     % 初始波高位置
slope = 1/76;   % 斜率
g = 9.81;       % 重力加速度
C = sqrt(g*h3);% 初始波速設定

%% Part 1 宣告初始波型函數(會受到多次呼叫)
    eta0 = @(xpoint) H0.*(real(sech(K*(xpoint-x0)))).^2;   % 用於計算特定點位
    feta = @(x, x0, C, t) H0.*(sech(K*(x-x0-C*t))).^2;       % 用於計算所有點

%% Part 2 計算波型
% 2-1用於計算驟變前(入射波與反射波)
    Cr =  (sqrt(h3)-sqrt(h2))/(sqrt(h3)+sqrt(h2));       % 波高反射係數
    etai = feta(x, x0, -C, Ttarget).*(x>=xab);      %入射波
    etar = Cr*feta(x, x0-2*xab, C, Ttarget).*(x>=xab);    % 反射波
    etaright = etai + etar;                 % 入射前為兩者相加
% 2-2 計算爬坡耗時
    hslide = max(slope.*(x-xab)+h2,10).*(x<=xab);
    tarrive = sqrt(1/g)*2/slope.*max((sqrt(h2)-sqrt(hslide)),0);  
% 2-3 計算水深驟變後 (透射波)
    Ks = (h/h2).^(1/4);                     % 波高淺化係數
    Ct = (2*sqrt(h3))./(sqrt(h3)+sqrt(h));  % 波高透射係數
% 2-4 加總
    switch method 
        case 'methodA'%不是依照每一點到達速率去進行推估
            xinitial1 = (x+(Ttarget-tarrive)*C).*(x<xab); % 各初始位置       
            xinitial2 = (x+Ttarget*C).*(x>=xab); % 各初始位置
            xinitial = xinitial1+xinitial2;
        case 'methodB'%不是依照各點
            xinitial = (x+Ttarget*C).*(x<=xab); % 各初始位置
        case 'methodC'
            xinitial = (x+sqrt((Ttarget*C).*((Ttarget-tarrive)*C))).*(x<xab); % 各初始位置

    end
    etaleft =  Ct.*Ks.*eta0(xinitial).*(x<xab); % 乘算初始位置波高
    etaresult = etaleft + etaright; % 整個波型
end

