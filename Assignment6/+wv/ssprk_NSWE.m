function [eta_next, U_next, H_next] = ssprk_NSWE(etanow, Unow, h, hp, hm, dt, dx, nL)
%Instruction
% This is the new function of ssprk-program
% while enter the time-variable data:
% --- eta, U, dt
% and some parameter: h, hp, hm, dx, nx
% we can yield the data of next moment
% eta_next, U_next, H_next
    g = 9.81;
    [H_temp1, H_temp2, H_next, HU_temp1, HU_temp2, HU_next] = deal(zeros(1,nL)); %創建空的陣列，大小同增加虛魅網格後的h長度
    H = etanow+h;

    % round 1-phase 1 impose bodary condition and the muscl, hllc
    etanow = [etanow(4) etanow(3) etanow(3:end-2) etanow(end-2) etanow(end-3)]; %使用mirror boundary
    U = [-Unow(4) -Unow(3) Unow(3:end-2) -Unow(end-2) -Unow(end-3)]; %使用mirror boundary
    HU = H.*U; %計算當前(原先)時刻的HU (下標為i)
    [Up, Um] = wv.muscl(U); [etap, etam] = wv.muscl(etanow); %藉由muscl重構i-1/2處的數值
    [F, G] = wv.hllc(etam, etap, Um, Up, hm, hp, h); % 由以上數據，建立F,G 於i-1/2處的數值，長度為h長(nL)
    % round 1-phase 2 SSP-RK
    for i = 3:nL-2
        H_temp1(i) = H(i)-dt/dx*(F(i+1)-F(i)); %計算temp1時，(ssp-rk)1/3階段後的臨時值H*_i
        HU_temp1(i) = HU(i)-dt/dx*(G(i+1)-G(i))+dt/2/dx*g*etanow(i)*(h(i+1)-h(i-1)); %計算temp1時，(ssp-rk)1/3階段後的臨時值H*_i
    end
    H_temp1 = [H_temp1(4) H_temp1(3) H_temp1(3:end-2) H_temp1(end-2) H_temp1(end-3)]; %引入boundary condition，避免HU./H時出錯
    HU_temp1 = [-HU_temp1(4) -HU_temp1(3) HU_temp1(3:end-2) -HU_temp1(end-2) -HU_temp1(end-3)]; %引入boundary condition，避免HU.H時出錯
    eta_temp1 = H_temp1-h; %藉由[H]-h建立eta_temp1
    U_temp1 = HU_temp1./H_temp1; %藉由[HU]./[H]
    % round 2-phase 1 
    eta_temp1 = [eta_temp1(4) eta_temp1(3) eta_temp1(3:end-2) eta_temp1(end-2) eta_temp1(end-3)];
    U_temp1 = [-U_temp1(4) -U_temp1(3) U_temp1(3:end-2) -U_temp1(end-2) -U_temp1(end-3)];
    [U_temp1p, U_temp1m] = wv.muscl(U_temp1); [eta_temp1p, eta_temp1m] = wv.muscl(eta_temp1);
    
    [F_temp1, G_temp1] = wv.hllc(eta_temp1m, eta_temp1p, U_temp1m, U_temp1p, hm, hp, h);

    % round 2-phase 2
    for i = 3:nL-2
        H_temp2(i) = 3/4*H(i)+1/4*H_temp1(i)-1/4*dt/dx*(F_temp1(i+1)-F_temp1(i));
        HU_temp2(i) = 3/4*HU(i)+1/4*HU_temp1(i)-1/4*dt/dx*...
            (G_temp1(i+1)-G_temp1(i))+dt/8/dx*g*eta_temp1(i)*(h(i+1)-h(i-1));
    end
    H_temp2 = [H_temp2(4) H_temp2(3) H_temp2(3:end-2) H_temp2(end-2) H_temp2(end-3)]; %引入boundary condition，避免HU./H時出錯
    HU_temp2 = [-HU_temp2(4) -HU_temp2(3) HU_temp2(3:end-2) -HU_temp2(end-2) -HU_temp2(end-3)]; %引入boundary condition，避免HU.H時出錯
    eta_temp2 = H_temp2-h;
    U_temp2 = HU_temp2./H_temp2;
    % round 3-phase 1
    eta_temp2 = [eta_temp2(4) eta_temp2(3) eta_temp2(3:end-2) eta_temp2(end-2) eta_temp2(end-3)];
    U_temp2 = [-U_temp2(4) -U_temp2(3) U_temp2(3:end-2) -U_temp2(end-2) -U_temp2(end-3)];
    H_temp2 = eta_temp2+h;
    [U_temp2p, U_temp2m] = wv.muscl(U_temp2); [eta_temp2p, eta_temp2m] = wv.muscl(eta_temp2);
    %HU_temp2 = H_temp2.*U_temp2;
    [F_temp2, G_temp2] = wv.hllc(eta_temp2m, eta_temp2p, U_temp2m, U_temp2p, hm, hp, h);

    % round 3-phase 2
    for i = 3:nL-2
        H_next(i) = 1/3*H(i)+2/3*H_temp2(i)-2/3*dt/dx*(F_temp2(i+1)-F_temp2(i));
        HU_next(i) = 1/3*HU(i)+2/3*HU_temp2(i)-2/3*dt/dx*...
            (G_temp2(i+1)-G_temp2(i))+dt/3/dx*g*eta_temp2(i)*(h(i+1)-h(i-1));
    end
    H_next = [H_next(4) H_next(3) H_next(3:end-2) H_next(end-2) H_next(end-3)]; %引入boundary condition，避免HU./H時出錯
    HU_next = [-HU_next(4) -HU_next(3) HU_next(3:end-2) -HU_next(end-2) -HU_next(end-3)]; %引入boundary condition，避免HU.H時出錯
    % result
    eta_next = H_next-h;
    U_next = HU_next./H_next;
end
