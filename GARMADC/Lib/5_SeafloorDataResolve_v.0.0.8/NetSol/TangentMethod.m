function [T,Y,Z,L,theta,Iteration,RayInf] = TangentMethod(F,Var)
%%
%% Remarks:
% + slove the equation F(x) = 0;
% + For the deviation of F is hard to be analytically given
if length(Var.Initials) == 2
    x(1) = Var.Initials(1);
    x(2) = Var.Initials(2);
else
    %[ToDo: initial value guess]
end

for j = 1:Var.TermIter
    Var.x = x(j);
    [~,~,~,~,f_p1] = F(Var);
    Var.x = x(j+1);
    [~,~,~,~,f_p2] = F(Var);

    %%
    dx = x(j+1) - x(j);
%     if dx <=  10^-15
%         [T,Y,Z,L,~,RayInf]  = F(Var);
%         break
%     end
    k  = f_p2/(f_p2-f_p1);
    x(j+2) = x(j+1) - k * dx;          %% ����sin����

    Var.x = x(j+2);
    [T,Y,Z,L,f_p3,RayInf]  = F(Var);

    if abs(f_p3) <=  Var.Terminate
        break
    end
end
Iteration = j;
theta = Var.x;
