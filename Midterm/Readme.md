# Midterm Report
這份報告旨在藉由一維線性淺水波方程及SSP-RK數值方法去模擬簡化的海嘯行進問題。<Br>
海床水深資料來源為 https://www.gebco.net/<Br>
此處儲存程式及相關資料、圖片等<Br>
可見模擬結果動畫於https://youtu.be/b3keXdZv-GE
## FlowChart
```mermaid
graph LR
   A[Main]-->B[/need<Br> animationmode/]
   B --> C[SW_mid0401.m]
   C -->|need: 'report**'| D[making plot of bathymetry]
   C -->|need: 'erroranalysis'| E[SW_mid_2_t.m]
   C -->|need: '**'| F[making plot someelse]
   C -->|need: 'animation'<Br> animtionmode: 'yes'| G[making animation]
```
-------------------------------------------------------------------------
The code development was made possible thanks to teammate’s efforts.
