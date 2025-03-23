function [etanext, Unext] = ssprk(eta, u, h, dx, dt)
%SSP-RK 
%
g = 9.81;
n = length(h);

[etanext, Unext, etat1, etat2, Ut1, Ut2] = deal(zeros(size(h)));
% SSP-RK processing
    for j = 3:n-2
        etat1(j) = eta(j) - dt/(12*dx)*(-u(j+2)*h(j+2)+8*u(j+1)*h(j+1)-8*u(j-1)*h(j-1)+u(j-2)*h(j-2));
        Ut1(j) = u(j) - (dt*g)/(12*dx)*(-eta(j+2)+8*eta(j+1)-8*eta(j-1)+eta(j-2));
    end
    etat1 = wv.bc(etat1(3:end-2), 'm', 'eta');
    Ut1 = wv.bc(Ut1(3:end-2),'m','u');

    for j = 3:n-2
        etat2(j) = (3/4)*eta(j)+(1/4)*etat1(j)- dt/(48*dx)*(-Ut1(j+2)*h(j+2)+8*Ut1(j+1)*h(j+1)-8*Ut1(j-1)*h(j-1)+Ut1(j-2)*h(j-2));
        Ut2(j) = (3/4)*u(j)+(1/4)*Ut1(j)-(dt*g)/(48*dx)*(-etat1(j+2)+8*etat1(j+1)-8*etat1(j-1)+etat1(j-2));
    end
    etat2 = wv.bc(etat2(3:end-2), 'm', 'eta');
    Ut2 = wv.bc(Ut2(3:end-2), 'm','u');

    for j = 3:n-2
        etanext(j) = (1/3)*eta(j)+(2/3)*etat2(j)- dt/(18*dx)*(-Ut2(j+2)*h(j+2)+8*Ut2(j+1)*h(j+1)-8*Ut2(j-1)*h(j-1)+Ut2(j-2)*h(j-2));
        Unext(j) = (1/3)*u(j)+(2/3)*Ut2(j)-(dt*g)/(18*dx)*(-etat2(j+2)+8*etat2(j+1)-8*etat2(j-1)+etat2(j-2));
    end
    etanext = wv.bc(etanext(3:end-2), 'm', 'eta');
    Unext = wv.bc(Unext(3:end-2),'m', 'u');
end

