# 程式問題詢問
## 老師好，不好意思打擾，想請問Assignment6程式撰寫問題
我的程式在運行過程中，總是會導致Complex number的產生。(對於SSPRK的輸出值$\eta, U, H$都是複數)<Br>
已使用testsolver.m(Assignment5程式的改版進行測試)，應該不是hllc算法問題<Br>

註解：我的wv.muscl為輸出所有_{i-1/2}項次之u^+及u^-項<Br>

可直接下載此資料夾測試，執行simulate.m(目前設定為讀取指定的單一檔案\Delta x = 0.1m者)<Br>就能見到錯誤情形(同前所述)


時間步長(dt and dt_temp)上仍為實數，故猜測為wv.ssprkB的問題(B是程式序號)

敬祝 健康平安

## 主要計算環節各程式說明
### Main loop (在simulate.m中的第30行至第55行)
```matlab
while tnow<tend
    u_CFL = max(abs(Unow)+sqrt(g*Hnow));
    dt = C_CFL*dx/u_CFL;
    
    if tnow+dt>=t_target(counts) % 判斷下一時刻點是否超過欲紀錄之指定時刻
        dt_temp = t_target(counts)-tnow; %更改時間步
        [etanow, Unow, Hnow] = wv.ssprkB(etanow, Unow, h, hp, hm, dt_temp, dx, nL); %將參數輸入ssprk程序
        eta{counts} = etanow; tlist(counts) = tnow; tnow = tnow+dt_temp; %下一個時刻點
        fprintf("tnow = %.2f, dt = %.4e\n",tnow, dt_temp);%紀錄是否抵達指定時刻
        fprintf('specific time %d arrived\n', counts);
        counts = counts+1; %使指定時刻點的指標+1        
    else
        dt_temp = dt;
        [etanow, Unow, Hnow] = wv.ssprkB(etanow, Unow, h, hp, hm, dt_temp, dx, nL);
        tnow = tnow+dt_temp;
        if ~isreal(etanow) %若有複數，則中斷程式
            disp('There is complex number');
            break;
        end
    end
    allcount = allcount+1;
end
```
### ssprkB.m (是ssprk程式，但因為有多個版本，所以暫時以ssprkB作為名稱)
重複進行以下5個步驟3輪次
1. boundary condition of eta and U (使用鏡面邊界)
2. 使用hllc計算F, G
3. 計算ssprk各階段
4. 對HU, H引入boundary condition(HU同u, H同eta)
5. 計算eta = H-h; U = HU./H
