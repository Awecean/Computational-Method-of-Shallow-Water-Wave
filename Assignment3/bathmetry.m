% Assignment #3
% Po-Tao, Lin
% CE B1150137
% This is a program by include the dx from Main

%% Parameter Setting
H = 0.03;
h1 = 0.2;
h2 = 0.03;
g = 9.81;
x0 = 6; %initial position of the wave's crest
ts = 6;
xs = 20;% the horizon abtupr depth occures
tend = 20;

%% I.C. setting 
dx = 0.02*index; % space-step
x = 0:dx:30; % space-domain
nx = length(x); % quantity of x data

h = ones([1,nx]);

%%% smooth h
switch baseset
    case 'flat' %flat type
        h = h1*ones([1,nx]);
    case 'abrupt'
        h(x<=xs) = h1;
        h(x>xs) = h2;
    case 'abruptsmoothed'
        h(x<=xs) = h1;
        h(x>xs) = h2;
        [~,hidx] = min(abs(x-xs));        
        %%% take the nearst 7 point to smmoth(hidx is the 3th)
        s = 10;
        for i = (hidx-3):(hidx+3)
            h(i) = h1-(h1-h2)*(1+tanh(s*(i-(hidx))*dx))/2;            
        end
end


C_cfl = 0.9; % Courant number

dt = dx/sqrt(g*max(h)); % time-step

eta0 = wv.waveform('simple', x, h1,h2,0,x0,xs);
U0 = wv.bc(eta0./h.*sqrt(g.*h),'nd');

%% Motion simulation
%%% simulation initial 
h = wv.bc(h, 'm', 'h');
Utemp = wv.bc(U0, 'm', 'u');
etatemp = wv.bc(eta0,'m','eta');

tprimary = zeros(1,tend+1);
ttemp = 0;
etaprimary = zeros(tend+1,length(h));
tcord = 0;
etaprimary(1,:) = etatemp;
tsecondary = ttemp;
etasecondary = etatemp;

while ttemp <= tend
    tsecondary = [tsecondary; ttemp];
    etasecondary = [etasecondary; etatemp];

    if ttemp+dt >= tcord
        dttemp = tcord-ttemp;
        ttemp = ttemp+dttemp;
        
        [etatemp, Utemp] = wv.ssprk(etatemp, Utemp, h, dx, dttemp);
        tcord = tcord+1;
        tprimary(tcord) = ttemp;
        etaprimary(tcord,:) = etatemp;
        
    else 
        ttemp = ttemp+dt;
        [etatemp, Utemp] = wv.ssprk(etatemp, Utemp, h, dx, dt);
    
    end
end
gerror = zeros(1,tend);

folderPath = fullfile(pwd, 'data');
if ~exist(folderPath, 'dir'), mkdir(folderPath); end 

switch baseset
    case 'flat'
        for i = 1:tend
            gerror(i) =sqrt(dx*sum((etaprimary(i+1,3:end-2)-wv.analyeta(x,h1,h1,i,x0,xs)).^2));
        end      
    case 'abrupt'
        save(fullfile(folderPath, sprintf('%s%d.mat',baseset,index)), "index","dx","x","x0","xs","tprimary","tsecondary","etaprimary","etasecondary","h","h1","h2","gerror"); 

    case 'abruptsmoothed'
        for i = 1:tend
            gerror(i) =sqrt(dx*sum((etaprimary(i+1,3:end-2)-wv.analyeta(x,h1,h1,i,x0,xs)).^2));
        end 
end
save(fullfile(folderPath, sprintf('%s%d.mat',baseset,index)), "index","dx","x","x0","xs","tprimary","tsecondary","etaprimary","etasecondary","h","h1","h2","gerror"); 



