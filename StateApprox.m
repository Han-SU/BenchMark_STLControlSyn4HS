function [f_v]=StateApprox(var_name,f_list,pred1_list,pred2_list,deg,show)
    
    yalmip('clear');
    %fprintf('Alg started, yalmip has been cleaned');

%%% ==================== Transform the Model ==================== %%%
    % Define the sdp variable from the var_name inputted by python
    variable = [];
    for i = 1:length(var_name)
        %variable_list{i}
        eval([var_name{i} ' = sdpvar(1,1);']);
        variable = [variable,eval(var_name{i})];
        %class(variable(i))
    end
    
    % Define the vector field from f_list
    f = [];
    for i = 1:length(f_list)
        f = [f,eval(f_list{i})];
        %sdisplay(f(i))
    end
    
    % Define predicat 1 from pred1_list
    pred1 = [];
    for i = 1:length(pred1_list)
        pred1 = [pred1,eval(pred1_list{i})];
        %sdisplay(pred1(i))
    end

    % Define predicat 2 from pred1_list
    if iscell(pred2_list)
        pred2 = [];
        for i = 1:length(pred2_list)
            pred2 = [pred2,eval(pred2_list{i})];
            %sdisplay(pred2(i))
        end
    else
        pred2 = [];
        for i = 1:length(pred2_list(:,1))
            %sdisplay(cell2mat(pred)*monolist(variable,1))
            pred2 = [pred2;pred2_list(i,:)*monolist(variable,deg)];
        end
    end

 %%% ================================ Approximate the State-Time Set =========================================== %%% 
    f_v = [];
    for k = 1:length(pred2(:,1))
    
        l_pred1 = length(pred1);
        l_pred2 = length(pred2(k,:));
    
    
         % template of value function
         %sdisplay(variable)
         %sdisplay(deg)
         %fprintf('v:');
        [v,coe_v] = polynomial(variable,deg);
         %fprintf('w:');
        [w,coe_w] = polynomial(variable,deg);
        %sdisplay(coe_w)

        Lie_v = jacobian(v,variable)*f';
        Lie_w = jacobian(w,variable)*f';
    
        %obj = 3.14159265359*coe_v(1)+0.785398163397*coe_v(4)+0.785398163397*coe_v(6)+0.392699081699*coe_v(11)+0.1308996939*coe_v(13)+0.392699081699*coe_v(15)+0.245436926062*coe_v(22)+0.0490873852123*coe_v(24)+0.0490873852123*coe_v(26)+0.245436926062*coe_v(28)+0.171805848243*coe_v(37)+0.0245436926062*coe_v(39)+0.0147262155637*coe_v(41)+0.0245436926062*coe_v(43)+0.171805848243*coe_v(45)+0.128854386182*coe_v(56)+0.0143171540203*coe_v(58)+0.00613592315154*coe_v(60)+0.00613592315154*coe_v(62)+0.0143171540203*coe_v(64)+0.128854386182*coe_v(66);
        obj = [];
        deg1 = deg+1;
        F = [];
    
         % define the constrain
        s0 = sdpvar(1,l_pred1+l_pred2);
        coe0 = sdpvar(nchoosek(length(variable)+deg1,deg1),l_pred1+l_pred2);
        constr0 = -Lie_v;
        %sdisplay(Lie_v)
        for i = 1:l_pred1
             [s0(i),coe0(:,i)] = polynomial(variable,deg1);
             F = [F, sos(s0(i))]; 
             constr0 = constr0 + s0(i)*pred1(i);
        end
        for i = l_pred1+1:l_pred1+l_pred2
             [s0(i),coe0(:,i)] = polynomial(variable,deg1);
             F = [F, sos(s0(i))];
             constr0 = constr0 - s0(i)*pred2(k,i-l_pred1);
        end
         %sdisplay(constr0)
        F = [F, sos(constr0)];
        coe0 = reshape(coe0,[],1);
    
        s1 = sdpvar(1,l_pred1+l_pred2);
        coe1 = sdpvar(nchoosek(length(variable)+deg1,deg1),l_pred1+l_pred2);
        constr1 = v - Lie_w;
        for i = 1:l_pred1
            [s1(i),coe1(:,i)] = polynomial(variable,deg1);
            %sdisplay(s1(i))
            %coe1 = [coe1;coe];
            F = [F, sos(s1(i))]; 
            constr1 = constr1 + s1(i)*pred1(i);
        end
        for i = l_pred1+1:l_pred1+l_pred2
            [s1(i),coe1(:,i)] = polynomial(variable,deg1);
            %coe1 = [coe1;coe];
            F = [F, sos(s1(i))];
            constr1 = constr1 - s1(i)*pred2(k,i-l_pred1);
        end
        F = [F, sos(constr1)];
        coe1 = reshape(coe1,[],1);
    
        s2 = sdpvar(1,l_pred1);
        coe2 = sdpvar(nchoosek(length(variable)+deg1,deg1),l_pred1);
        constr2 = v;
        for i = 1:l_pred1
            [s2(i),coe2(:,i)] = polynomial(variable,deg1);
            %coe2 = [coe2;coe];
            constr2 = constr2 + s2(i)*pred1(i);
        end
        F = [F,sos(constr2)];
        coe2 = reshape(coe2,[],1);
        F = [F,coe_v>=-1000,coe_v<=1000,coe_w>=-1000,coe_w<=1000];
        
        ops = sdpsettings('solver','mosek','sos.newton',1,'sos.congruence',1,'verbose',show);
        diagnostics = solvesdp(F,obj,ops,[coe_v;coe_w;coe0;coe1;coe2]);
        V = monolist(variable,deg);
        %f_v = coe_v;
        %f_v = coe_v;
        %print(length(coe_v))
        f_v = [f_v;clean(double(coe_v'),1e-3)];
        if show == 1
            sdisplay(f_v(k,:)*V)
        end
    end
    %sdisplay(f_v)
end