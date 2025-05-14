% simulate procedure
% this is the program to simulate the NSWE
% non-linear wave equation
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
eta_all = [];
tlist_all = [];
allcount = 0;
C_CFL = 0.9;
u_CFL = max(abs(Unow)+sqrt(g*Hnow));
dt = C_CFL*dx/u_CFL;

while tnow<tend
    u_CFL = max(abs(Unow)+sqrt(g*Hnow));
    dt = C_CFL*dx/u_CFL;
    
    if tnow+dt>=t_target(counts)
      
        dt_temp = real(t_target(counts)-tnow);
        %fprintf("tnow = %.2f, dt = %.4e\n",tnow, dt_temp)
        [etanow, Unow, Hnow] = wv.ssprk_NSWE(etanow, Unow, h, hp, hm, dt_temp, dx, nL);
        eta{counts} = etanow;
        tnow = tnow+dt_temp;
        tlist(counts) = tnow;

        %fprintf('specific time %d arrived\n', counts);
        counts = counts+1;
        
    else
        dt_temp = dt;
        [etanow, Unow, Hnow] = wv.ssprk_NSWE(etanow, Unow, h, hp, hm, dt_temp, dx, nL);
        tnow = tnow+dt_temp;
        if min(Hnow)<0
            disp('There is complex number at data "etanow"');
            eta_all = [eta_all; Unow];
            break;
        end
    end
    allcount = allcount+1;
    tlist_all= [tlist_all, tnow];
    eta_all = [eta_all; Hnow];
end
%% save processed data
folderPath = fullfile(pwd, 'data');
save(fullfile(folderPath, sprintf('NSWEdata%d.mat',dx_index)));
