% This program is used to storing some discarded section

%% Part 1 how to parallel computing (I run program with 4 thread)
if isempty(gcp('nocreate'))
    parpool;  % 中途開 pool 沒問題
end
for i = 1:sensor
    tempresult = cell(1,sensor_ny);
    parfor j = 1:sensor_ny
        
        disp('------------------------------')
        fprintf('start run station (%d, %d)\n', i, j);
    
        % 讀取輸入資料
        eta0 = data2.cloudset{i,j};
    
        % 執行模擬
        [~,~,eta_s,~,~] = SWf_2Dssprk(dx,dy,x,y,t_save,-bathy,CFL,eta0,U0,V0,eta_c,U_c,V_c);
          
        % 儲存 eta_s
        disp('------------------------------')
        tempresult{j} = eta_s;
    
        fprintf('finish run station (%d, %d)\n', i, j);
        disp('------------------------------')
        
    end
    for j = 1:sensor_ny
        cellresult = tempresult{j};
        filename = fullfile('data', sprintf('simulated_%d_%d.mat', i, j));
        save(filename, 'cellresult', '-v7.3');
        fprintf('fin_savedata (%d, %d)\n', i, j)
    end
end

%% Part 2 Only run program with 1 thread.
for i = 1:sensor_nx
    for j = 1:sensor_ny
        disp('------------------------------')
        fprintf('start run station (%d, %d)\n', i, j);
        eta0 = data2.cloudset{i,j};
        [~,~,eta_s,~,~] = SWf_2Dssprk(dx,dy,x,y,t_save,-bathy,CFL,eta0,U0,V0,eta_c,U_c,V_c);        
        
        fprintf('finish run station (%d, %d)\n', i, j);
        disp('------------------------------')
        save(['data\' 'simulated' '_',sprintf('%d',i),'_',sprintf('%d',j)], 'result_cell', '-v7.3');
        disp('fin_savedata')
    end
end
%% Part 3 Let's go further