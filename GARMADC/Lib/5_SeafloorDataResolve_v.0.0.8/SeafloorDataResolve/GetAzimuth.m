function [azimuth] = GetAzimuth(point1, point2)

P_local = [point2(1)-point1(1) point2(2)-point1(2)];

P_local(1);  % 水平方向
P_local(2);  % 竖直方向

if (P_local(1) >= 0)  % 第一、四象限、y轴以右部分
    azimuth = atan2(P_local(1),P_local(2));
    return;
end
if (P_local(1) < 0)   % 第二、三象限
    azimuth = 2*pi + atan2(P_local(1),P_local(2));
    return;
end
end