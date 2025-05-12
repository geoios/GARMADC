close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;


%% 数据格式转化
%----------------观测文件绝对路径-----------------
OBSFilePath = 'D:\GitHub\Dev\Apps\SeafloorDataResolve\sample\BigSmallMi\Data.SimulationData1-obs.csv';
%----------------声速剖面绝对路径-----------------
SVPFilePath = 'D:\GitHub\Dev\Apps\SeafloorDataResolve\sample\BigSmallMi\Data.SimulationData1-svp.csv';
%----------------配置参数设置文件-----------------
INIFilePath = 'D:\GitHub\Dev\Apps\SeafloorDataResolve\sample\BigSmallMi\Data.SimulationData1-initcfg.ini';
[OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);

%% 数据解算
% 基本参数确定
spdeg=3;MPNum=[12,24];deltap=[10^-4;10^-6];InitialLambda=10;
%  1.臂长转化
[OBSData,INIData,SVP,MP,T0,scale,V0] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
%  2.B样条节点构造
[knots]=Make_Bspline_knots(OBSData,SVP,spdeg,MPNum);%
%  3.平滑参数的平滑项构建构建
[H2,H1,H3]=BS_base_2_derivative(MPNum,spdeg,knots,2);
%  5.拟合声速场循环迭代计算
% 以历元的方式构建雅可比矩阵
Lambda = [0,10^-2,10^-1,0.3,1,10,100,500,1000,10000];
for DataNum=1:length(Lambda)
    [ModelT_MP_SVP(DataNum,:),ModelT_MAXLoop1(DataNum,:),ModelT_MP_SVP_OBSData(DataNum)] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,Lambda(DataNum)*H3); % H1 
end