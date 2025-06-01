% Error analysis

%%
clear; close all;
load('sensordata.mat','sensor_lats_in_m','sensor_lons_in_m','data_cell','station_names');
load('eta_generationPI.mat')
load('bathymetry_MATLAB.mat','X','Y')

%% Define similarity value
function SValue = SV(datasimulated, datastation)
    mask = ~isnan(datastation);  % 只選非NaN
    num_selected = sum(mask(:));
    filtered_datamap = datasimulated(mask);
    filtered_datastation = datastation(mask);
    SValue = sqrt(sum((filtered_datamap ./ filtered_datastation).^2)/num_selected);
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
    valid_idx = isfinite(x) & isfinite(y);
    x = x(valid_idx); y = y(valid_idx);
    eta_temp = interp1(x,y,t,'linear');
    H = SV(PIresult(i,:),eta_temp); % change this line
    disp(H)
    plot(t,PIresult(i,:),'r.-')
    %plot(t, eta_temp, 'g.-'); % 插值後
    title(sprintf('%s', station_names{i}));
    xlabel('t (s)');
    ylabel('\eta (m)');
    text(3000,max(eta_temp)-0.5,sprintf('%.2f %%',H*100));
    if i ==6; legend('Original data', 'Interpolated','Location','south'); end

end
exportgraphics(gcf, 'Result.pdf', 'ContentType', 'image');

