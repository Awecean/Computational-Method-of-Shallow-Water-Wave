function [F, G] = hllc(etam, etap, Um, Up, hm, hp,h)
    % HLLC(Harten-Lax-van Leer contact) approximation Rieman solver
    % -----------------------
    % Input:
    % etam, etap. The free water height of minus(i-1/2), plus(i-1/2);
    % Um, Up. The wave velocity of minus(i-1/2), plus(i-1/2);
    % h. The water depth of bathymery
    % -----------------------
    % OUput:
    % F = flux of mass flux, 
    % G = flux of momentUm flux
    g = 9.81;
    Hwet = 0; %a citerion of whether the cell is dry;

    % total water depth
    Hp = hp+etap; % H^-
    Hm = hm+etam; % H^+
    % u_star and c_star
    ustar = (Um+Up)/2+sqrt(g*Hm)-sqrt(g*Hp);
    cstar = (sqrt(g*Hm)+sqrt(g*Hp))/2+(Um-Up)/4;
    % S (consider wet cell(h>=Hwet), dry cell(h<Hwet), could change citeria)
    S_m = min(Um - sqrt(g * Hm), ustar - cstar).*(h>=Hwet)+...
        (Up-2*sqrt(g*hp)).*(h<Hwet);
    S_p = max(Up + sqrt(g * Hp), ustar + cstar).*(h>=Hwet)+...
        (Um+2*sqrt(g*hm)).*(h<Hwet);
    % parameter of flow: phi and flux f
    phi_m = [Hm; Hm .* Um];
    phi_p = [Hp; Hp .* Up];

    f_m = [Hm .* Um; Hm .* Um.^2 + g/2 * (etam.^2 + 2 * etam .* hm)];
    f_p = [Hp .* Up; Hp .* Up.^2 + g/2 * (etap.^2 + 2 * etap .* hp)];

    % parameter of intercell
    phi_star_m = Hm.*((S_m-Um)./(S_m-ustar)).*[ones(size(ustar)); ustar];
    phi_star_p = Hp.*((S_p-Up)./(S_p-ustar)).*[ones(size(ustar)); ustar];

    % declar empty f, and compute
    N = length(h);
    f = zeros(2,N);

    for i = 1:N
        if 0 <= S_m(i)
            f(:,i) = f_m(:,i);
        elseif 0 <= ustar(i)
            f(:,i) = f_m(:,i) + S_m(i) * (phi_star_m(:,i) - phi_m(:,i));
        elseif 0 <= S_p(i)
            f(:,i) = f_p(:,i) + S_p(i) * (phi_star_p(:,i) - phi_p(:,i));
        else
            f(:,i) = f_p(:,i);
        end
    end
    F = f(1,:);% F = flux of mass flux 
    G = f(2,:);% G = flux of momentUm flux
end
