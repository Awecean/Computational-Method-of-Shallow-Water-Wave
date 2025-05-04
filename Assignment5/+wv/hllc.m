function [F, G] = hllc(etam, etap, Um, Up, h)
    % HLLC(Harten-Lax-van Leer contact) approximation Rieman solver
    % -----------------------
    % Input:
    % etam, etap. The free water height of minus(i+1/2), plus(i-1/2);
    % Um, Up. The wave velocity of minus(i+1/2), plus(i-1/2);
    % h. The water depth of bathymery
    % -----------------------
    % OUput:
    % F = flux of mass flux, 
    % G = flux of momentUm flux
    g = 9.81;
    % got water depth by interploation.
    itemp = 1:1:length(h);
    hp = interp1(itemp, [2*h(1)-h(2) h(1:end-1)], itemp-0.5, 'linear','extrap');
    hm = interp1(itemp, h, itemp-0.5, 'linear','extrap');
    [hp, hm] = wv.muscl(h);
    % total water depth
    Hp = hp+etap; % H^-
    Hm = hm+etam; % H^+
    % u_star and c_star
    ustar = (Um+Up)/2+sqrt(g*Hm)-sqrt(g*Hp);
    cstar = (sqrt(g*Hm)+sqrt(g*Hp))/2+(Um-Up)/4;
    % S (consider wet cell(h>=0), dry cell(h<0), could change citeria)
    S_m = min(Um - sqrt(g * Hm), ustar - cstar).*(h>=0)+...
        (Up-2*sqrt(g*hp)).*(h<0);
    S_p = max(Up + sqrt(g * Hp), ustar + cstar).*(h>=0)+...
        (Um+2*sqrt(g*hm)).*(h<0);
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