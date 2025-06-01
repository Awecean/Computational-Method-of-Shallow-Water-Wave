%% 此程式是用來跑大量初始數據的。

%%  地形圖與初始水體
close all
clear
%% 讀取數據
data1 = load('bathymetry_MATLAB.mat', 'X','Y','bathy','label');  % 地形
load('initialcompose.mat','cloudset');  % 初始水體
data3 = load('useCoeffs1km.mat', 'eta_coeff', 'U_coeff', 'V_coeff'); % 衰減係數
%
x = data1.X; % 經度
y = data1.Y; % 緯度
x = x*90*10^3 ; %換成m
y = y*111*10^3; %換成m
[xGrid,yGrid] = meshgrid(x, y);

fprintf('%d,%d\n',size(cloudset));

%% examine the data read doiesn't wrong
figure
surf(cloudset{1,5}+cloudset{9,6});
shading interp
%%
% 環境&初始條件
bathy = data1.bathy; % 水深


%eta0 = data2.eta0;   % 初始水面位移量
U0 = zeros(size(xGrid));
V0 = zeros(size(xGrid));

% 空間範圍與步長，單位：m
dx = x(2)-x(1); % m 
dy = y(2)-y(1); % m
xi = x(1); xf = x(end);
yi = y(1); yf = y(end);

% 衰減係數
eta_c = data3.eta_coeff;
U_c = data3.U_coeff;
V_c = data3.V_coeff;

% 其他設定
t_save = 0:50:4000;
CFL = 0.9;  %test1=>0.9
disp('finish setting')
%%
disp('start_compute')

sensor_nx = size(cloudset,1); sensor_ny = size(cloudset, 2);
result_cell = cell(sensor_nx,sensor_ny);

numWorkers = 4;
if ~isempty(gcp('nocreate'))
    delete(gcp('nocreate'))
end
parpool(numWorkers);
disp('numWorkers');


for i = 5:sensor_nx
    tempresult = cell(1,sensor_ny);
    tic;
    parfor j = 1:sensor_ny
        
        disp('------------------------------')
        fprintf('start run station (%d, %d)\n', i, j);
    
        % 讀取輸入資料
        eta0 = cloudset{i,j};
    
        % 執行模擬
        [~,~,eta_s,~,~] = SWf_2Dssprk(dx,dy,x,y,t_save,-bathy,CFL,eta0,U0,V0,eta_c,U_c,V_c);
          
        % 儲存 eta_s
        disp('------------------------------')
        tempresult{j} = eta_s;
    
        fprintf('finish run station (%d, %d)\n', i, j);
        disp('------------------------------')
        
    end
    elapsedTime = toc;
    fprintf('The run time is %.2f seconds', elapsedTime);
    for j = 1:sensor_ny
        cellresult = tempresult{j};
        filename = fullfile('newdata', sprintf('simulated_%d_%d.mat', i, j));
        save(filename, 'cellresult', '-v7.3');
        fprintf('fin_savedata (%d, %d)\n', i, j)
    end
end


