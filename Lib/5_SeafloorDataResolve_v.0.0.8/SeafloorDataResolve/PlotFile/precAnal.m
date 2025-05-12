 %% 脚本说明
%功能：
%输入：+ModelT_MP_T保存路径
%输出：
clc;clear
load('E:\研究题目\Dev-main-XZ\Apps\SeafloorDataResolve_v.0.0.2\50.mat');
expoPlotPath = 'E:\研究题目\Dev-main-XZ\Apps\SeafloorDataResolve_v.0.0.2\导出\50\';
%% 读取日本定位结果
%filePath = 'E:\研究题目\2022下11_四维时空声速场对水下定位影响\声速剖面定位结果比较\MYGI定位解算结果garpos\0d_日本实测\加校正日本剖面解算\';
filePath = 'E:\研究题目\2022上1_声速场空间拟合推估\Main5_考虑时间的kriging插值\data_Tohoku2011-2020\single-default\MYGI\';
[centerEnuCoor,seaFloorEnuCoor] = getPositResu(filePath);
%% 获取日本文件信息
%日本声速剖面信息获取
filePathIni = 'E:\研究题目\2022下1_二维时空声速场时空建模\Data\日本\ini\';
[iniInfo] = getIniData(filePathIni);
%% 读取当前程序定位结果
xiaoResu = ModelT_MP_T;
for iFile = 1:size(iniInfo.seaFloorStation,1)
    seaFloorStatNum = size(iniInfo.seaFloorStation{iFile},2);
    [centerEnuCoor_xiao(iFile,:),seaFloorEnuCoor_xiao{iFile,1}] = readXiaoInfo(xiaoResu{iFile,1},seaFloorStatNum);
end
%% 方法互差
%中心点互差cm
diffCenterEnuCoor = (centerEnuCoor - centerEnuCoor_xiao)*100;
%海底点互差cm
for iFile = 1:size(iniInfo.seaFloorStation,1)
    diffSeaFloorEnuCoor{iFile,1} = (seaFloorEnuCoor{iFile,1} - seaFloorEnuCoor_xiao{iFile,1})*100;
    tempo{iFile,1} = abs(diffSeaFloorEnuCoor{iFile,1});
    maxTempo{iFile,1} = max(tempo{iFile,1});
    pos1 = find(tempo{iFile,1}(:,1) == maxTempo{iFile,1}(1));
    pos2 = find(tempo{iFile,1}(:,2) == maxTempo{iFile,1}(2));
    pos3 = find(tempo{iFile,1}(:,3) == maxTempo{iFile,1}(3));
    diffSeaFloorEnuCoor_max(iFile,:) = [diffSeaFloorEnuCoor{iFile,1}(pos1,1) diffSeaFloorEnuCoor{iFile,1}(pos2,2) diffSeaFloorEnuCoor{iFile,1}(pos3,3)];
end
%% 导出
%中心点平面点位误差、高程误差
lineType = 'b^-';
planeErroe = [iniInfo.xAxisCoor sqrt(diffCenterEnuCoor(:,1).^2 + diffCenterEnuCoor(:,2).^2)];
subplot(2,1,1)
plotPositDiff(planeErroe,lineType);legend('\fontname{宋体}平面点位误差','Location','NorthEast','Orientation','horizon','Box','off');
elevaError = [iniInfo.xAxisCoor diffCenterEnuCoor(:,3)];
subplot(2,1,2)
plotPositDiff(elevaError,lineType);legend('\fontname{宋体}高程误差','Location','NorthEast','Orientation','horizon','Box','off');
set(gcf,'Units','centimeter','Position',[5 5 20 15]);
eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,'中心点坐标误差','.png'')']);

%海底站点ENU最大值+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
eSeaFloorMaxError = [iniInfo.xAxisCoor diffSeaFloorEnuCoor_max(:,1)];
subplot(3,1,1)
plotPositDiff(eSeaFloorMaxError,lineType);legend('\fontname{宋体}E方向最大误差','Location','NorthEast','Orientation','horizon','Box','off');
nSeaFloorMaxError = [iniInfo.xAxisCoor diffSeaFloorEnuCoor_max(:,2)];
subplot(3,1,2)
plotPositDiff(nSeaFloorMaxError,lineType);legend('\fontname{宋体}N方向最大误差','Location','NorthEast','Orientation','horizon','Box','off');
uSeaFloorMaxError = [iniInfo.xAxisCoor diffSeaFloorEnuCoor_max(:,3)];
subplot(3,1,3)
plotPositDiff(uSeaFloorMaxError,lineType);legend('\fontname{宋体}U方向最大误差','Location','NorthEast','Orientation','horizon','Box','off');
set(gcf,'Units','centimeter','Position',[5 5 20 25]);
eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,'海底点方向最大误差','.png'')']);

%时间序列比较++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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