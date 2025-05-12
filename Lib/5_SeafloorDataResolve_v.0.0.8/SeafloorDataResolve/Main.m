close all; clear; clc;close("all");
%% 获取当前脚本的位�?
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位�?
cd(FilePath);
clear FilePath;
%% 路径调整及文件读�?
% 指定数据�?在目�?
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = 'E:\ResearchTopic\2023��_ESSP�����Ż�\Data_import\Jpn\data_Tohoku2011-2020';
PosNameList = {'1103','1104','1105','1108','1111','1201','1204','1209','1211','1212','1302','1306',...
    '1309','1311','1401','1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; % 后续更改自�?�应

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


%% 解算策略及定位结�?
% 测船解算策略
% �?1.单点定位模型（含gammar,积分固定）[3,1,5,6,0,1];（含gammar,积分不固定）[3,1,2,2,1,0,1]（不含gammar）[3,1,1,1,0,1],BSpan�?3个）�?
% �?1.单点定位模型（局部三参数）[7,1,3,8,0,0],BSpan�?3*海底点个数）�?
% �?2.单层定位模型（含gammar）[3,1,5,5,0,1]；BSpan�?3个）�?
% �?3.网解：五公共参数 （不含lambda）[3,1,1,1,1,1];（含lambda）[3,1,6,7,7,1],BSpan�?5个）�?
% �?3.网解：裂变三参数为五参数（含gammar,积分不固定）[3,1,2,9,9,1],BSpan�?5个）�?
% �?4.网解：四公共�?�?�?(时间) [ 8,1,3,3,3,1]；BSpan（海底点个数 + 4个）�?
% �?5.网解：三公共二局�?(测船-原点) [3,1,1,1,2,1]；BSpan�?2*海底点个�? + 3个）�?
% �?6.网解：三公共二局�?(测船-应答�?) [3,1,1,4,3,1]；BSpan�?2*海底点个�? + 3个）�?
% �?7.网解：五公共�?�?�?(时间) [3,1,7,3,3,1]；BSpan（海底点个数 + 5个）�?
% Model(1):观测截断点处理方�? 1.删除�?2.历元间随机游走约�? 3.节点中点随机游走约束
% Model(2):平滑约束因子
% Model(3):B样条时变模型
% Model(4):B样条测船-应答器水平梯度模�?
% Model(5):B样条测船-原点水平梯度模型
% Model(6):是否成cos^-1(Z)
Model = [1,0,1,1,1,1];

BList=[35]; % 分段大致间隔
MuList = [0];
for MuListNum =1:length(MuList)
    Mu = MuList(MuListNum);
    for BListNum = 1:length(BList)
        BNUM = BList(BListNum);
        for DataNum = 2 %:FileStruct.FileNum
            % 数据格式转化
            %----------------观测文件绝对路径-----------------
            OBSFilePath = FileStruct.SubFileList{1,DataNum};
            %----------------声�?�剖面绝对路�?-----------------
            SVPFilePath = FileStruct.SubFileList{2,DataNum};
            %----------------配置参数设置文件-----------------
            INIFilePath = FileStruct.SubFileList{3,DataNum};
            
            [OBSData,SVP,INIData,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
            INIData.Data_file.N_shot = num2str(length(OBSData.ant_e0));load('svpInfo.mat');
            INIData.svpInfo = svpInfo;
            % 数据解算B样条参数区间设置及个数设�?
            INIData.BSpan =[BNUM,BNUM,BNUM,BNUM,BNUM]; % *ones(1,length(MP1)/3)
            %基本参数确定
            INIData.JcbMoodel = Model(1);INIData.Mu = Mu;INIData.TModel = Model(3);INIData.Mu3 = 100000;
            INIData.Ray_ENModel=Model(4);INIData.Vessel_ENModel=Model(5);INIData.cosZ = Model(6);
            spdeg=3;
            %1.B样条节点构�??
            [knots,MPNum]=Make_Bspline_knots(OBSData,spdeg,INIData.BSpan);%
            %2.臂长转化
            [OBSData,INIData,MP,MPNum] = Ant_ATD_Transducer(OBSData,INIData,SVP,MP1,MPNum,spdeg);
            %3. 解算
            [ModelT_MP_T,ModelT_MAXLoop2,ModelT_MP_T_OBSData] = TCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,0);
        end
    end
end