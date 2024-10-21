function [NeedComposeResults,Loop] = Stratefy_FormerLatter(Lambda,Data)
OBSData=Data.OBSData;INIData=Data.INIData;SVP=Data.SVP;MP=Data.MP;MPNum=Data.MPNum;knots=Data.knots;spdeg=Data.spdeg;deltap=Data.deltap;H=Data.H;T0=Data.T0;scale=Data.scale;
%% 第二种解算策略 数据前后部分寻找最优超参数
[OBSData_Former,OBSData_Latter,INIData_Segment,knots_Former,knots_Latter,MP_Former,MP_Latter,MPNum_Segment] = SegmentData(OBSData,INIData,knots,MP,MPNum,spdeg,1);
[H_Former2,H_Former1]=BS_base_2_derivative(MPNum_Segment,spdeg,knots_Former);
[H_Latter2,H_Latter1]=BS_base_2_derivative(MPNum_Segment,spdeg,knots_Latter);
%% 所有数据解算
[ALL,ModelP_MAXLoop] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,Lambda*H);
%% 前半部分解算
% 提取观测初始时间和截止时间用于构造时变参数的节点
% 筛选调整观测数据个数
[Former,ModelP_MAXLoop_Former] = SVPCalModelT(OBSData_Former,INIData_Segment,SVP,MP_Former,MPNum_Segment,knots_Former,spdeg,deltap,Lambda*H_Former2);
%% 后半部分解算
% 提取观测初始时间和截止时间用于构造时变参数的节点
[Latter,ModelP_MAXLoop_Latter] = SVPCalModelT(OBSData_Latter,INIData_Segment,SVP,MP_Latter,MPNum_Segment,knots_Latter,spdeg,deltap,Lambda*H_Latter2);
% %% 确定最值
%% 数据处理将其归算至虚拟质心
[NeedComposeResults]=VCdistance(ALL,Former,Latter,MPNum,1);
Loop=[ModelP_MAXLoop,ModelP_MAXLoop_Former,ModelP_MAXLoop_Latter];
end

