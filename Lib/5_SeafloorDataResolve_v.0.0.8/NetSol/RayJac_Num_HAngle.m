function [ei,t,gammar,alfae,cos_AvgBeta] = RayJac_Num_HAngle(KnownPoint,UnknownPoint,PF)
% KnownPoint   ������
% UnknownPoint ���Ƶ�
[t,Y,Z,L,theta,Iteration,RayInf] = P2PInvRayTrace(KnownPoint,UnknownPoint,PF);
LastLayerAngel = asin(RayInf.alfae);alfa = atan(abs(UnknownPoint(3)-KnownPoint(3))/norm(KnownPoint(1:2)-UnknownPoint(1:2)));
% LastVelocity   = RayInf.ce;
cos_beta      = (KnownPoint(1) - UnknownPoint(1))/Y;
sin_beta      = (KnownPoint(2) - UnknownPoint(2))/Y;
cos_alfa      = cos(alfa);
sin_alfa      = sin(alfa);

ei(1) = sin_alfa * cos_beta;
ei(2) = sin_alfa * sin_beta;
ei(3) = cos_alfa;

gammar = [RayInf.gammar1,RayInf.gammar2];

alfae = RayInf.alfae;
cos_AvgBeta = RayInf.cos_AvgBeta;
end