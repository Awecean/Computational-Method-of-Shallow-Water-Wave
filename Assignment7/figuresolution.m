clear; close all;

load('contour1.mat')
xmaxlist = zeros(1,length(t)-1);
figure('Position',[100,100,700,600])
set(gcf, 'Color', 'White')
for i = 1:length(t)-1
    [~, maxidx1] = max(FS{i}(2,:));
    %[~,xidx] = max(FS{i}(2,:));
    xmaxlist(i) = FS{i}(1,maxidx1);
end
plot(t(2:end),xmaxlist,'k-','LineWidth',2);
hold on
plot(t(31:121), xmaxlist(30:120),'r-','LineWidth',2);
xlabel('t [s]')
ylabel('x (\eta_{max}) [m]')
fprintf('v_p = %.2f [m/s]',(xmaxlist(120)-xmaxlist(30))/(t(121)-t(31)))
exportgraphics(gcf, 'Fig6.pdf', 'ContentType', 'vector');

h = 0.2; H = 0.03; g= 9.81;
C = sqrt(g*h);
vg = C*(1+H/2/h);
fprintf('C = %.2f [m/s]',C);
fprintf('vf = %.2f [m/s]',vg);



