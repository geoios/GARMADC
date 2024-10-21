close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;
for DataNum=1:1
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
    spdeg=3;MPNum=[12,24,36,48];deltap=[10^-4;10^-6];InitialLambda=10;
    %  1.臂长转化
    [OBSData,INIData,SVP,MP] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
    %  2.B样条节点构造
    [knots]=Make_Bspline_knots(OBSData,spdeg,MPNum);%
    %  3.平滑参数的平滑项构建构建
    [H2,H1,H3]=BS_base_2_derivative(MPNum,spdeg,knots);
    %以站点的方式构建雅可比矩阵
    %       [ModelP_MP_SVP(DataNum,:),ModelP_MAXLoop1(DataNum,:),ModelP_MP_SVP_OBSData(DataNum)] = SVPCalModelP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,0*H);
    % 以历元的方式构建雅可比矩阵
    [ModelT_MP_SVP(DataNum,:),ModelT_MAXLoop1(DataNum,:),ModelT_MP_SVP_OBSData(DataNum)] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,0*H2);
end