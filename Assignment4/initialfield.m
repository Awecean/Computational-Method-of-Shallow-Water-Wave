% initialfield
% this is the program to generate the initial field
Lx = 300; Ly = 300; % length of space domain [m]
Ls = 40; % length of space domain.
dx = 0.5*2^(spaceindex); dy = 0.5*2^(spaceindex); % length of space step [m]
switch region
    case 'full' % 
        x = -(Lx+Ls):dx:(Lx+Ls); % x-domain
        y = -(Ly+Ls):dy:(Ly+Ls); % y-domain
    case 'half' % upper half
        x = -(Lx+Ls):dx:(Lx+Ls); % x-domain
        y = 0:dy:(Ly+Ls); % y-domain
    case 'quarter' %quarter in 1st quarant
        x = 0:dx:(Lx+Ls); % x-domain
        y = 0:dy:(Ly+Ls); % y-domain

end
nx = length(x); ny = length(y); % quantity of space domain.
[X,Y] = meshgrid(x,y); % space-domain-grid
H = 1;      % wave height [m]
L = 100;    % wavelength [m]

h0 = 10;     % water dpeth field coeffiecent.[m]
switch bathymetrytype
    case 'flat'
        h = h0*ones(size(X)); %
    case 'slide'
        h = h0/2*(X/(Lx+Ls)+1);
    case 'abrupt'
        h = h0*ones(size(X)); %
        h(X<0) = h0/2;
        smoothdata2(h,"gaussian");
    case 'plat'
        h = h0*ones(size(X));
        h(R<100) = h0/2;
end
figure('Position',[100,100,600,600])
set(gcf,'Color','white');
pcolor(X,Y,-h,'LineStyle','none');
xlabel('x (m)','FontSize',12);
ylabel('y (m)','FontSize',12);
axis equal
xlim([-(Lx+Ls),Lx+Ls]);
ylim([-(Ly+Ls),Ly+Ls]);
c=colorbar('FontSize',12);
clim([-h0,0]);
c.Label.String = '-h (m)';
if spaceindex ==1
    exportgraphics(gcf, fullfile("figure",sprintf("Fig11a_bathmetry%s%s.pdf",bathymetrytype,region)), 'ContentType', 'image');
end

%%
g = 9.81; %gravitational accleration [m/s^2]
C_cfl = 0.9; % Courant number
dt = 0.9*min([dx,dy])/sqrt(g*max(h(:))); % time step
tend = 20; % finish time
t = 0:dt:tend; % time domain [s]
nt = length(t);
t_target = 0:1:tend;
nts = length(t_target);




eta0 = H*(sech(2*pi/L*sqrt(X.^2+Y.^2))).^2; % initial eta
[U0, V0] = deal(zeros(ny, nx)); %initial velocity field
[eta, U, V] = deal(cell(nts,1));

R = sqrt(X.^2+Y.^2); % radial coordinate
theta = atan2(Y,X);
%% This is the coefficient matrix of sponge layer end
alpha_m_x = (0.5+0.5.*cos((Lx+x)*pi/Ls)).*(x<=-Lx)+1.*(x>-Lx).*(x<Lx)...
    +(0.5+0.5.*cos((Lx-x)*pi/Ls)).*(x>=Lx);
alpha_m_y = (0.5+0.5.*cos((Ly+y)*pi/Ls)).*(y<=-Ly)+1.*(y>-Ly).*(y<Ly)...
    +(0.5+0.5.*cos((Ly-y)*pi/Ls)).*(y>=Ly);
alpha_m = alpha_m_y(:)*alpha_m_x(:).';
%mesh(X,Y,alpha_m);
%%
% save data of initial field
if ~exist(fullfile(pwd, 'data'), 'dir'), mkdir(fullfile(pwd, 'data')); end 
folderPath = fullfile(pwd, 'data');
save(fullfile(folderPath, sprintf('initial%s%s%d.mat',bathymetrytype,region,spaceindex))); 