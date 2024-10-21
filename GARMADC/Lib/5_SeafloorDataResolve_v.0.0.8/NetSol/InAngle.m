function [T,Y,Z,L,theta,Iteration,RayInf] = InAngle(PF,TT,YY,HH)
%% IncidentAngle(PF,TT,YY,HH,tag)->incident angle inversion
%% To swtich the InAng2f
F0 = [TT,YY,HH];
V  = [inf,inf,inf];
if TT == +inf
    idx0 = 3;
    V(idx0) = HH;
    idx = 2; 
end

if YY == +inf 
    idx0 = 1; 
    V(idx0) = TT; 
    idx = 3; 
end

if HH == +inf
    idx0 = 2; 
    V(idx0) = YY; 
    idx = 1; 
end

Var.PF   = PF;
Var.V    = V;
Var.F0   = F0;
Var.idx  = idx;
Var.idx0 = idx0;

%% handle the optimization problem
InitialScale = InitialInAng(Var);

% if isfield(Control,'Tangent')  % ���߷�
Var.Initials  = [InitialScale(1),InitialScale(2)];
Var.TermIter  = 20;
Var.Terminate = 10^-4;
[T,Y,Z,L,theta,Iteration,RayInf] = TangentMethod(@InAng2f111,Var);
%    RayInf = [];
   
%  elseif isfield(Control,'WBisection')  % ���ַ�������Ϊ��Ȩ����
%     Var.Initials  = [InitialScale(1),InitialScale(2)];
%     Var.TermIter  = Par.TermIter; 
%     Var.delta     = Par.delta; 
%     [T,Y,Z,L,theta,Iteration] = WeightBisection(@InAng2f111,Var);  
%        
% elseif isfield(Control,'Interpolation')  % �������Ҷ˵����Ƶ�����ĸ���  
%     TransducerGrid        = RayGridExtend(Data.PF,abs(Data.EmissionPoint(3)));
%     TransponderExtendGrid = RayGridExtend(Data.PF,abs(Data.x0(3)));
%     ExtendLayer = TransponderExtendGrid(:,2:3) - TransducerGrid(:,2:3);   
% %     ExtendLayer = Data.TransponderExtendGrid(:,2:3) - TransducerGrid(:,2:3);   
%     Grid = [ExtendLayer(:,1),TransducerGrid(:,1)];  
%     WindowNum = Par.WindowNum;
%     Order     = Par.Order;
%     Terminate = Par.delta;  
%     [T,Y,Z,L,theta,Iteration,RayInf] = RefinedIncidentAngle(PF,YY,HH,Grid,WindowNum,Order,Terminate);
% 
% elseif isfield(Control,'Equation')
%     % ��ϸ�������
%     TransducerGrid = RayGridExtend(Data.PF,abs(Data.EmissionPoint(3)));
%     ExtendLayer = Data.TransponderExtendGrid(:,2:3) - TransducerGrid(:,2:3);
%     Grid = [TransducerGrid(:,1),ExtendLayer(:,1)];
%       
%     % ϵ����ϲ�������
%     WindowNum = Par.WindowNum;
%     Order     = Par.Order;
%     Terminate = Par.delta;
%     
%     % ���߷���������
%     Var.Initials  = [sin(InitialScale(1)),sin(InitialScale(2))];
%     Var.TermIter  = Par.TermIter;
%     Var.Terminate = Par.delta;
%     Var.Fun       = @Polynomial2f;
%     [T,Y,Z,L,theta,Iteration,RayInf] = FirstKind(PF,YY,HH,Grid,WindowNum,Order,Terminate,Var);  
% end
