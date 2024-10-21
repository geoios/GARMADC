function [sin_sita,zeniAng_tan] = getSinAngTraveTime_prod(ssp,iAng)
%% 函数说明
%功能：声线跟踪计算给定入射角的传播时间
%% 功能代码
souPosH = -ssp(1,1);
aimPosH = -ssp(end,1);

if(iAng == 0)
    sin_sita = zeros(size(ssp,1),1);
    zeniAng_tan = 0;
% 	error('入射角不能为0，超出函数设计逻辑！');
% 	[travelTime] = harmonic1(ssp(:,1),ssp(:,2),-aimPosH);
else
    [travelTime,sin_sita,zeniAng_tan,ro] = getTravelTimePosi(souPosH,aimPosH,ssp,iAng);
end
