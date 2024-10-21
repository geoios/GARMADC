function [centerCoor_xiao,otherCoor_xiao,arrayOffset_xiao] = readXiaoInfo(xiaoResu,seaFloorStatNum)
%% ����˵��
%���ܣ���ȡФ��ʦ�ֳ�����
%���룺+xiaoResu ʦ�ֳ�����
%      +seaFloorStatNum ����վ��Ŀ
%�����+centerCoor_xiao ���ĵ�����
%      +otherCoor_xiao ���������

%% ���ܴ���
ePos = 1:3:3*seaFloorStatNum;
nPos = 2:3:3*seaFloorStatNum;
uPos = 3:3:3*seaFloorStatNum;
e = xiaoResu(1,ePos);
n = xiaoResu(1,nPos);
u = xiaoResu(1,uPos);
%���ĵ�����
centerCoor_xiao = [mean(e,2) mean(n,2) mean(u,2)];
%���������(תENU)
otherCoor_xiao = [e' n' u'];
%����ƫ����
arrayOffset_xiao = xiaoResu(1,3*seaFloorStatNum+1:3*seaFloorStatNum+3);
