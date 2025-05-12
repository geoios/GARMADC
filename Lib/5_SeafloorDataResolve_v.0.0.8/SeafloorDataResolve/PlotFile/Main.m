% close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);

%% 日本结果文件路径获取
StnName  = 'MYGI';
PosNameList = {'1103','1104','1105','1108','1111','1201','1204','1209','1211','1212','1302','1306',...
    '1309','1311','1401','1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; % 后续更改自适应
ResultsPath =[FilePath,'\Results'];
%% 残差图绘制
BSpan = 50;                                             % B样条时间间隔
PosNum = 12;                                             % 测站序号
% 线条设计
FigSet_dL.LineType = 'b-';                                 % 线条
FigSet_dL.lineWidth = 1;                                   % 线宽
% 图例
FigSet_dL.legendName = {'\fontname{宋体}距离残差'};
FigSet_dL.Location = 'NorthEast';
% 标题设定
FigSet_dL.TitleName=[StnName,'.',PosNameList{PosNum},];   
% 坐标轴设定
FigSet_dL.linewidth = 0.75;                                 % 坐标轴线宽
FigSet_dL.xlabelName = ['\fontname{宋体}{\it观测历元(个)}'];
FigSet_dL.ylabelName = ['\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}'];
% 图幅整体设计
FigSet_dL.FontSize = 18;                                   % 指定figure的字号
FigSet_dL.Size=[0,0,20,15];                                % 指定figure的尺寸
FigSet_dL.PaperPosition=[0,0,20,10];                       % 设定图窗大小和位置
% 保存路径
StorgeStyle = '.png';                                      % 保存格式
FigSet_dL.StorgePath = [ResultsPath,'\',...                % 保存地址（该地址为'.\Results\'）
    StnName,PosNameList{PosNum},'_',num2str(BSpan),StorgeStyle];

% 计算
X = 1:length(ModelT_MP_T_OBSData.detalT);
index = find(strcmp(ModelT_MP_T_OBSData.flag,'True'));
V0 = MeanVel(SVP);
X(index)=[];ModelT_MP_T_OBSData.detalT(index)=[];
Y = ModelT_MP_T_OBSData.detalT*V0;
% 残差计算
ValueRMS = rms(Y);
ValueRRS = Y'*Y;
% RobLS 后续更改
sigma = std(Y);


% 残差绘制
figure;
ResidualPlot(X,Y,sigma,FigSet_dL)                          % X:X轴数据;Y轴数据，sigma：残差sigma，FigSet_dL绘图设置
% 图片保存
% print(gcf,FigSet_dL.StorgePath,'-r600','-dtiff');
%% 基准时序绘制
% 基准点数据加载

% % 线条设计
% FigSet.LineType = 'b-';                                 % 线条
% FigSet.lineWidth = 1;                                   % 线宽
% % 图例
% FigSet.legendName = {'\fontname{宋体}日本软件解算结果','\fontname{宋体}自主软件解算结果'};
% FigSet.Location = 'NorthEast';
% % 标题设定
% FigSet.TitleName=[StnName,'.',PosNameList{PosNum},' 时间序列比较'];   
% % 坐标轴设定
% FigSet.linewidth = 0.75;                                 % 坐标轴线宽
% FigSet.xlabelName = ['\fontname{宋体}{\it观测历元(个)}'];
% FigSet.ylabelName = ['\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}'];
% % 图幅整体设计
% FigSet.FontSize = 18;                                   % 指定figure的字号
% FigSet.Size=[0,0,20,15];                                % 指定figure的尺寸
% FigSet.PaperPosition=[0,0,20,10];                       % 设定图窗大小和位置
% % 保存路径
% StorgeStyle = '.png';                                   % 保存格式
% FigSet.StorgePath = [ResultsPath,'\',...                % 保存地址（该地址为'.\Results\'）
%     StnName,'时间序列比较',StorgeStyle];
% 
% figure;
% subplot(3,1,1)
% FigSet.LineType = 'b^-';                                 % 线条
% FigSet.ylabelName = ['\fontname{Times new roman}{\itE}\fontname{宋体}{\it方向}\fontname{Times new roman}{\it(m)}'];
% X = ; Y = ;
% dPList_Plot(X,Y,FigSet);hold on
% FigSet.LineType = 'r^-';   
% X = ; Y = ;
% dPList_Plot(X,Y,FigSet);
% 
% subplot(3,1,2)
% FigSet.LineType = 'b^-';  
% FigSet.ylabelName = ['\fontname{Times new roman}{\itN}\fontname{宋体}{\it方向}\fontname{Times new roman}{\it(m)}'];
% X = ; Y = ;
% dPList_Plot(X,Y,FigSet);hold on
% FigSet.LineType = 'r^-';   
% X = ; Y = ;
% dPList_Plot(X,Y,FigSet);
% 
% subplot(3,1,3)
% FigSet.LineType = 'b^-'; 
% FigSet.ylabelName = ['\fontname{Times new roman}{\itU}\fontname{宋体}{\it方向}\fontname{Times new roman}{\it(m)}'];
% X = ; Y = ;
% dPList_Plot(X,Y,FigSet);hold on
% FigSet.LineType = 'r^-';  
% X = ; Y = ;
% dPList_Plot(X,Y,FigSet);
% 
% 
% % 指定图窗位置和大小
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 图例设置
% legend(FigSet.legendName,'FontSize',FigSet.FontSize,...
%     'Location',NorthEast,'Box','off');
% 
% % 图片保存
% print(gcf,FigSet.StorgePath,'-r600','-dtiff');
%% 对比结果




