function [newData] = lsFun(data,aimH,window,statsInfo)
%% 函数说明
%功能：最小二乘延拓
%% 功能代码
%最小二乘区域
lsData = data(end-window+1:end,:);%最小二乘外推区域范围
lsData = [lsData;statsInfo];
P = eye(window+1);%blkdiag(1./1^2*eye(window),1./StatsInfo.Vb(2)^2);%%

B = [ones(size(lsData,1),1) lsData(:,1)];%构建最小二乘X矩阵
coff = inv(B'*P*B)*B'*P*lsData(:,2);
aimY = coff(1) + coff(2)*aimH;
newData = [aimH aimY];

