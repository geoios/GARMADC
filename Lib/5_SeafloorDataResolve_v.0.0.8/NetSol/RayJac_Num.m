function [ei,t,gammar,alfae,cos_AvgBeta] = RayJac_Num(KnownPoint,UnknownPoint,PF)
% KnownPoint   ������
% UnknownPoint ���Ƶ�
[t,Y,Z,L,theta,Iteration,RayInf] = P2PInvRayTrace(KnownPoint,UnknownPoint,PF);
LastLayerAngel = asin(RayInf.alfae);
% LastVelocity   = RayInf.ce;
cos_beta      = (KnownPoint(1) - UnknownPoint(1))/Y;
sin_beta      = (KnownPoint(2) - UnknownPoint(2))/Y;
cos_alfa      = cos(LastLayerAngel);
sin_alfa      = sin(LastLayerAngel);

ei(1) = sin_alfa * cos_beta;
ei(2) = sin_alfa * sin_beta;
ei(3) = cos_alfa;

gammar = [RayInf.gammar1,RayInf.gammar2];

alfae = RayInf.alfae;
cos_AvgBeta = RayInf.cos_AvgBeta;
end