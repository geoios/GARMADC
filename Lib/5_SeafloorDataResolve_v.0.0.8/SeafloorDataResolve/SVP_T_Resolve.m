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
    
    [OBSData,SVP,INIData,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    
    %% 数据解算
    % 基本参数确定
    spdeg=3;deltap=10^-4;BSpan = 30*ones(3*1,1); INIData.SVPSeg =[100,200,300,500,800,1100]; 
    % 1.B样条节点构造
    [knots,MPNum]=Make_Bspline_knots(OBSData,spdeg,BSpan);%
    % 2.臂长转化
    [OBSData,INIData,MP,MPNum,T0,scale,V0] = Ant_ATD_Transducer(OBSData,INIData,SVP,MP1,MPNum,spdeg);
    % 3. 解算
    [ModelT_MP_SVP,ModelT_MAXLoop1,ModelT_MP_SVP_OBSData] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,0);
end

