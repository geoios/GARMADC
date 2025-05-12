close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;
%% 
% 指定数据所在目录
Wildcard = '\*';
StnName  = 'SAGA';
StnPath  = 'D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample';

% 观测文件目录
ObsPath  = [StnPath,'\obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 配置文件目录
ConfPath = [StnPath,'\initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

for DataNum = 1  % FileStruct.FileNum
    %% 数据格式转化
    %----------------观测文件绝对路径-----------------
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    %----------------声速剖面绝对路径-----------------
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    %----------------配置参数设置文件-----------------
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    
    %% 数据解算
    % 基本参数确定
    spdeg=3;MPNum=[12,23,34,45,50];deltap=[10^-4;10^-6];InitialLambda=10;
    %  1.臂长转化    
    [OBSData,INIData,SVP,MP,T0,scale,V0] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
    %  2.B样条节点构造
    [knots]=Make_Bspline_knots(OBSData,SVP,spdeg,MPNum);%
    %  3.平滑参数的平滑项构建构建
    [H2,H1,H3]=BS_base_2_derivative(MPNum,spdeg,knots,2);
    %  4.无策略解算
    % 以历元的方式构建雅可比矩阵
%     [ModelT_MP(DataNum,:),MAXLoop2(DataNum,:),ModelT_MP_OBSData(DataNum)] = CalModelT(OBSData,INIData,SVP,MP(1:MPNum(1)),deltap(1));
    %  5.拟合声速场循环迭代计算
    % 以历元的方式构建雅可比矩阵
    [ModelT_MP_SVP(DataNum,:),ModelT_MAXLoop1(DataNum,:),ModelT_MP_SVP_OBSData(DataNum)] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,0);
    %  6.拟合观测时间迭代循环计算
    %以历元顺序的方式构建雅可比矩阵
%     [ModelT_MP_T(DataNum,:),ModelT_MAXLoop2(DataNum,:),ModelT_MP_T_OBSData(DataNum)] = TCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,0,T0,scale,V0); 
    %  7.寻找最佳超参数（在这里我们使用 Hooke_Jeeves算法确定最佳值）
%      [OptimumLambda]=Hooke_Jeeves_FindLambda(InitialLambda,OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H1);
    %  [OptimumLambda]=PSO_FindLambda(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H2);
end
% save(['Results\ModelT_T_SVP_Parameter50_10-4_space_time_hight_SingleBspline_VirObs_4_10^-8-SAGA_1903.mat']);



