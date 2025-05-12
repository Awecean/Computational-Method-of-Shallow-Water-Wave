# 老師好，不好意思打擾，想請問Assignment6程式撰寫問題

我的程式在運行過程中，總是會導致Complex number的產生。(對於SSPRK的輸出值$\eta, U, H$都是複數)<Br>
已使用testsolver.m(Assignment5程式的改版進行測試)，應該不是hllc算法問題<Br>

註解：我的wv.muscl為輸出所有_{i-1/2}項次之u^+及u^-項<Br>

可直接下載此資料夾測試，執行simulate.m(目前設定為讀取指定的單一檔案\Delta x = 0.1m者)<Br>就能見到錯誤情形(同前所述)


時間步長(dt and dt_temp)上仍為實數，故猜測為wv.ssprkB的問題(B是程式序號)

敬祝 健康平安
