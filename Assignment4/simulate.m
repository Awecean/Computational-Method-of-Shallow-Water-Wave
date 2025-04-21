% simulateprocedure
% this is the program to simulate the process of ssprk

% load initial data
folderPath = fullfile(pwd, 'data');
load(fullfile(folderPath, sprintf('initial%s%s%d.mat',bathymetrytype,region,spaceindex)));
counts = 1; % specific time count
tnow = 0; % set time
etanow = eta0; Unow = U0; Vnow = V0;
[eta, U, V] = deal(cell(nts,1));
if ~exist('animationmode', 'var'); animationmode = 0; end

tlist = zeros(nts,1);
eta_all = {};
tlist_all = [];
allcount = 1;
while tnow<tend
    if tnow+dt>= t_target(counts)
        dt_temp = t_target(counts)-tnow;
        [etanow,Unow,Vnow]= wv.ssprk(region,etanow, Unow, Vnow,h,...
            dt_temp,dx,dy,nx,ny,alpha_m);
        eta{counts} = etanow; U{counts} = Unow; V{counts} = Vnow;
        tnow = tnow+dt_temp;               
        tlist(counts) = tnow;
        counts = counts+1;

    else
        dt_temp = dt;
        [etanow,Unow,Vnow]= wv.ssprk(region,etanow, Unow, Vnow,h,...
            dt_temp,dx,dy,nx,ny,alpha_m); 
        tnow = tnow+dt_temp;
    end
    if animationmode == 1%record all time
        eta_all{end+1} = etanow;
        tlist_all(end+1) = tnow;
    end
end
%save processed data
folderPath = fullfile(pwd, 'data');
save(fullfile(folderPath, sprintf('pdata%s%s%d.mat',bathymetrytype,region,spaceindex)));
