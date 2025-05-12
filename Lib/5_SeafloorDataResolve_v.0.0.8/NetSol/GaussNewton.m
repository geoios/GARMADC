function x = GaussNewton(y,P,x,fun,Par)
RobPar = Par.RobPar;
Lmd    = Par.Lmd;
Stp    = Par.Stp;
Lop    = 0;
flag   = 0;
while(1)
[f A] = fun(x);
dy    = y - f;

[dx,sigma,L_est,v,P,Qx] = RobLS(A,dy,P,RobPar);
x.x0  = x.x0 + Lmd * dx;
%% ����������������
if norm(dx) < Stp
    flag = 1;
end
%% ����Ԥ�ڵ�������
Lop = Lop + 1;
if Lop > Par.Lop
    flag = 1;
end
%% ����ָ���ض�����
if Par.StopFun(x.x0)
    flag = 1;
end

if flag
    x.v = dy;
    x.P = P;
    x.f = f;
    break
end
end