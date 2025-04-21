function [eta_next, U_next, V_next] = ssprk(targettype,etanow, Unow, Vnow, h, dt, dx, dy, nx, ny,alpha_m)
%% instruction
% This is the function of SSP-RK method for computing the etanow, Unow, Vnow field;
% and the applicable situation is that 2D domain;
% Combined by 4th-order central difference in space
% and the 3rd-order SSP0RK in time
% ---
% the input data:
% velocity field(Unow, Vnow), water depth field:h, water height: etanow,
% space step: dx, dy, time step: dt
% ---
% the output data:
% velocity field(U_next,V_next) , water height: eta_next
% ---
%% main code;
g = 9.81; %gravitational accleration [m/s^2]
% define zero-matrix
[eta_temp1, eta_temp2, eta_next, U_temp1, U_temp2,...
    U_next, V_temp1, V_temp2, V_next] = deal(zeros(ny,nx));

%first round
for i = 3:nx-2
    for j= 3:ny-2
        eta_temp1(j,i) = etanow(j,i)...
            -dt/12/dx*(-Unow(j,i+2)*h(j,i+2)+8*Unow(j,i+1)*h(j,i+1)...
            -8*Unow(j,i-1)*h(j,i-1)+Unow(j,i-2)*h(j,i-2))...        
            -dt/12/dy*(-Vnow(j+2,i)*h(j+2,i)+8*Vnow(j+1,i)*h(j+1,i)...
            -8*Vnow(j-1,i)*h(j-1,i)+Vnow(j-2,i)*h(j-2,i));

        U_temp1(j,i) = Unow(j,i)...
            -dt*g/12/dx*(-etanow(j,i+2)+8*etanow(j,i+1)-8*etanow(j,i-1)+...
            etanow(j,i-2));

        V_temp1(j,i) = Vnow(j,i)...
            -dt*g/12/dy*(-etanow(j+2,i)+8*etanow(j+1,i)-8*etanow(j-1,i)+...
            etanow(j-2,i));
    end
end
switch targettype
    case 'half'
        %consider Mirror BC of y = 0;
        eta_temp1(1,:) = eta_temp1(5,:); eta_temp1(2,:) = eta_temp1(4,:);
        V_temp1(1,:) = -V_temp1(5,:); V_temp1(2,:) = -V_temp1(4,:);
        U_temp1(1,:) = U_temp1(5,:); U_temp1(2,:) = U_temp1(4,:);
    case 'quarter'
        %consider Mirror BC of y = 0; x = 0;
        eta_temp1(1,:) = eta_temp1(5,:); eta_temp1(2,:) = eta_temp1(4,:);
        eta_temp1(:,1) = eta_temp1(:,5); eta_temp1(:,2) = eta_temp1(:,4);
        V_temp1(1,:) = -V_temp1(5,:); V_temp1(2,:) = -V_temp1(4,:);
        V_temp1(:,1) = V_temp1(:,5); V_temp1(:,2) = V_temp1(:,4);            
        U_temp1(:,1) = -U_temp1(5,:); U_temp1(:,2) = -U_temp1(:,4);
        U_temp1(1,:) = U_temp1(5,:); U_temp1(2,:) = U_temp1(4,:);
    otherwise
end
        
eta_temp1 = eta_temp1.*alpha_m;
U_temp1 = U_temp1.*alpha_m;
V_temp1 = V_temp1.*alpha_m;
% second round
for i = 3:nx-2
    for j= 3:ny-2
        eta_temp2(j,i) = 3/4*etanow(j,i)+1/4*eta_temp1(j,i)...
            -dt/48/dx*(-U_temp1(j,i+2)*h(j,i+2)+8*U_temp1(j,i+1)*h(j,i+1)...
            -8*U_temp1(j,i-1)*h(j,i-1)+U_temp1(j,i-2)*h(j,i-2))...        
            -dt/48/dy*(-V_temp1(j+2,i)*h(j+2,i)+8*V_temp1(j+1,i)*h(j+1,i)...
            -8*V_temp1(j-1,i)*h(j-1,i)+V_temp1(j-2,i)*h(j-2,i));

        U_temp2(j,i) = 3/4*Unow(j,i)+1/4*U_temp1(j,i)...
            -dt*g/48/dx*(-eta_temp1(j,i+2)+8*eta_temp1(j,i+1)...
            -8*eta_temp1(j,i-1)+eta_temp1(j,i-2));

        V_temp2(j,i) = 3/4*Vnow(j,i)+1/4*V_temp1(j,i)...
            -dt*g/48/dy*(-eta_temp1(j+2,i)+8*eta_temp1(j+1,i)...
            -8*eta_temp1(j-1,i)+eta_temp1(j-2,i));
    end
end
switch targettype
    case 'half'
        %consider Mirror BC of y = 0;
        eta_temp2(1,:) = eta_temp2(5,:); eta_temp2(2,:) = eta_temp2(4,:);
        V_temp2(1,:) = -V_temp2(5,:); V_temp2(2,:) = -V_temp2(4,:);
        U_temp2(1,:) = U_temp2(5,:); U_temp2(2,:) = U_temp2(4,:);
    case 'quarter'
        %consider Mirror BC of y = 0; x = 0;
        eta_temp2(1,:) = eta_temp2(5,:); eta_temp2(2,:) = eta_temp2(4,:);
        eta_temp2(:,1) = eta_temp2(:,5); eta_temp2(:,2) = eta_temp2(:,4);
        V_temp2(1,:) = -V_temp2(5,:); V_temp2(2,:) = -V_temp2(4,:);
        V_temp2(:,1) = V_temp2(:,5); V_temp2(:,2) = V_temp2(:,4);            
        U_temp2(:,1) = -U_temp2(5,:); U_temp2(:,2) = -U_temp2(:,4);
        U_temp2(1,:) = U_temp2(5,:); U_temp2(2,:) = U_temp2(4,:);
    otherwise
end
eta_temp2 = eta_temp2.*alpha_m;
U_temp2 = U_temp2.*alpha_m;
V_temp2 = V_temp2.*alpha_m;
% third round
for i = 3:nx-2
    for j= 3:ny-2
        eta_next(j,i) = 1/3*etanow(j,i)+2/3*eta_temp2(j,i)...
            -dt/18/dx*(-U_temp2(j,i+2)*h(j,i+2)+8*U_temp2(j,i+1)*h(j,i+1)...
            -8*U_temp2(j,i-1)*h(j,i-1)+U_temp2(j,i-2)*h(j,i-2))...        
            -dt/18/dy*(-V_temp2(j+2,i)*h(j+2,i)+8*V_temp2(j+1,i)*h(j+1,i)...
            -8*V_temp2(j-1,i)*h(j-1,i)+V_temp2(j-2,i)*h(j-2,i));

        U_next(j,i) = 1/3*Unow(j,i)+2/3*U_temp2(j,i)...
            -dt*g/18/dx*(-eta_temp2(j,i+2)+8*eta_temp2(j,i+1)...
            -8*eta_temp2(j,i-1)+eta_temp2(j,i-2));

        V_next(j,i) = 1/3*Vnow(j,i)+2/3*V_temp2(j,i)...
            -dt*g/18/dy*(-eta_temp2(j+2,i)+8*eta_temp2(j+1,i)...
            -8*eta_temp2(j-1,i)+eta_temp2(j-2,i));
    end
end
%consider Mirror BC of y = 0;

switch targettype
    case 'half'
        %consider Mirror BC of y = 0;
        eta_next(1,:) = eta_next(5,:); eta_next(2,:) = eta_next(4,:);
        V_next(1,:) = -V_next(5,:); V_next(2,:) = -V_next(4,:);
        U_next(1,:) = U_next(5,:); U_next(2,:) = U_next(4,:);
    case 'quarter'
        %consider Mirror BC of y = 0; x = 0;
        eta_next(1,:) = eta_next(5,:); eta_next(2,:) = eta_next(4,:);
        eta_next(:,1) = eta_next(:,5); eta_next(:,2) = eta_next(:,4);
        V_next(1,:) = -V_next(5,:); V_next(2,:) = -V_next(4,:); %y=0
        V_next(:,1) = V_next(:,5); V_next(:,2) = V_next(:,4);            
        U_next(:,1) = -U_next(5,:); U_next(:,2) = -U_next(:,4); %x=0
        U_next(1,:) = U_next(5,:); U_next(2,:) = U_next(4,:);
    otherwise
end
eta_next = eta_next.*alpha_m;
U_next = U_next.*alpha_m;
V_next = V_next.*alpha_m;

end