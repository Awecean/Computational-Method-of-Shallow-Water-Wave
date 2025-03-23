function y = waveform(typeset, x, h1, h2, t, x0, xs)
% This function is used to generating the waveform (eta) a a wave, can
% solve the problem if you give some parameters& conditions
% typeset is the water's type:
%%% 'simple': a wave without bathmetry abrupt.'inci': incident wave. 'refl': reflected wave, 'tran' = reansimitted wave 
%%% h1 is the initial water depth, h2 is the after water depth.

H = 0.03; % solitary wave height
g = 9.81;

C1 = sqrt(g*h1);
C2 = sqrt(g*h2);
[~,xsidx] = min(abs(x-xs));

switch typeset
    case 'simple'
        C = C1;
        K = 1/h1*sqrt((3*H)/(4*h1));
        y =  H*(sech(K*(x-x0-C*t))).^2;
    case 'inci'
        C = C1;
        K = 1/h1*sqrt((3*H)/(4*h1));
        y =  H*(sech(K*(x-x0-C*t))).^2;
        y(xsidx+1:end) = 0;
    case 'refl'
        x0 = 2*xs-x0;
        H = (C1-C2)/(C1+C2)*H;
        K = 1/h1*sqrt((3*H)/(4*h1));
        C = -C1;
        y = H*(sech(K*(x-x0-C*t))).^2;
        y(xsidx+1:end) = 0;
    case 'tran'
        C = C2;
        H = (2*C1)/(C1+C2)*H;
        K = 1/h1*sqrt((3*H)/(4*h2));
        x0 = xs-(xs-x0)/C1*C2;
        y = H*(sech(K*(x-x0-C*t))).^2;
        y(1:xsidx-1) = 0;
    otherwise 
        disp('wrong value of the typeset of BC')
end

