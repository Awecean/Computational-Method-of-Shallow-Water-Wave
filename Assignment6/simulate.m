% simulate procedure
% this is the program to simulate the NSWE
% non-linear wave equation
clear;
dx_index = 1;
%% read initial data
folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('initial%d.mat',dx_index)));
%% main simulate procedure
h = [h(2) h(1) h h(end) h(end-1)];
[hp, hm] = wv.muscl(h);
%%
nL = length(h);
Unow = [-U0(2) -U0(1) U0 -U0(end) -U0(end-1)];
etanow = [eta0(2) eta0(1) eta0 eta0(end) eta0(end-1)];
Hnow = h+etanow;
counts = 1; % specific time count
tnow = 0;   % set initial time
[eta] = deal(cell(nts,1));
tlist = zeros(nts,1);
eta_all = {};
tlist_all = [];
allcount = 0;
disp('ok')
%%
u_CFL = max(abs(Unow)+real(sqrt(g*Hnow)));
dt = C_CFL*dx/u_CFL;
sprintf('%.3c', u_CFL);
%%
while tnow<tend
    u_CFL = max(abs(Unow)+g*Hnow);
    dt = C_CFL*dx/u_CFL;
    
    if tnow+dt>=t_target(counts)
        dt_temp = t_target(counts)-tnow;
        
        [etanow, Unow, Hnow] = wv.ssprkB(etanow, Unow, h, hp, hm, dt, dx, nL);
        eta{counts} = etanow;
        tlist(counts) = tnow;
        tnow = tnow+dt_temp;
        fprintf("tnow = %.2f, dt = %.4e\n",tnow, dt_temp)
        fprintf('specific time %d arrived\n', counts);
        counts = counts+1;
        
    else
        dt_temp = dt;
        [etanow, Unow, Hnow] = wv.ssprkB(etanow, Unow, h, hp, hm, dt, dx, nL);
        tnow = tnow+dt_temp;
        if ~isreal(etanow)
            disp('There is complex number');
            break;
        end
    end
    allcount = allcount+1;
end
%% save processed data
folderPath = fullfile(pwd, 'data');
save(fullfile(folderPath, sprintf('pdata%d.mat',dx_index)));
