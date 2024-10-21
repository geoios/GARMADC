function [centerCoor_xiao,otherCoor_xiao,arrayOffset_xiao] = readXiaoInfo(xiaoResu,seaFloorStatNum)
%% 函数说明
%功能：读取肖圳师兄程序结果
%输入：+xiaoResu 师兄程序结果
%      +seaFloorStatNum 海底站数目
%输出：+centerCoor_xiao 中心点坐标
%      +otherCoor_xiao 其余点坐标

%% 功能代码
ePos = 1:3:3*seaFloorStatNum;
nPos = 2:3:3*seaFloorStatNum;
uPos = 3:3:3*seaFloorStatNum;
e = xiaoResu(1,ePos);
n = xiaoResu(1,nPos);
u = xiaoResu(1,uPos);
%中心点坐标
centerCoor_xiao = [mean(e,2) mean(n,2) mean(u,2)];
%其余点坐标(转ENU)
otherCoor_xiao = [e' n' u'];
%阵列偏移量
arrayOffset_xiao = xiaoResu(1,3*seaFloorStatNum+1:3*seaFloorStatNum+3);
