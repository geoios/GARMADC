close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;
for DataNum=2
    %% 数据格式转化
    %----------------观测文件绝对路径-----------------
    OBSFilePath=['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\TwoSquareMi\SimulationData',num2str(DataNum),'\Data.SimulationData',num2str(DataNum),'-obs.csv'];
    %----------------声速剖面绝对路径-----------------
    SVPFilePath=['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\TwoSquareMi\SimulationData',num2str(DataNum),'\Data.SimulationData',num2str(DataNum),'-svp.csv'];
    %----------------配置参数设置文件-----------------
    INIFilePath=['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\TwoSquareMi\SimulationData',num2str(DataNum),'\Data.SimulationData',num2str(DataNum),'-initcfg.ini'];
    [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    
    %% 数据解算
    % 基本参数确定
    spdeg=3;MPNum=[12,27];deltap=[10^-4;10^-6];InitialLambda=10;Lambda=[1500,2000,2500,3000,5000];% Lambda=[];% Lambda=[0,0.5,1,5,10,15,20,25,30,35,40,45,50];
    %  1.臂长转化
    [OBSData,SVP,MP] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
    %  2.B样条节点构造
    [knots]=Make_Bspline_knots(OBSData,spdeg,MPNum);%
    %  3.平滑参数的平滑项构建构建
    [H2,H1,H3]=BS_base_2_derivative(MPNum,spdeg,knots);
    %  4.拟合声速场循环迭代计算
    % 以历元的方式构建雅可比矩阵
%     for i=1:length(Lambda)
%         [ModelT_MP_SVP(i,:),ModelT_MAXLoop1(i,:)] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,Lambda(i)*H2);% ,ModelT_MP_SVP_OBSData(DataNum)
%     end
%     %  5.拟合观测时间迭代循环计算
%     %以历元顺序的方式构建雅可比矩阵
%     for i=1:length(Lambda)
%         [ModelT_MP_T(i,:),ModelT_MAXLoop2(i,:)] = TCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,Lambda(i)*H2); % ,ModelT_MP_T_OBSData(DataNum)
%     end
    %  6.寻找最佳超参数（在这里我们使用 Hooke_Jeeves算法确定最佳值）
    [OptimumLambda]=Hooke_Jeeves_FindLambda(InitialLambda,OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H3);
end
% save(['Results\ModelT_MP_T_Parameter36_3000_3000_45_300_10-3_BigSmallMi_Single.mat'],'ModelT_MP_T','ModelT_MAXLoop2','ModelT_MP_T_OBSData');