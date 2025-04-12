%% ===== ssp-RK (for 固定位置的浮標數據) ===== %%
function [x,eta_s,t2,eta_t2] = sspRK4(dx,x_end,t_save,x_loc,t_end,h,CFL,eta0,U0)

% 基本參數設定和計算
g = 9.81;

% 步長設定
x = 0:dx:x_end;     % 空間範圍
%t = 0:dts:t_end;  % 時間範圍 for bouy

% 初始化設定：需"儲存"之時間點的矩陣
Nx = length(x);
Nt = length(t_save);
eta_s = zeros(Nt,Nx);
U_s = zeros(Nt,Nx);
eta_s(1,:) = eta0(x,0);
U_s(1,:) = U0(x,0);
b = 2; % 儲存位置

% 初始化設定2：儲存相同位置的數據
%eta2 = zeros(1,length(t)+length(t_save));


% 初始條件 (initial condition)
eta = eta0(x,0) ; % 波形的初始條件
U = U0(x,0) ;     % 水平速度的初始條件
t_now = 0;  % 現在時間點

[~, idx] = ismember(x_loc, x);
a = idx;
t2 = [t_now];
eta_t2 = [eta(a)'];

% 前一時刻的b.c.
gi = eta(1);
gf = eta(end);


%===== SSP-RK的時間loop =====%
while t_now < t_end
    
    % 設定迴圈的時間步長
    dt = CFL*dx/sqrt(g*max(h));
    if b<=Nt  % 避免index超過
        if (t_now+dt)>t_save(b)
            dt = t_save(b) - t_now;
        end
    end
    %------ 開始計算 ------%
    %___第一步___%
    [deta1, dU1] = G3(x, eta, U, h, dt, dx,gi,gf);
    eta1 = eta -deta1;
    U1   = U   -dU1;
    %___第二步___%
    [deta2, dU2] = G3(x, eta1, U1, h, dt, dx,gi,gf);
    eta2 = (3/4)*eta +(1/4)*eta1 -(1/4)*deta2;
    U2   = (3/4)*U   +(1/4)*U1   -(1/4)*dU2;
    %___第三步___% 下一時刻t_now+dt的數據結果
    [deta3, dU3] = G3(x, eta2, U2, h, dt, dx,gi,gf);
    eta = (1/3)*eta +(2/3)*eta2 -(2/3)*deta3;
    U   = (1/3)*U   +(2/3)*U2   -(2/3)*dU3;
    
    % 儲存所需時間點的結果
    if b<=Nt  % 避免index超過
    if (t_now+dt) == t_save(b) % 判斷是否為需儲存時間點
        eta_s(b,:) = eta;
        U_s(b,:) = U;
        b = b+1;  % 下一次儲存下一列
    end
    end
    gi = eta(1);
    gf = eta(end);
    t2 = [t2,t_now+dt];
    eta_t2 = [eta_t2,eta(a)'];
    % 進入下一回圈
    t_now = t_now + dt;
    
end

end

%% ===== G2函數：計算波動運算符(給水深不固定) ===== %%
function [deta, dU] = G3(x, eta, U, h, dt, dx,gi,gf)
    a = length(x);      % 空間節點總數
    deta = zeros(1,a);  % 儲存 eta 的矩陣
    dU = zeros(1,a);    % 儲存 U 的矩陣
    g= 9.81;
    for i = 1:a
        % 邊界條件設定
        if i == 1
            % eta(0)=A eta(-1)=B U(0)=C U(-1)=D
            A = eta(1)-dx/dt/sqrt(g*h(1))*(eta(1)-gi);
            B = eta(1)-2*dx/dt/sqrt(g*h(1))*(eta(1)-gi);
            C = -sqrt(g*h(1))/h(1)*A;
            D = -sqrt(g*h(1))/h(1)*B;
            deta(i) = (-U(i+2)*h(i+2) +8*U(i+1)*h(i+1) -8*C*h(1) +D*h(1))*dt/(12*dx);
            dU(i)   = (-eta(i+2) +8*eta(i+1) -8*A +B)*dt*g/(12*dx);
        elseif i == 2
            A = eta(1)-dx/dt/sqrt(g*h(1))*(eta(1)-gi);
            C = -sqrt(g*h(1))/h(1)*A;
            deta(i) = (-U(i+2)*h(i+2) +8*U(i+1)*h(i+1) -8*U(i-1)*h(i-1) +C*h(1))*dt/(12*dx);
            dU(i)   = (-eta(i+2) +8*eta(i+1) -8*eta(i-1) +A)*dt*g/(12*dx);
        elseif i == a-1
            A = eta(end)-dx/dt/sqrt(g*h(end))*(eta(end)-gf);
            C = sqrt(g*h(end))/h(end)*A;
            deta(i) = (-C*h(a) +8*U(i+1)*h(i+1) -8*U(i-1)*h(i-1) +U(i-2)*h(i-2))*dt/(12*dx);
            dU(i)   = (-A +8*eta(i+1) -8*eta(i-1) +eta(i-2))*dt*g/(12*dx);
        elseif i == a
            % eta(end+1)=A eta(end+2)=B U(end+1)=C U(end+2)=D
            A = eta(end)-dx/dt/sqrt(g*h(end))*(eta(end)-gf);
            B = eta(end)-2*dx/dt/sqrt(g*h(end))*(eta(end)-gf);
            C = sqrt(g*h(end))/h(end)*A;
            D = sqrt(g*h(end))/h(end)*B;
            deta(i) = (-D*h(end) +8*C*h(end) -8*U(i-1)*h(i-1) +U(i-2)*h(i-2))*dt/(12*dx);
            dU(i)   = (-B +8*A -8*eta(i-1) +eta(i-2))*dt*g/(12*dx);
        else
            % 計算 eta (由速度 U*h 計算)
            deta(i) = (-U(i+2)*h(i+2) +8*U(i+1)*h(i+1) -8*U(i-1)*h(i-1) +U(i-2)*h(i-2))*dt/(12*dx);
            % 計算 U 的導數 (由位移 eta 計算)
            dU(i)   = (-eta(i+2) +8*eta(i+1) -8*eta(i-1) +eta(i-2))*dt*9.81/(12*dx);
        end
    end
end