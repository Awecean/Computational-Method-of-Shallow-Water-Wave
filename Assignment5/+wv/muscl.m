function [uL, uR] = muscl(u)
    unew = [2*u(1)-u(2) u 2*u(end)-u(end-1)];
    duplus = unew(2:end)-unew(1:end-1);
    duminus = unew(2:end)-unew(1:end-1);
    duplus = duplus(2:end); duminus = duminus(1:end-1);
    dui = abs(duplus)+abs(duminus);

    du = ((duplus.*abs(duminus)+duminus.*abs(duplus))./dui).*(dui~=0);
    du(isnan(du)) = 0;
    uL = u+0.5*du;
    uR = u-0.5*du;
end