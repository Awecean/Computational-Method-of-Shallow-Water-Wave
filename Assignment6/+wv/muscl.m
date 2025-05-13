function [up, um] = muscl(u)
    % ouput the intercell data  with subindex i-1/2
    % where the subindex of u is i (for cell-averaged data)
    unew = [3*u(1)-2*u(2) 2*u(1)-u(2) u 2*u(end)-u(end-1) 3*u(end)-2*u(end-1)];

    duplus = unew(2:end)-unew(1:end-1);
    duminus = unew(2:end)-unew(1:end-1);
    duplus = duplus(2:end); duminus = duminus(1:end-1);
    dui = abs(duplus)+abs(duminus);

    du = ((duplus.*abs(duminus)+duminus.*abs(duplus))./dui).*(dui~=0);
    du(isnan(du)) = 0;
    up = [2*u(1)-u(2) u 2*u(end)-u(end-1)]+0.5*du; %uL derived from left
    up = up(1:end-2);
    um = [2*u(1)-u(2) u 2*u(end)-u(end-1)]-0.5*du; %uR derived from right
    um = um(2:end-1);
end
