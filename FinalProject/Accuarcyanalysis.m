% Error analysis

%%
clear; close all;
load('sensordata.mat','sensor_lats_in_m','sensor_lons_in_m','data_cell','station_names');
load('eta_generationPI.mat')
load('bathymetry_MATLAB.mat','X','Y')

%% Define similarity value
function [VRvalue, RMSE] = VR(simulated, ts, real, t)
% 使用 Variance Reduction Ratio (VR) 與 RMSE 比較模擬資料與觀測資料
% simulated: 模擬資料值（向量），對應時間為 ts
% ts: 模擬資料時間（例如 0:50:4000）
% real: 觀測資料值（向量），對應時間為 t（可能不規則，可能有 NaN）
% t: 觀測資料的時間點

    % --- 內插模擬資料到觀測時間點 t 上 ---
    simulated_interp = interp1(ts, simulated, t, 'linear', NaN);  % 模擬值插值到觀測時間點

    % --- 找出 real 非 NaN、模擬值非 NaN 的交集 ---
    mask = ~isnan(real) & ~isnan(simulated_interp);  % 兩邊都不是 NaN 的點

    % --- 篩選有效資料 ---
    filtered_real = real(mask);
    filtered_simulated = simulated_interp(mask);
    Ndata = sum(mask);

    if Ndata == 0
        warning('沒有有效資料點可以進行計算，返回 NaN。');
        VRvalue = NaN;
        RMSE = NaN;
        return;
    end

    % --- 計算平均與誤差 ---
    real_mean = mean(filtered_real);

    % --- VR公式 ---
    VRvalue = 1 - sum((filtered_simulated - filtered_real).^2) / ...
                  sum((filtered_real - real_mean).^2);

    % --- RMSE ---
    RMSE = sqrt(sum((filtered_simulated - filtered_real).^2) / Ndata);
end
%%
t = 0:50:4000;
nt = length(t);
%% load the file eta_s
PIresult = zeros(nt,7);
for i  = 1:nt
    PIresult(i,:) = interp2(X*90e3,Y*111e3,eta_s(:,:,i),sensor_lons_in_m,sensor_lats_in_m);
end
PIresult = PIresult.';
%%
figure('Position',[100,100,1200,600])
set(gcf,'Color','White')
g = tiledlayout(2,4);
for i = 1:7
    nexttile;
    plot(data_cell{i}(1,:), data_cell{i}(2,:), 'b.-'); % 原始資料
    hold on
    x = data_cell{i}(1,:);    y = data_cell{i}(2,:);
     [VRvalue, RMSE] = VR(PIresult(i,:),0:50:4000, data_cell{i}(2,:), data_cell{i}(1,:))
    %x = x(valid_idx); y = y(valid_idx);
    %eta_temp = interp1(x,y,t,'linear');
    %H = SV(PIresult(i,:),eta_temp); % change this line
    %disp(H)
    plot(t,PIresult(i,:),'r.-')
    %plot(t, eta_temp, 'g.-'); % 插值後
    title(sprintf('%s', station_names{i}));
    xlabel('t (s)');
    ylabel('\eta (m)');
    text(3000,max(eta_temp)-0.5,sprintf('%.2f %%',VRvalue*100));
    if i ==6; legend('Original data', 'Interpolated','Location','south'); end

end
exportgraphics(gcf, 'Result.pdf', 'ContentType', 'image');

