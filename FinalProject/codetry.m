% Assume data is your 2D matrix
data = randn(100);

% Create a mask for values > 0
mask = data > 0;

% Replace values > 0 with NaN so they are not plotted in contourf
masked_data = data;
masked_data(mask) = NaN;

% Plot the data < 0 with contourf and jet colormap
figure;
contourf(masked_data, 20, 'LineColor', 'none'); % 20 levels, change as needed
colormap(jet);
colorbar;
hold on;

% Overlay the white mask for data > 0
% Find the indices of data > 0
[row, col] = find(mask);
scatter(col, row, 10, 'w', 'filled'); % 10 is marker size

hold off;
title('Data < 0 shown with jet colormap; Data > 0 masked white');