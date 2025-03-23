function y = analyeta(x, h1, h2, t, x0, xs)
%ANALYETA Summary of this function goes here
%   Detailed explanation goes here

[~,xsidx] = min(abs(x-xs));
stepx = x(xsidx)-x(xsidx-1);
ytemp =wv.waveform('inci',x,h1,h2,t,x0,xs)+...
     wv.waveform('refl',x,h1,h2,t,x0,xs)+...
     wv.waveform('tran',x,h1,h2,t,x0,xs);
steps = 2;
for i = xsidx-steps:xsidx+steps
    ytemp(i) = ytemp(xsidx-steps)+(ytemp(xsidx+steps)-ytemp(xsidx-steps))*(1+tanh((i-xsidx)*stepx))/2;
end
y = ytemp;
end

