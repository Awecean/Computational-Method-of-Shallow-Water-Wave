close all;
load('sensordata.mat');
t = 0:25:4000;
eta_station = cell(1,7);
for i = 1:7
    figure
    plot(data_cell{i}(1,:), data_cell{i}(2,:), 'b.-'); % 原始資料
    hold on
    x = data_cell{i}(1,:);    y = data_cell{i}(2,:);
    valid_idx = isfinite(x) & isfinite(y);
    x = x(valid_idx); y = y(valid_idx);

    eta_station{i} = interp1(x,y, t, 'linear');
    plot(t, eta_station{i}, 'r.-'); % 插值後
    legend('Original data', 'Interpolated');
    title(['Station ', num2str(i)]);
    xlabel('Time');
    ylabel('Value');
end
