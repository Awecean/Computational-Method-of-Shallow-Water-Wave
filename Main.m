close all
need = 'chooseone';
animationmode = '0';
SW_mid0401
switch need        
    case 'report01' % 書面報告 簡單理想海床 漸變水深區域
        figure('Position',[50,50,1200,500])
        set(gcf, 'Color', 'White');
        bathymetrymode = 'ideal';
        animationmode = '0';
        SW_mid0401;
        h_s_real = h_s;        
        plot(x1/1e3,-h_s,'k:.','DisplayName','ideal bathymetry');            
        hold on
        xlim([0,220])
        ylim([-3000, 1000])
        yline(0,'k--','HandleVisibility','off')
        text(10,200,'h_b', 'FontSize',12)
        line([200 200], [0 -2510], 'Color','blue','Linestyle','--', 'LineWidth', 2);
        text(190,-1000,'h_a', 'FontSize',12)
       
        xlabel('x (km)','FontSize',14);
        ylabel('-h (m)','FontSize',14);
        exportgraphics(gcf, "report01bathymetryregion.png");
    case 'report02' % 書面報告 簡單理想海床 全域
        figure('Position', [50,50,1200,400])
        set(gcf, 'Color', 'White');
        bathymetrymode = 'ideal';
        animationmode = '0';
        SW_mid0401;
        h_s_real = h_s;        
        plot(x1/1e3,-h_s,'k:.','DisplayName','ideal bathymetry');            
        hold on
        ylim([-6000, 500])
        yline(0,'k--','HandleVisibility','off')
        text(10,200,'h_1 = 10 m', 'FontSize',12)
        line([200 200], [0 -2510], 'Color','blue','Linestyle','--', 'LineWidth', 2);
        text(210,-1000,'h_2', 'FontSize',12)
        line([350 350], [0 -5500], 'Color','blue','Linestyle','--', 'LineWidth', 2);
        text(360,-4500,'h_3', 'FontSize',12)
        xlabel('x (km)','FontSize',14);
        ylabel('-h (m)','FontSize',14);
        exportgraphics(gcf, "report02bathymetry.png");
    case 'report03' % 書面報告 實際海床
        figure('Position', [50,50,1200,400])
        set(gcf, 'Color', 'White');
        bathymetrymode = 'real';
        animationmode = '0';
        SW_mid0401;
        h_s_real = h_s;        
        plot(x1/1e3,-h_s,'k:.','DisplayName','ideal bathymetry');            
        hold on
        ylim([-8000, 500])
        xlabel('x (km)','FontSize',14);
        ylabel('-h (m)','FontSize',14);
        exportgraphics(gcf, "report03bathymetry.png");
    case 'erroranalysis' % 書面報告 實際水位高程
        SW_mid_2_t            
    case '0304'
        eta_i = @(x,t) H0*sech(K*(x-x0+C0*t)).^2;   % 初始波型(水位高)，根據公式(9)計算
        U_i   = @(x,t) -eta_i(x,t)*C0/h3;           % 初始速度，根據公式(8)計算
        eta0 = eta_i(x,0);
        U0 = U_i(x,0);
        figure('Position',[100, 100, 800, 600])
        set(gcf,'Color', 'White')
        t = tiledlayout(4,1, 'TileSpacing', 'compact'); %
        
        % 第一個子圖（較高）
        ax1 = nexttile(1, [3 1]); % 這樣讓第一個子圖佔 3 倍高度
        plot(x/1e3,U_i(x,0),'b-', 'LineWidth', 2); %水位高
        ylim([-1, 3.5]);
        set(gca, 'XTickLabel', [])
        ylabel('$U$ (m/s)','Interpreter','latex', 'FontSize', 12)
        title('Initial Condition', 'FontSize', 16)
        
        % 第二個子圖（較矮）
        ax2 = nexttile(4, [1 1]); % 這樣讓第二個子圖佔 1 倍高度
        plot(x/1e3,-h_s, 'k:.', 'LineWidth', 0.8);
        ylabel('$-h$ (m)','Interpreter','latex', 'FontSize', 12)
        ylim([-6000, 0])
        %xticklabels([])
        xlabel('$x$ (km)','Interpreter','latex', 'FontSize', 12)
        exportgraphics(gcf, "04initialcondition_U.png");
    %
    case '10'%執行此段程式前，請執行SW_mid04101.m
        figure('Position',[100, 100, 900, 600])
        set(gcf,'Color', 'White')
        t = tiledlayout(4,1, 'TileSpacing', 'compact'); %
        styleform = {'k-','b', 'r', 'g', 'k--', 'b--'};

        ax1 = nexttile(1, [3 1]); % 這樣讓第一個子圖佔 3 倍高度
        plot(x1/1000, eta1(1,:),styleform{1},'LineWidth',1, 'DisplayName', 'numerical', 'DisplayName', sprintf('t = %d [s]', t_save(1)));
        hold on
        for i = 2:6
            plot(x1/1000, eta1(i,:),styleform{i},'LineWidth',1, 'DisplayName', 'numerical', 'DisplayName', sprintf('t = %d [s]', t_save(i)));
        end
        hold off
        ylabel('\eta (m)');        
        legend('Location','best','FontSize',14, box='off');
        ylabel('$\eta$ (m)','Interpreter','latex', 'FontSize', 12)
        set(gca, 'XTickLabel', [])

        ylim([-1, 5.5]);
        % 第二子圖 海底地形
        ax2 = nexttile(4, [1 1]); % 這樣讓第二個子圖佔 1 倍高度
        
        plot(x/1000, -h_s,'k:.', 'LineWidth', 0.8);      
        ylabel('$-h$ (m)','Interpreter','latex', 'FontSize', 12)
        ylim([-8000, 0])
        %xticklabels([])
        xlabel('$x$ (km)','Interpreter','latex', 'FontSize', 12)
        exportgraphics(gcf, "10alltime.png");
    case '11' %執行此段程式前，請執行SW_mid04101.m
        figure('Position',[100, 100, 1200, 500])
        set(gcf,'Color', 'White')
        t = tiledlayout(1,4, 'TileSpacing', 'compact'); %
        styleform = {'k-','b', 'r', 'g', 'k--', 'b--'};

        %ax1 = nexttile(1, [1 1]); % 這樣讓第一個子圖佔 3 倍高度
        axcell = cell(1, 4);
        
        for i = 1:4
            axcell{i} = nexttile(i, [1 1]);
            plot(t1,eta_t1(i,:),'k', 'LineWidth', 2);
            
            xlabel('t (s)','FontSize',14);
            axis([0,4000 ,-0.5,3]);
            if i == 1; ylabel('$\eta$ (m)','Interpreter','latex', 'FontSize', 12), ylim([-0.5,5]); end
            title(sprintf('Buoy %s at x = %d [km]',char(64+i), x_loc(i)/1e3),'FontSize',14);
        end      
        exportgraphics(gcf, "11specificposition.png");
    case '12'
        figure('Position',[100, 100, 800, 700])
        set(gcf,'Color', 'White')
        plot(t1,eta_t1(1,:),'b', 'LineWidth', 1,'DisplayName','Buoy A');
        hold on
        plot(t1,eta_t1(4,:),'r', 'LineWidth', 1,'DisplayName','Buoy D');
        % 標註H變化
        yline(Ha_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-700, Ha_max-0.3, sprintf('H_A = %.4f', Ha_max), 'FontSize', 12, 'Color', 'k');

        yline(Hd_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+100, Hd_max+0.3, sprintf('H_D = %.4f', Hd_max), 'FontSize', 12, 'Color', 'k');
        
        % 標註T變化
        xline(ta_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-0.3, -1.5, sprintf('T_A = %.2f', ta_max), 'FontSize', 12, 'Color', 'k');

        xline(td_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+0.3, -1.5, sprintf('T_D = %.2f', td_max), 'FontSize', 12, 'Color', 'k');

        xlabel('t (s)','FontSize',14);
        ylabel('\eta (m)','FontSize',14);
        axis([0,4000 ,-0.8,6]);
        %title('若A點波高為7.6m，則D點波高為1.6797m','FontSize',10);
        legend('Location','north','FontSize',14);
        exportgraphics(gcf, "12wavepropagationH.png");
    case '14'
        figure('Position',[100, 100, 900, 600])
        set(gcf,'Color', 'White')
        t = tiledlayout(4,1, 'TileSpacing', 'compact'); %
        styleform = {'k-','b', 'r', 'g', 'k--', 'b--'};

        ax1 = nexttile(1, [3 1]); % 這樣讓第一個子圖佔 3 倍高度
        plot(x1/1000, eta1(1,:),styleform{1},'LineWidth',1, 'DisplayName', 'numerical', 'DisplayName', sprintf('t = %d [s]', t_save(1)));
        hold on
        for i = 2:6
            plot(x1/1000, eta1(i,:),styleform{i},'LineWidth',1, 'DisplayName', 'numerical', 'DisplayName', sprintf('t = %d [s]', t_save(i)));
        end
        hold off
        ylabel('\eta (m)');        
        legend('Location','best','FontSize',14, box='off');
        ylabel('$\eta$ (m)','Interpreter','latex', 'FontSize', 12)
        set(gca, 'XTickLabel', [])

        ylim([-1, 5.5]);
        % 第二子圖 海底地形
        ax2 = nexttile(4, [1 1]); % 這樣讓第二個子圖佔 1 倍高度
        
        plot(x/1000, -h_s,'k:.', 'LineWidth', 0.8);      
        ylabel('$-h$ (m)','Interpreter','latex', 'FontSize', 12)
        ylim([-8000, 0])
        %xticklabels([])
        xlabel('$x$ (km)','Interpreter','latex', 'FontSize', 12)
        exportgraphics(gcf, "14alltime.png");
    case '15' %執行此段程式前，請執行SW_mid04101.m
        figure('Position',[100, 100, 1200, 500])
        set(gcf,'Color', 'White')
        t = tiledlayout(1,4, 'TileSpacing', 'compact'); %
        styleform = {'k-','b', 'r', 'g', 'k--', 'b--'};

        %ax1 = nexttile(1, [1 1]); % 這樣讓第一個子圖佔 3 倍高度
        axcell = cell(1, 4);
        
        for i = 1:4
            axcell{i} = nexttile(i, [1 1]);
            plot(t1,eta_t1(i,:),'k', 'LineWidth', 2);
            
            xlabel('t (s)','FontSize',14);
            axis([0,4000 ,-0.5,3]);
            if i == 1; ylabel('$\eta$ (m)','Interpreter','latex', 'FontSize', 12), ylim([-0.5,5]); end
            title(sprintf('Buoy %s at x = %d [km]',char(64+i), x_loc(i)/1e3),'FontSize',14);
        end      
        exportgraphics(gcf, "15specificposition.png");
    case '16'
        figure('Position',[100, 100, 800, 700])
        set(gcf,'Color', 'White')
        plot(t1,eta_t1(1,:),'b', 'LineWidth', 1,'DisplayName','Buoy A');
        hold on
        plot(t1,eta_t1(4,:),'r', 'LineWidth', 1,'DisplayName','Buoy D');
        % 標註H變化
        yline(Ha_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-700, Ha_max-0.3, sprintf('H_A = %.4f', Ha_max), 'FontSize', 12, 'Color', 'k');

        yline(Hd_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+100, Hd_max+0.3, sprintf('H_D = %.4f', Hd_max), 'FontSize', 12, 'Color', 'k');
        
        % 標註T變化
        xline(ta_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-0.3, -1.5, sprintf('T_A = %.2f', ta_max), 'FontSize', 12, 'Color', 'k');

        xline(td_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+0.3, -1.5, sprintf('T_D = %.2f', td_max), 'FontSize', 12, 'Color', 'k');

        xlabel('t (s)','FontSize',14);
        ylabel('\eta (m)','FontSize',14);
        axis([0,4000 ,-0.8,6]);
        %title('若A點波高為7.6m，則D點波高為1.6797m','FontSize',10);
        legend('Location','north','FontSize',14);
        exportgraphics(gcf, "19wavepropagationH.png");
    case '18'
        bathymetrymode = 'ideal';
        SW_mid0401
        x1_recordideal = x1;
        eta1_recordideal = eta1;
        h_s_recordieal = h_s;
        bathymetrymode = 'real';
        SW_mid0401
        figure('Position',[100, 100, 1200, 500])
        set(gcf,'Color', 'White')
        figure('Position',[100, 100, 900, 600])
        set(gcf,'Color', 'White')
        t = tiledlayout(4,1, 'TileSpacing', 'compact'); %
        styleform = {'k-','b', 'r', 'g', 'k--', 'b--'};

        ax1 = nexttile(1, [3 1]); % 這樣讓第一個子圖佔 3 倍高度
        plot(x1_recordideal/1000, eta1_recordideal(4,:),'r--','LineWidth',1, 'DisplayName', 'numerical', 'DisplayName','ideal');
        hold on
        plot(x1/1000, eta1(4,:),'k-','LineWidth',1, 'DisplayName', 'numerical', 'DisplayName', 'real');
        hold off
        ylabel('\eta (m)');        
        legend('Location','best','FontSize',14, box='off');
        ylabel('$\eta$ (m)','Interpreter','latex', 'FontSize', 12)
        set(gca, 'XTickLabel', [])

        ylim([-1, 5.5]);
        % 第二子圖 海底地形
        ax2 = nexttile(4, [1 1]); % 這樣讓第二個子圖佔 1 倍高度
        plot(x1_recordideal/1000,-h_s_recordieal,'r:.', 'LineWidth', 0.8);
        hold on
        plot(x/1000, -h_s,'k-', 'LineWidth', 0.8);
         
        ylabel('$-h$ (m)','Interpreter','latex', 'FontSize', 12)
        ylim([-8000, 0])
        %xticklabels([])
        xlabel('$x$ (km)','Interpreter','latex', 'FontSize', 12)
        exportgraphics(gcf, "18alltime.png");

    case '19'
        bathymetrymode = 'ideal';
        SW_mid0401
        t1_recordideal = t1;
        eta_t1_recordideal = eta_t1;
        bathymetrymode = 'real';
        SW_mid0401
        figure('Position',[100, 100, 1200, 500])
        set(gcf,'Color', 'White')
        
        t = tiledlayout(1,4, 'TileSpacing', 'compact'); %
        title(t, 'Wave Propagation Under Different Bathymetries', ...
      'FontSize', 18, 'FontWeight','bold') 
        styleform = {'k-','b', 'r', 'g', 'k--', 'b--'};
        %ax1 = nexttile(1, [1 1]); % 這樣讓第一個子圖佔 3 倍高度
        axcell = cell(1, 4);
        
        for i = 1:4
            axcell{i} = nexttile(i, [1 1]);
            plot(t1,eta_t1(i,:),'k', 'LineWidth',1,'DisplayName','Real Bathymetry');
            hold on
            plot(t1_recordideal,eta_t1_recordideal(i,:),'r--', 'LineWidth', 1,'DisplayName','Ideal Bathymetry');
            xlabel('t (s)','FontSize',14);
            axis([0,4000 ,-0.5,3]);
            if i == 1; ylabel('$\eta$ (m)','Interpreter','latex', 'FontSize', 12), ylim([-0.5,5]); end
            title(sprintf('Buoy %s at x = %d [km]',char(64+i), x_loc(i)/1e3),'FontSize',14);
            %hold off
        end
        legend('Location','eastoutside','FontSize',16)
        exportgraphics(gcf, "19specificposition.png");
    case '20'
        figure('Position',[100, 100, 800, 700])
        set(gcf,'Color', 'White')
        plot(t1,eta_t1(1,:),'b', 'LineWidth', 1,'DisplayName','Buoy A');
        hold on
        plot(t1,eta_t1(4,:),'r', 'LineWidth', 1,'DisplayName','Buoy D');
        % 標註H變化
        yline(Ha_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-700, Ha_max-0.3, sprintf('H_A = %.4f', Ha_max), 'FontSize', 12, 'Color', 'k');

        yline(Hd_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+100, Hd_max+0.3, sprintf('H_D = %.4f', Hd_max), 'FontSize', 12, 'Color', 'k');
        
        % 標註T變化
        xline(ta_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-0.3, -1.5, sprintf('T_A = %.2f', ta_max), 'FontSize', 12, 'Color', 'k');

        xline(td_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+0.3, -1.5, sprintf('T_D = %.2f', td_max), 'FontSize', 12, 'Color', 'k');

        xlabel('t (s)','FontSize',14);
        ylabel('\eta (m)','FontSize',14);
        axis([0,4000 ,-0.8,8]);
        %title('若A點波高為7.6m，則D點波高為1.6797m','FontSize',10);
        legend('Location','north','FontSize',14);
        exportgraphics(gcf, "20wavepropagationreal.png");
    case '20-2'
        figure('Position',[100, 100, 800, 700])
        set(gcf,'Color', 'White')
        plot(t1,eta_t1(1,:),'b', 'LineWidth', 1,'DisplayName','Buoy A');
        hold on
        plot(t1,eta_t1(4,:),'r', 'LineWidth', 1,'DisplayName','Buoy D');
        % 標註H變化
        yline(Ha_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-700, Ha_max-0.3, sprintf('H_A = %.4f', Ha_max), 'FontSize', 12, 'Color', 'k');

        yline(Hd_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+100, Hd_max+0.3, sprintf('H_D = %.4f', Hd_max), 'FontSize', 12, 'Color', 'k');
        
        % 標註T變化
        xline(ta_max, 'k-.', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(ta_max-0.3, -1.5, sprintf('T_A = %.2f', ta_max), 'FontSize', 12, 'Color', 'k');

        xline(td_max, 'k--', 'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(td_max+0.3, -1.5, sprintf('T_D = %.2f', td_max), 'FontSize', 12, 'Color', 'k');

        xlabel('t (s)','FontSize',14);
        ylabel('\eta (m)','FontSize',14);
        axis([0,4000 ,-0.8,8]);
        %title('若A點波高為7.6m，則D點波高為1.6797m','FontSize',10);
        legend('Location','north','FontSize',14);
        exportgraphics(gcf, "21wavepropagationideal.png");
    case 'manyform'
        bathymetrymode = 'idealmany';
        h2list = 2510+(-200:100:700);
        h3list = 5500+(-500:250:500);
        slopelist = 1./(61:5:81);
        C_Hlist = zeros(length(h2list),length(h3list),length(slopelist));
        C_Tlist = zeros(length(h2list),length(h3list),length(slopelist));
        for indexi = 1:length(h2list)
            h2 = h2list(indexi);
            for indexj = 1:length(h3list)
                h3 = h3list(indexj);
                for indexh = 1:length(slopelist)
                    slope = slopelist(indexh);
                    SW_mid0401;
                    C_Tlist(indexi, indexj, indexh) = Tarrive;
                    C_Hlist(indexi, indexj, indexh) = Harrive;
                end           
            end
            disp(indexi);
        end
        save('CTCHaccuracydata.mat', 'h2list','h3list','slopelist', 'C_Tlist', 'C_Hlist');
    case 'chooseone'
        clear
        load('CTCHaccuracydata.mat');
        % 自訂紅黑藍 colormap（從紅白藍）
        n = 256;
        half = n / 2;
        % 合併成紅白藍 colormap
        r = [linspace(0,1,half), linspace(1,1,half)];
        g = [linspace(0,1,half), linspace(1,0,half)];
        b = [linspace(1,1,half), linspace(1,0,half)];
        mycmap = [r' g' b'];
        
        
        C_T = C_Tlist/2773.41;
        C_H = C_Hlist/4.4619;
        % 建立所有參數組合
        [ h2mesh, slopemesh,  h3mesh] = ndgrid(h2list, slopelist, h3list);
        
        % 計算 Travel time        
        X = h2mesh(:);
        Y = h3mesh(:);
        Z = slopemesh(:);
        VC_T = C_T(:);
        VC_H = C_H(:);
        VC_HC_T = C_T(:).*C_H(:);

        %% 第一張圖CT
        % scatter3 繪圖
        figure('Position',[100,100, 800,600])
        set(gcf,'Color','White');
        scatter3(X, Y, Z, 50, VC_T, 'filled');
        hold on;
        min_idx_CT = zeros(1,3);
        temp_data = VC_T;
        for i = 1:3
            [~, closest_idx] = min(abs(temp_data-1)); % 找到最接近的索引
            min_idx_CT(i) = closest_idx;
            temp_data(closest_idx) = inf;
            scatter3(h2mesh(closest_idx), h3mesh(closest_idx),slopemesh(closest_idx),  600-100*i, 'g', 'filled'); % 特殊顏色標記最近點
        end
        colorbar;
        hcb=colorbar;
        hcb.Title.String = 'C_T';
        colormap(mycmap)
        cmax = max(abs(VC_T));
        cmin = min(abs(VC_T));
        clim([cmin, cmax+1]);
        caxis([-cmax+1 cmax+1]);
        xlabel('h_2 [m]'); ylabel('h_3 [m]');zlabel('s');
        title('3D Scatter of C_T');
        exportgraphics(gcf, "30CT.png");
        filename = 'CTscatter_rotation.gif';
        for angle = 30:1:60
            view(angle, 25);
            axis([min(X) max(X) min(Y) max(Y) min(Z) max(Z)]);
            drawnow;
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind, cm] = rgb2ind(im, 256);
            if angle == 30
                imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
            else
                imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
            end
        end
        %% 第二張圖CH
        figure('Position',[100,100, 800,600])
        set(gcf,'Color','White');
        scatter3(X, Y, Z, 50, VC_H, 'filled');
        hold on;
        min_idx_CH = zeros(1,3);
        temp_data = VC_H;
        for i = 1:3
            [~, closest_idx] = min(abs(temp_data-1)); % 找到最接近的索引
            min_idx_CH(i) = closest_idx;
            temp_data(closest_idx) = inf;
            scatter3(h2mesh(closest_idx), h3mesh(closest_idx),slopemesh(closest_idx), 600-100*i, 'g', 'filled'); % 特殊顏色標記最近點
        end
        colormap(mycmap)
        cmax = max(VC_H);
        cmin = min(VC_H);
        
        
        clim([cmin, cmax+1]);
        caxis([-cmax+1 cmax+1]);
        
        colorbar;
        hcb=colorbar;
        hcb.Title.String = 'C_H';
        xlabel('h_2 [m]'); ylabel('h_3 [m]');zlabel('s');
        title('3D Scatter of C_H');
        hold off
        exportgraphics(gcf, "31CH.png");
        filename = 'CHscatter_rotation.gif';
        for angle = 30:1:60
            view(angle, 25);
            axis([min(X) max(X) min(Y) max(Y) min(Z) max(Z)]);
            drawnow;
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind, cm] = rgb2ind(im, 256);
            if angle == 30
                imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
            else
                imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
            end
        end
        %% 第三張圖CHCT
        figure('Position',[100,100, 800,600])
        set(gcf,'Color','White');
        scatter3(X, Y, Z, 50, VC_HC_T, 'filled');
        hold on;
        min_idx_CHT = zeros(1,3);
        temp_data = VC_HC_T;
        for i = 1:3
            [~, closest_idx] = min(abs(temp_data-1)); % 找到最接近的索引
            min_idx_CHT(i) = closest_idx;
            temp_data(closest_idx) = inf;
            scatter3(h2mesh(closest_idx), h3mesh(closest_idx),slopemesh(closest_idx), 600-100*i, 'g', 'filled'); % 特殊顏色標記最近點
        end
        colorbar;
        for i = 1:3
            fprintf("C_H = %.4f, C_T = %.4f, C_HC_T = %.4f\n",VC_H(min_idx_CHT(i)),VC_T(min_idx_CHT(i)),VC_HC_T(min_idx_CHT(i)));
        end
        
        colormap(mycmap)
        hcb=colorbar;
        hcb.Title.String = 'C_H C_T';
        cmax = max(abs(VC_HC_T));
        cmin = min(abs(VC_HC_T));
        clim([cmin, cmax+1]);
        caxis([-cmax+1 cmax+1]);
        xlabel('h_2 [m]'); ylabel('h_3 [m]');zlabel('s');
        title('3D Scatter of C_HC_T');
        exportgraphics(gcf, "32CHCT.png");
        savefig("32CHCT.fig");

        filename = 'CHCTscatter_rotation.gif';
        for angle = 30:1:60
            view(angle, 25);
            axis([min(X) max(X) min(Y) max(Y) min(Z) max(Z)]);
            drawnow;
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind, cm] = rgb2ind(im, 256);
            if angle == 30
                imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
            else
                imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
            end
        end
        %% specfic d
        target_h3 = 5750; % specific h3
        target_idx = abs(h3mesh(:) - target_h3) < 1e-6;
        
        X_sub = Z(target_idx);         % slope
        Y_sub = X(target_idx);         % h3
        C_sub = VC_T(target_idx);      % C_T 對應值
        
        % 繪製 2D 散佈圖
        figure('Position',[100,100,800,600])
        set(gcf,'Color','White');
        scatter(X_sub, Y_sub, 60, C_sub, 'filled'); % 60 是點的大小
        hold on
        for i = 1:3
            [~, closest_idx] = min(abs(C_sub-1)); % 找到最接近的索引
            temp_data(closest_idx) = inf;
            scatter(X_sub(closest_idx), Y_sub(closest_idx), 600-100*i, 'g', 'filled'); % 特殊顏色標記最近點
        end
        colormap(mycmap);
        cmax = max(abs(C_sub));
        cmin = min(abs(C_sub));
        clim([cmin, cmax+1]);
        caxis([-cmax+1 cmax+1]);
        colorbar;
        xlabel('s');
        ylabel('h_2 [m]');
        title(['2D Scatter of C_T at h_3 = ', num2str(target_h3)]);
        exportgraphics(gcf, "402DscatterCT.png");

        target_slope = 1/76; % specific h3
        target_idx = abs(slopemesh(:) - target_slope) < 1e-6;
        
        X_sub = Y(target_idx);         % h2
        Y_sub = X(target_idx);         % h3
        C_sub = VC_T(target_idx);      % C_T 對應值
        
        % 繪製 2D 散佈圖
        figure('Position',[100,100,800,600])
        set(gcf,'Color','White');
        scatter(X_sub, Y_sub, 60, C_sub, 'filled'); % 60 是點的大小
        hold on
        for i = 1:3
            [~, closest_idx] = min(abs(C_sub-1)); % 找到最接近的索引
            temp_data(closest_idx) = inf;
            scatter(X_sub(closest_idx), Y_sub(closest_idx), 600-100*i, 'g', 'filled'); % 特殊顏色標記最近點
        end
        colormap(mycmap);
        cmax = max(abs(C_sub));
        cmin = min(abs(C_sub));
        clim([cmin, cmax+1]);
        caxis([-cmax+1 cmax+1]);
        colorbar;
        xlabel('h_3 [m]');
        ylabel('h_2 [m]');
        title(['2D Scatter of C_H at s = 1/76']);
        exportgraphics(gcf, "412DscatterCH.png");

    case 'bestidealbathy'
        load('CTCHaccuracydata.mat');
        
        C_T = C_Tlist/2773.41;
        C_H = C_Hlist/4.4619;
        % 建立所有參數組合
        [ h2mesh, slopemesh,  h3mesh] = ndgrid(h2list, slopelist, h3list);
        
        % 計算 Travel time        
        X = h2mesh(:);
        Y = h3mesh(:);
        Z = slopemesh(:);
        figure('Position',[100,100,1200,600])
        set(gcf, 'Color', 'White');
        styleform = {'r:.','b:.', 'g:.', 'g', 'k--', 'b--'};
        %ax1 = nexttile(1, [1 1]); % 這樣讓第一個子圖佔 3 倍高度
        axcell = cell(1,3);
        i = 1;
        [x, ~, h_s] = wv.bg( Z(min_idx_CHT(i)),X(min_idx_CHT(i)), Y(min_idx_CHT(i)),0.1e3);
        plot(x,-h_s,styleform{i}, 'LineWidth',1,'DisplayName',sprintf('s = 1/%.2d,  h_2 = %.2d [m], h_3= %.2d[m]',1/slopemesh(min_idx_CHT(i)),h2mesh(min_idx_CHT(i)),h3mesh(min_idx_CHT(i))));
        hold on
        for i = 2:3
            %axcell{i} = nexttile(i, [1 1]);
            [x, ~, h_s] = wv.bg(Z(min_idx_CHT(i)),X(min_idx_CHT(i)), Y(min_idx_CHT(i)),0.1e3);
            plot(x,-h_s,styleform{i}, 'LineWidth',1,'DisplayName',sprintf('s = 1/%.2d,  h_2 = %.2d [m], h_3= %.2d[m]',1/slopemesh(min_idx_CHT(i)),h2mesh(min_idx_CHT(i)),h3mesh(min_idx_CHT(i))));
            %legend('Location','eastoutside','FontSize',16)
        end
        

        load("2025_midterm_bathymetry_meters.mat");
        xread = x';
        hread = h';
        dx = 0.1e3;
        xend = 500e3;   % 水平domain右端
        x = 0:dx:xend;  % 水平domain
        h1 = 10;
        h2 = 2510;
        h3 = 5500;
        h = interp1(xread, hread, x, 'linear');
        h_s = interp1(xread, hread, x, 'linear');
        plot(x,-h_s,'k', 'LineWidth',1,'DisplayName','actual');

        legend('Location','best','FontSize',18);
        ylabel('$-h$ (m)','Interpreter','latex', 'FontSize', 12)
        %xticklabels([])
        xlabel('$x$ (km)','Interpreter','latex', 'FontSize', 12)
        exportgraphics(gcf, "33nearbathymetry.png");
    case 'utopia'
        animationmode = '1';
        bathymetrymode = 'utopia';
        SW_mid0401;
        

        disp(Tarrive/2773.41*Harrive/4.4619);
        disp(Tarrive/2773);
        disp(Harrive/4.4619);
    case 'animation'
        bathymetrymode = 'real';
        animationmode = 'yes';
        SW_mid0401;
        eta1_real = eta1;
        h_s_real = h_s;
        bathymetrymode = 'utopia';
        animationmode = 'yes';
        SW_mid0401;
        eta1_utopia = eta1;
        h_s_utopia = h_s;
        bathymetrymode = 'chooseone';
        animationmode = 'yes';
        SW_mid0401;
        

        M(20) = struct('cdata', [], 'colormap', []);
        figure('Position', [100, 100, 900, 500]);
        set(gcf, 'Color', 'white');
        for tss = 1:size(eta1,1) 
            t = tiledlayout(4,1, 'TileSpacing', 'compact'); %
        
            ax1 = nexttile(1, [3 1]); % 這樣讓第一個子圖佔 3 倍高度
            plot(x/1e3,U_i(x,0),'b-', 'LineWidth', 2); %水位高
            plot(x1/1e3,eta1(tss,:),'r--','DisplayName','ideal bathymetry');
            
            hold on
            plot(x1/1e3,eta1_utopia(tss, :),'g--','DisplayName','Guessed bathymetry')
            plot(x1/1e3,eta1_real(tss,:),'k-','DisplayName','real bathymetry'); 
            %plot(x,-h(3:end-2),'o--','DisplayName','smoothed-bathmetry',"MarkerFaceColor","#D95319");
            %xlim([0, 30])
            ylim([-0.6, 5.7])
            
            legend(Location="west")
            
            set(gca, 'XTickLabel', [])
            ylabel('\eta (m)','FontSize',14);
            legend('Location','east','FontSize',14);
            title(sprintf('the wave at moment t = %.2f s',t_save(tss)));
            
            
            
            hold off
            ax2 = nexttile(4, [1 1]); % 這樣讓第一個子圖佔 3 倍高度
            plot(x1/1e3,-h_s,'r--','DisplayName','ideal bathymetry');            
            hold on
            plot(x1/1e3,-h_s_utopia,'g--','DisplayName','Guessed bathymetry')
            plot(x1/1e3,-h_s_real,'k-','DisplayName','real bathymetry'); 
            xlabel(sprintf('x(km)'));
            ylabel('-h (m)','FontSize',14);

            hold off

            M(tss) = getframe(gcf);
            
        end
        %%%% Create a VideoWriter object to save the movie
        writerObj = VideoWriter('abruptdepth.avi');
        writerObj.FrameRate = 24; % frame rate
        writerObj.Quality=100; % Adjust the movie quality (100=best)
        open(writerObj);
        
        %%%% Write each frame to the video
        for i = 1:length(M)
            writeVideo(writerObj, M(i));
        end
        %%%% Close the VideoWriter object
        close(writerObj);
    case 'onlyone'
        figure('Position',[100,100,1200,600])
        set(gcf, 'Color', 'White');
        bathymetrymode = 'real';
        animationmode = 'yes';
        SW_mid0401;
        eta1_real = eta1;
        h_s_real = h_s;
        bathymetrymode = 'chooseone';
        animationmode = '0';
        SW_mid0401;
        plot(x1/1e3,-h_s,'r:.','DisplayName','ideal bathymetry');            
        hold on
        plot(x1/1e3, -h_s_real,'k-','DisplayName','real bathymetry');
        xlabel(sprintf('x(km)'));
        ylabel('-h (m)','FontSize',14);
        legend('Location','east','FontSize',14);
        exportgraphics(gcf, "99initialcondition_U.png");
        
end