close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);

%% 日本结果文件路径获取
JapSolFilePath = 'D:\GARPOS(用于GNSS声学海底定位的分析工具)\data_Tohoku2011-2020';
StnName  = 'MYGI';
PosNameList = {'1103','1104','1105','1108','1111','1201','1204','1209','1211','1212','1302','1306',...
    '1309','1311','1401','1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; % 后续更改自适应

Wildcard = '\*';
SvpTag  = '-svp.csv';
IndexTag = [Wildcard,SvpTag];
SVPPath  = [JapSolFilePath,'\obsdata\',StnName];
JapSolFileStruct = FileExtract(SVPPath,IndexTag);
JapSolTag  = '-res.dat';
JapSolPath = [JapSolFilePath,'\single-default\',StnName];
JapSolFileStruct = nTypeFileLink(JapSolFileStruct,SvpTag,JapSolPath,JapSolTag);
%% 当前解算结果文件路径获取
SuffixTag   = '.mat';
ResultsPath =[FilePath,'\Results'];
IndexTag = [Wildcard,SuffixTag];
ResultsFileStruct = FileExtract(ResultsPath,IndexTag);
%% 残差图绘制
BSpan = 30;                                             % B样条时间间隔
PosNum = 1;                                             % 测站序号
% 线条设计
FigSet_dL.LineType = 'b-';                                 % 线条
FigSet_dL.lineWidth = 1;                                   % 线宽
% 图例
FigSet_dL.legendName = {'\fontname{宋体}距离残差'};
FigSet_dL.Location = 'NorthEast';
% 标题设定
FigSet_dL.TitleName=[StnName,'.',PosNameList{PosNum},' 距离残差序列'];   
% 坐标轴设定
FigSet_dL.linewidth = 0.75;                                 % 坐标轴线宽
FigSet_dL.xlabelName = ['\fontname{宋体}{\it观测历元(个)}'];
FigSet_dL.ylabelName = ['\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}'];
% 图幅整体设计
FigSet_dL.FontSize = 18;                                   % 指定figure的字号
FigSet_dL.Size=[0,0,20,15];                                % 指定figure的尺寸
FigSet_dL.PaperPosition=[0,0,20,10];                       % 设定图窗大小和位置
% 保存路径
StorgeStyle = '.png';                                   % 保存格式
FigSet_dL.StorgePath = [ResultsPath,'\',...                % 保存地址（该地址为'.\Results\'）
    StnName,PosNameList{PosNum},'_',num2str(BSpan),StorgeStyle];

% 残差绘制
figure;
[STD] = dLPlot(ModelT_MP_T_OBSData,SVP,FigSet_dL);% 

%% 基准时序绘制
% 基准点数据加载
load('Center_standra.mat');

BSpan = 30;                                             % B样条时间间隔
PosNum = 1;                                             % 测站序号
% 线条设计
FigSet.LineType = 'b-';                                 % 线条
FigSet.lineWidth = 1;                                   % 线宽
% 图例
FigSet.legendName = {'\fontname{宋体}日本软件解算结果','\fontname{宋体}自主软件解算结果'};
FigSet.Location = 'NorthEast';
% 标题设定
FigSet.TitleName=[StnName,'.',PosNameList{PosNum},' 距离残差序列'];   
% 坐标轴设定
FigSet.linewidth = 0.75;                                 % 坐标轴线宽
FigSet.xlabelName = ['\fontname{宋体}观测时间\fontname{Times New Roman}(year)'];
FigSet.ylabelName = ['\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}'];
% 图幅整体设计
FigSet.FontSize = 18;                                   % 指定figure的字号
FigSet.Size=[0,0,20,15];                                % 指定figure的尺寸
FigSet.PaperPosition=[0,0,20,10];                       % 设定图窗大小和位置
% 保存路径
StorgeStyle = '.png';                                   % 保存格式
FigSet.StorgePath = [ResultsPath,'\',...                % 保存地址（该地址为'.\Results\'）
    StnName,PosNameList{PosNum},'_',num2str(BSpan),StorgeStyle];
figure;



load('E:\研究题目\Dev-main-XZ\Apps\SeafloorDataResolve_v.0.0.2\画时间序列\Center_standra.mat');
timeSeries = (centerEnuCoor - Center_standra)*100;
timeSeries_xiao = (centerEnuCoor_xiao - Center_standra)*100;
subplot(3,1,1)
plotPositDiff([iniInfo.xAxisCoor timeSeries(:,1)],lineType);hold on;
plotPositDiff([iniInfo.xAxisCoor timeSeries_xiao(:,1)],'r^-');
legend('\fontname{宋体}日本解与基准中心点差(E)','\fontname{宋体}我们解与基准中心点差(E)','Location','NorthEast','Box','off');%'Orientation','horizon',
subplot(3,1,2)
plotPositDiff([iniInfo.xAxisCoor timeSeries(:,2)],lineType);hold on;
plotPositDiff([iniInfo.xAxisCoor timeSeries_xiao(:,2)],'r^-');
legend('\fontname{宋体}日本解与基准中心点差(N)','\fontname{宋体}我们解与基准中心点差(N)','Location','NorthEast','Box','off');%'Orientation','horizon',
subplot(3,1,3)
plotPositDiff([iniInfo.xAxisCoor timeSeries(:,3)],lineType);hold on;
plotPositDiff([iniInfo.xAxisCoor timeSeries_xiao(:,3)],'r^-');
legend('\fontname{宋体}日本解与基准中心点差(U)','\fontname{宋体}我们解与基准中心点差(U)','Location','NorthEast','Box','off');%'Orientation','horizon',
set(gcf,'Units','centimeter','Position',[5 5 20 25]);
eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,'时间序列比较','.png'')']);








%% 对比结果




