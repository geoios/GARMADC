function [travelTime,sin_sita,zeniAng_tan,ro] = getTravelTimePosi(souPosH,aimPosH,ssp,eleaAngle)
%% 函数说明
%功能：正问题计算传播时间
%输入：+souPos 源坐标
%      +aimPos 目标坐标
%      +ssp 截至声速剖面
%输出：+travlTime 传播时间
H = -aimPosH - (-souPosH);
PF = ssp;

WindowNum = 2;
Order     = 1;
PF = PFGrad(PF,WindowNum,Order);
theta = eleaAngle*pi/180;%高度角（不能为0）
T = inf;
Y = inf;
[sin_sita,travelTime,Y,Z] = RayTracing_delay(PF,theta,T,Y,H);
zeniAng_tan = Y/Z;%*180/pi;
ro = sqrt(Y^2 + Z^2);