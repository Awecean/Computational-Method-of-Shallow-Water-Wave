% this is the program to generate several different initial data
% and save the data as .mat file
h0 = 0.2;       % water depth (m)
g = 9.81;       % gravitational accleration (m^2/s)
x = -4:dx:8;    % x-domain (m)
H0 = 0.1;       % initial wave height(m)
h = h0*ones(size(x));           % water depth (m)
% got water depth by interploation.
K = 1./h.*sqrt((3*H0)./(4*h));  % initial characteristic wave number
eta0 = H0*(sech(K.*x)).^2;      % elevation of initial solitary wave
U0 = eta0./h.*sqrt(g*h);        % initial velocity
C_CFL = 0.9;    % Courant number
tend = 5;      % finish time
t_target = 0:0.5:tend;
nts = length(t_target);
animationmode = 0;
%if dx_index ==1
%    animationmode =1; % will record all time's data
%else 
%    animationmode =0;
%end
%save data as a file
if ~exist(fullfile(pwd, 'data'), 'dir'), mkdir(fullfile(pwd, 'data')); end 
folderPath = fullfile(pwd, 'data');
save(fullfile(folderPath, sprintf('initial%d.mat',dx_index))); 