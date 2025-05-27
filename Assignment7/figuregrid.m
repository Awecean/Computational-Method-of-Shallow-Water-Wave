clear; close all;
lineform = {'k-','r--','g.-','b:'};
figure('Position',[100,100,800,400])
set(gcf, 'Color', 'White')
dxlist = [5, 10, 20]; dzlist = [2.5, 5, 10];

function y = eta_analytical(x, t)
    H = 0.03;
    h = 0.2;
    g = 9.81;
    K = 1/h*sqrt((3*H)/(4*h));
    C = sqrt(g*h);
    y = H*(sech(K*(x-C*t+1.3300))).^2;
end
function norm = gerror(x, t, etamodel)
    eta_a = eta_analytical(x,t);
    lx = length(x);
    norm = sqrt(sum(1/lx*(eta_a-etamodel).^2)); 
end
gerrorlist = [];
%%
for i = 1:3
    load(['contour' num2str(i) '.mat'])
    [~,tidx] = min(abs(t-5));
    if i == 1
        plot(FS{tidx}(1,:), eta_analytical(FS{tidx}(1,:),t(tidx)), lineform{i}, 'DisplayName','analytical solution','LineWidth',2);
        %[~, maxidx1] = max(FS{101}(2,:));
        %x1 = FS{101}(1,maxidx1);
        %[~, maxidx2] = max(eta_analytical(FS{101}(1,:),t(101)));
        %x2 = FS{101}(1,maxidx2);
        %x0 = x2-x1; By these to estimate initial x0
        hold on
    end
    
    plot(FS{tidx}(1,:),FS{tidx}(2,:),lineform{i+1},'MarkerSize',3,...
        'DisplayName', sprintf("\\Delta x = %d mm, \\Delta z = %.1f mm",dxlist(i), dzlist(i)),'LineWidth',2),
    gerrorlist = [gerrorlist gerror(FS{tidx}(1,:),t(tidx),FS{tidx}(2,:))];
    
end
legend(location = 'best')
axis([3.5 7.5 -0.005 0.035]);
xlabel('x (m)'); ylabel('\eta (m)');
exportgraphics(gcf, 'Fig1.pdf', 'ContentType', 'vector');
axis([3.5 7.5 -0.005 0.035]);
%% The global error(Computated by Norm2)
figure('position',[100,100,600,600])
set(gcf, 'Color','White')
plot(dxlist/1000, gerrorlist,'r*-','LineWidth',2);
xlabel('\Delta x (m)'); ylabel('global error (m)');
grid on
exportgraphics(gcf, 'Fig2.pdf', 'ContentType', 'vector');



