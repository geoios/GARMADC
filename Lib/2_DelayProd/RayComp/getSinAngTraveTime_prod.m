function [sin_sita,zeniAng_tan] = getSinAngTraveTime_prod(ssp,iAng)
%% ����˵��
%���ܣ����߸��ټ����������ǵĴ���ʱ��
%% ���ܴ���
souPosH = -ssp(1,1);
aimPosH = -ssp(end,1);

if(iAng == 0)
    sin_sita = zeros(size(ssp,1),1);
    zeniAng_tan = 0;
% 	error('����ǲ���Ϊ0��������������߼���');
% 	[travelTime] = harmonic1(ssp(:,1),ssp(:,2),-aimPosH);
else
    [travelTime,sin_sita,zeniAng_tan,ro] = getTravelTimePosi(souPosH,aimPosH,ssp,iAng);
end
