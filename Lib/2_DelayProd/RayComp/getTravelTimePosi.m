function [travelTime,sin_sita,zeniAng_tan,ro] = getTravelTimePosi(souPosH,aimPosH,ssp,eleaAngle)
%% ����˵��
%���ܣ���������㴫��ʱ��
%���룺+souPos Դ����
%      +aimPos Ŀ������
%      +ssp ������������
%�����+travlTime ����ʱ��
H = -aimPosH - (-souPosH);
PF = ssp;

WindowNum = 2;
Order     = 1;
PF = PFGrad(PF,WindowNum,Order);
theta = eleaAngle*pi/180;%�߶Ƚǣ�����Ϊ0��
T = inf;
Y = inf;
[sin_sita,travelTime,Y,Z] = RayTracing_delay(PF,theta,T,Y,H);
zeniAng_tan = Y/Z;%*180/pi;
ro = sqrt(Y^2 + Z^2);