function [T,Y,Z,L,theta,Iteration,RayInf] = P2PInvRayTrace(S,R,PF)
%% inputs:
% + S     %   控制点
% + R     %   待定点
% + PF    %   声速剖面

% % 解算策略控制
% [Control,Par] = RayTracing_ControlSystem();

% 控制点、待定点处理
[S,R] = PreProcessingPoints(S,R);

% for sound ray tracing
Horizontal = norm(S(1:2) - R(1:2));
Depth      = R(3) - S(3);

% In most cases, the tracing is not started from the sea surface
if S(3) > 0
    PF = SplitPF(PF,S(3),PF(end,1));
end

[T,Y,Z,L,theta,Iteration,RayInf] = InvRayTrace(PF,+inf,Horizontal,Depth);

SVPLayerNum = size(PF,1);
gammar1 = 0;gammar2 = 0;
for i = 1: SVPLayerNum -1
    C0 = PF(i,2);C1 = PF(i+1,2);G = PF(i,4);U0 = PF(i,1);U1 = PF(i+1,1);
    if G ==0
        SubGamma1 = (U1 - U0)/C0^2;
        SubGamma2 = (U1^2 - U0^2)/(2 * C0^2);
    else
        SubGamma1 = (U1 - U0)/(C0 * C1);
        SubGamma2 = G^-2 * log(C1/C0) - (C0/G - U0) * (U1 - U0) * (C0 * C1)^-1;
    end
    gammar1  = gammar1 + SubGamma1;
    gammar2  = gammar2 + SubGamma2;
end
RayInf.gammar1 = gammar1;RayInf.gammar2 = gammar2;


%% 获取lambda值
snellC = RayInf.alfae/RayInf.ce;
cos_betaList = cos(asin(snellC .* PF(:,2)));
RayInf.cos_AvgBeta = sum(cos_betaList.*PF(:,3))/sum(PF(:,3));

end

%% 3D recovery
% Z  = Z  + S(3);
% zz = zz + S(3);
% XX = ei(1) * Horizontal;
% YY = ei(2) * Horizontal;