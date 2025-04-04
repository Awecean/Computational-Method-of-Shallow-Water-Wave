# Midterm Report
這份報告旨在藉由一維線性淺水波方程及SSP-RK數值方法去模擬簡化的海嘯行進問題。
海床水深資料來源為 https://www.gebco.net/

This report aims to by 1D-LSWE and SSP-RK numerical scheme simulating a simplified tsunami propagation problem.
data source of nearshore water depth: https://www.gebco.net/
## 報告流程
總共要繪製圖形及口頭報告大致流程如下：
(目前覺得這樣比較有故事性)

概述
0. 數值模型說明

1. 什麼是最佳網格解析度(與600s作對比)(之後沿用該解析度)
   1.1 收斂性測試(說明我們接下來為什麼選用該dx)

3. 波浪傳遞情形
    2.1 理想海床
2.1.1 各時刻點瞬照(Bathymetry1)
2.1.2.各站點(Bathymetry1)
2.2 實際海床
2.2.1 各時刻點
2.2.2 各站點
2.3 比較(當然也可同時)
2.4 波浪傳遞至浪邊的波高與時間

4. 什麼是最好的海底組合
3.1 定義原因：H與T。(比率性)
承前述，我們有得到目標值barH, barT
(解釋理由：因為對於海嘯災害防治，我們最為關注的問題可簡略為2點：
    1.近岸浪高多大、2.抵岸時間多長)
3.2 多個不同底床的參數及形貌(多圖，小，或短列table)
3.3 一張3D圖片總結，並展示最佳化底床地形與Bathymetry1差異

5. 從A點到D點的歷時-將3者進行比較，以Actual-B1, Actual-Bbest。並且繪製於3張圖中。

6. 問題與挑戰：analytical solution
    講解一下analytical估算，與他失敗的原因。

7. 總結

-------------------------------------------------------------------------
The code development was made possible thanks to my dear teammate’s efforts.
