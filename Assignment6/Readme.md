# 程式問題詢問
## 老師好，不好意思打擾，想請問Assignment6程式撰寫問題
我的程式在運行過程中，總是會導致Complex number的產生。(對於SSPRK的輸出值$\eta, U, H$都是複數)<Br>
已使用testsolver.m(Assignment5程式的改版進行測試)，應該不是hllc算法問題<Br>

註解：我的wv.muscl為輸出所有_{i-1/2}項次之u^+及u^-項<Br>

可直接下載此資料夾測試，執行simulate.m(目前設定為讀取指定的單一檔案\Delta x = 0.1m者)<Br>就能見到錯誤情形(同前所述)


時間步長(dt and dt_temp)上仍為實數，故猜測為wv.ssprkB的問題(B是程式序號)

敬祝 健康平安

## 主要計算環節各程式說明
### Main loop
```matlab
while tnow<tend
    u_CFL = max(abs(Unow)+sqrt(g*Hnow));
    dt = C_CFL*dx/u_CFL;
    
    if tnow+dt>=t_target(counts)
        dt_temp = t_target(counts)-tnow;
        
        [etanow, Unow, Hnow] = wv.ssprkB(etanow, Unow, h, hp, hm, dt_temp, dx, nL);
        eta{counts} = etanow;
        tlist(counts) = tnow;
        tnow = tnow+dt_temp;
        fprintf("tnow = %.2f, dt = %.4e\n",tnow, dt_temp)
        fprintf('specific time %d arrived\n', counts);
        counts = counts+1;
        
    else
        dt_temp = dt;
        [etanow, Unow, Hnow] = wv.ssprkB(etanow, Unow, h, hp, hm, dt_temp, dx, nL);
        tnow = tnow+dt_temp;
        if ~isreal(etanow)
            disp('There is complex number');
            break;
        end
    end
    allcount = allcount+1;
end

```
