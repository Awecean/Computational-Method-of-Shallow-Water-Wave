%% ===== sspRK2DH_2 (for 2DH_Sponge boundary) ===== %%
% 存特定時間的瞬照圖，Sponge boundary

function [X,Y,eta_s,U_s,V_s,eta_max] = SWf_2Dssprk(dx,dy,x,y,t_save,h,CFL,eta0,U0,V0,eta_c,U_c,V_c)

% 基本參數
g = 9.81;

% 步長設定
% x,y還是一維
[X,Y] = meshgrid(x, y);
% eta0,U0,V0,h 已經是2D

% 初始化設定：需"儲存"之時間點的矩陣
Nt = length(t_save);  % 時間儲存步數
eta_s = zeros(length(y), length(x), Nt);  % 儲存波高的 3D 矩陣
eta_max = zeros(length(y), length(x)); % the martix store the max wave height.
U_s   = zeros(length(y), length(x), Nt);  % 儲存 u 速度場
V_s   = zeros(length(y), length(x), Nt);  % 儲存 v 速度場
% 第一層時間 t=0 的波形與速度
eta_s(:,:,1) = eta0;   
U_s(:,:,1) = U0;
V_s(:,:,1) = V0;

b = 2; % 儲存位置


% 計算：初始條件 (initial condition)
eta = eta0 ; % 波形的初始條件
U = U0 ;     % 水平速度的初始條件
V = V0 ; 
t_now = 0;  % 現在時間點


%===== SSP-RK的時間loop =====%
while t_now < t_save(end)
    
    % 設定迴圈的時間步長
    dt = CFL*min(dx,dy)/sqrt(g*max(h(:)) );
    %if b<=Nt  % 避免index超過
    if (t_now+dt) > t_save(b) % 時間步長調整
        dt = t_save(b) - t_now;
        fprintf('t = %d', t_save(b));
    end
    %end

    %------ 開始計算 ------%
    %___第一步___%
    [deta1, dU1, dV1] = G2D_1(x, y, eta, U, V, h, dt, dx, dy,eta_c,U_c,V_c);
    eta1 = eta -deta1;
    U1   = U   -dU1;
    V1   = V   -dV1;
    %___第二步___%
    [deta2, dU2, dV2] = G2D_1(x, y, eta1, U1, V1, h, dt, dx, dy,eta_c,U_c,V_c);
    eta2 = (3/4)*eta +(1/4)*eta1 -(1/4)*deta2;
    U2   = (3/4)*U   +(1/4)*U1   -(1/4)*dU2;
    V2   = (3/4)*V   +(1/4)*V1   -(1/4)*dV2;
    
    %___第三步___% 下一時刻t_now+dt的數據結果
    [deta3, dU3, dV3] = G2D_1(x, y, eta2, U2, V2, h, dt, dx, dy,eta_c,U_c,V_c);
    eta = (1/3)*eta +(2/3)*eta2 -(2/3)*deta3;
    U   = (1/3)*U   +(2/3)*U2   -(2/3)*dU3;
    V   = (1/3)*V   +(2/3)*V2   -(2/3)*dV3;

    % 儲存所需時間點的結果
    %if b<=Nt  % 避免index超過
    if (t_now+dt) == t_save(b) % 判斷是否為需儲存時間點
        eta_s(:,:,b) = eta;
        U_s(:,:,b) = U;
        V_s(:,:,b) = V;
        b = b+1;  % 下一次儲存下一列
    end
   % end

    % 進入下一回圈
    t_now = t_now + dt;
    eta_max = max(eta, eta_max);
end

end

%% ===== G2函數：計算波動運算符(給水深不固定) ===== %%
function [deta, dU, dV] = G2D_1(x, y, eta, U, V, h, dt, dx, dy,eta_c,U_c,V_c)
    a = length(x);
    b = length(y);
    deta = zeros(size(eta));  % 儲存 eta 的矩陣
    dU = zeros(size(U));      % 儲存 U 的矩陣
    dV = zeros(size(V));      % 儲存 V 的矩陣

    for j = 3:b-2
        for i = 3:a-2
            % ==== 各物理量對應的 alpha ====
            A_eta = eta_c(j,i);
            A_U   = U_c(j,i);
            A_V   = V_c(j,i);
            
%------------------------------------------%

            %=== 計算 deta (U*h 對 x 和 y 的偏導數) ===%
            deta_1 = (-A_U*U(j,i+2)*h(j,i+2) + 8*A_U*U(j,i+1)*h(j,i+1) - 8*A_U*U(j,i-1)*h(j,i-1) + A_U*U(j,i-2)*h(j,i-2)) * dt / (12*dx);
            deta_2 = (-A_V*V(j+2,i)*h(j+2,i) + 8*A_V*V(j+1,i)*h(j+1,i) - 8*A_V*V(j-1,i)*h(j-1,i) + A_V*V(j-2,i)*h(j-2,i)) * dt / (12*dy);
            deta(j,i) = deta_1 + deta_2;

            %=== 計算 dU (eta 對 x 偏導數) ===%
            dU(j,i) = (-A_eta*eta(j,i+2) + 8*A_eta*eta(j,i+1) - 8*A_eta*eta(j,i-1) + A_eta*eta(j,i-2)) * dt * 9.81 / (12*dx);

            %=== 計算 dV (eta 對 y 偏導數) ===%
            dV(j,i) = (-A_eta*eta(j+2,i) + 8*A_eta*eta(j+1,i) - 8*A_eta*eta(j-1,i) + A_eta*eta(j-2,i)) * dt * 9.81 / (12*dy);
        end
    end
end
