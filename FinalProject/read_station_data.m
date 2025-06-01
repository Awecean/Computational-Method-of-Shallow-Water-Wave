% 這個子程式使用於將WG.csv檔讀取後，得到各測站位置及水位高、時間的數據
clear; close all;
% 第一段：讀取檔案
filename = 'WG.csv';
fid = fopen(filename);
station_line = fgetl(fid);      % 第一行：測站名
latlon_line = fgetl(fid);       % 第二行：交錯經緯度
fclose(fid);
station_names = strsplit(strtrim(station_line), ',');
latlon_strs = strsplit(strtrim(latlon_line), ',');

nStation = length(station_names)-1;
%宣告經緯度空陣列
[sensor_lats, sensor_lons] = deal(zeros(1, nStation));

for i = 1:nStation
    lon_str = latlon_strs{2*i};
    lat_str = latlon_strs{2*i-1};
    % 只取數字部分
    lat = str2double(regexp(lat_str, '[\d\.\-]+', 'match', 'once'));
    lon = str2double(regexp(lon_str, '[\d\.\-]+', 'match', 'once'));
    sensor_lats(i) = lat;
    sensor_lons(i) = lon;
end
sensor_lons_in_m = sensor_lons*90e3;
sensor_lats_in_m = sensor_lats*111e3;

% 讀取數值資料(僅讀取下側eta, t)
T = readtable(filename, 'NumHeaderLines', 3);
data_cell = cell(1, nStation);

for i = 1:nStation
    t = T{:,2*i-1};
    eta = T{:,2*i};
    data_cell{i} = [t.'; eta.']; % 2×n
end
%% 儲存檔案
save('sensordata.mat',"station_names","data_cell","sensor_lats","sensor_lons","sensor_lats_in_m",'sensor_lons_in_m');
clear 
load('sensordata.mat');
