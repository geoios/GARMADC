function [NeedComposeResults,Loop] = Stratefy_OddEven(Lambda,Data)
OBSData=Data.OBSData;INIData=Data.INIData;SVP=Data.SVP;MP=Data.MP;MPNum=Data.MPNum;knots=Data.knots;spdeg=Data.spdeg;deltap=Data.deltap;H=Data.H;
[OBSData_Odd,OBSData_Even,INIData_Segment] = SegmentData(OBSData,INIData,knots,MP,MPNum,spdeg,2);
%% 所有数据解算
[ALL,ModelP_MAXLoop] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,Lambda*H);
%% 奇数部分解算
% 提取观测初始时间和截止时间用于构造时变参数的节点
% 筛选调整观测数据个数
[Odd,ModelP_MAXLoop_Odd] = SVPCalModelT(OBSData_Odd,INIData_Segment,SVP,MP,MPNum,knots,spdeg,deltap,Lambda*H);
%% 偶数部分解算
% 提取观测初始时间和截止时间用于构造时变参数的节点
[Even,ModelP_MAXLoop_Even] = SVPCalModelT(OBSData_Even,INIData_Segment,SVP,MP,MPNum,knots,spdeg,deltap,Lambda*H);
% %% 确定最值
%% 数据处理将其归算至虚拟质心
[NeedComposeResults]=VCdistance(ALL,Odd,Even,MPNum,1);
Loop=[ModelP_MAXLoop,ModelP_MAXLoop_Odd,ModelP_MAXLoop_Even];
end