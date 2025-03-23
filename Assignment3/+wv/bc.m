function  y = bc(x,typeset,paratypeset)
% This function is used to generating ghost cell for match the Boundary
% Condition, you can input a array and got enough data.

%%% x: is the array which is origin horizon space array; 
%%% typeset: the B.C. way:
%%% 'ND':'Neumann& Dirichlet; 'p':'periodic'; 'm','mirror'; 'o': 'open'  
    switch typeset
        case 'nd'
            y = [0 x(2:end-1) 0];
            % for example this is a form of dirichlet or Neumann, i set the
            % boundary be 0
        case 'p'
            y = [x(end-2) x(end-1) x x(2) x(3)];
        case 'm'
            switch paratypeset
                case 'u'
                    x = wv.bc(x,'nd');
                    y = [-x(3) -x(2) x -x(end-1) -x(end-2)];
                case {'eta', 'h'}
                    y = [x(3) x(2) x x(end-2) x(end-3)];
                otherwise
                    disp('wrong value of the typeset of parameter')
            end
        case 'o'
            % I haven't wirte it yet.
        otherwise
            disp('wrong value of the typeset of BC');
    end
end
