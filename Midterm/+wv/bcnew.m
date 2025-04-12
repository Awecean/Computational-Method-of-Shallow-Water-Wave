function  y = bcnew(x,typesetleft, typesetright,paratypeset)
% This function is used to generating ghost cell for match the Boundary
% Condition, you can input a array and got enough data.

% x: is the array which is origin horizon space array; 
% typesetleft, typesetright: the B.C. way:
% 'ND':'Neumann& Dirichlet; 'p':'periodic'; 'm','mirror'; 'o': 'open'  
    switch typesetleft
        case 'nd'
            yl = [0 x(2:end-1)];
        case 'p' %periodic
            y1 = [x(end-2) x(end-1) x];
        case 'm'
            switch paratypeset
                case 'u'
                    x = [0 x(2:end-1)];
                    y1 = [-x(3) -x(2) x];
                case {'eta', 'h'}
                    y = [x(3) x(2) x];
                otherwise
                    disp('wrong value of the typeset of parameter')
            end 
        case 'o'
            y = 1;
    end

    switch typesetright
        case 'nd'
            y = [yl 0 0];
        case 'p'
            y = [y1 x(2) x(3)];
        case 'm'
            switch paratypeset
                case 'u'
                    y1 = [y1 0];
                    y = [y1 0];
                case {'eta', 'h'}
                    y = [x(3) x(2) x];
                otherwise
                    disp('wrong value of the typeset of parameter')
            end 
        case 'o'
            y = '1';
    end
end
