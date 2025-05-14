% simulate procedure
% this is the program to simulate the LSWE(Linear shallow water equation)
% non-linear wave equation
clear;
dx_index = 1;
%% read initial data
folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('initial%d.mat',dx_index)));
%%
nL = length(h);
Unow = wv.bc(U0,'mirror','u');
etanow = wv.bc(eta0,'mirror','eta');

counts = 1; % specific time count
tnow = 0;   % set initial time
[eta] = deal(cell(nts,1));
tlist = zeros(nts,1);
eta_all = {};
tlist_all = [];
allcount = 0;
%disp('ok')
%%
C_CFL = 0.5;
dt = C_CFL*dx/max(abs(Unow));
%%
while tnow<tend
    dt = C_CFL*dx/max(abs(Unow));
    
    if tnow+dt>=t_target(counts)
        dt_temp = t_target(counts)-tnow;
        [etanow, Unow] = wv.ssprk_LSWE(etanow, Unow, h, dx, dt, nL);
        eta{counts} = etanow;
        tlist(counts) = tnow+dt_temp;
        tnow = tnow+dt_temp;
        %fprintf("tnow = %.2f, dt = %.4e\n",tnow, dt_temp)
        %fprintf('specific time %d arrived\n', counts);
        counts = counts+1;
        
    else
        dt_temp = dt;
        [etanow, Unow] = wv.ssprk_LSWE(etanow, Unow, h, dx, dt, nL);
        tnow = tnow+dt_temp;
    end
    allcount = allcount+1;
end
%% save processed data
folderPath = fullfile(pwd, 'data');
save(fullfile(folderPath, sprintf('LSWEdata%d.mat',dx_index)));
