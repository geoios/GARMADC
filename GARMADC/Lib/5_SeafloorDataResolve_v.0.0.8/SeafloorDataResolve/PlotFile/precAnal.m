 %% �ű�˵��
%���ܣ�
%���룺+ModelT_MP_T����·��
%�����
clc;clear
load('E:\�о���Ŀ\Dev-main-XZ\Apps\SeafloorDataResolve_v.0.0.2\50.mat');
expoPlotPath = 'E:\�о���Ŀ\Dev-main-XZ\Apps\SeafloorDataResolve_v.0.0.2\����\50\';
%% ��ȡ�ձ���λ���
%filePath = 'E:\�о���Ŀ\2022��11_��άʱ�����ٳ���ˮ�¶�λӰ��\�������涨λ����Ƚ�\MYGI��λ������garpos\0d_�ձ�ʵ��\��У���ձ��������\';
filePath = 'E:\�о���Ŀ\2022��1_���ٳ��ռ�����ƹ�\Main5_����ʱ���kriging��ֵ\data_Tohoku2011-2020\single-default\MYGI\';
[centerEnuCoor,seaFloorEnuCoor] = getPositResu(filePath);
%% ��ȡ�ձ��ļ���Ϣ
%�ձ�����������Ϣ��ȡ
filePathIni = 'E:\�о���Ŀ\2022��1_��άʱ�����ٳ�ʱ�ս�ģ\Data\�ձ�\ini\';
[iniInfo] = getIniData(filePathIni);
%% ��ȡ��ǰ����λ���
xiaoResu = ModelT_MP_T;
for iFile = 1:size(iniInfo.seaFloorStation,1)
    seaFloorStatNum = size(iniInfo.seaFloorStation{iFile},2);
    [centerEnuCoor_xiao(iFile,:),seaFloorEnuCoor_xiao{iFile,1}] = readXiaoInfo(xiaoResu{iFile,1},seaFloorStatNum);
end
%% ��������
%���ĵ㻥��cm
diffCenterEnuCoor = (centerEnuCoor - centerEnuCoor_xiao)*100;
%���׵㻥��cm
for iFile = 1:size(iniInfo.seaFloorStation,1)
    diffSeaFloorEnuCoor{iFile,1} = (seaFloorEnuCoor{iFile,1} - seaFloorEnuCoor_xiao{iFile,1})*100;
    tempo{iFile,1} = abs(diffSeaFloorEnuCoor{iFile,1});
    maxTempo{iFile,1} = max(tempo{iFile,1});
    pos1 = find(tempo{iFile,1}(:,1) == maxTempo{iFile,1}(1));
    pos2 = find(tempo{iFile,1}(:,2) == maxTempo{iFile,1}(2));
    pos3 = find(tempo{iFile,1}(:,3) == maxTempo{iFile,1}(3));
    diffSeaFloorEnuCoor_max(iFile,:) = [diffSeaFloorEnuCoor{iFile,1}(pos1,1) diffSeaFloorEnuCoor{iFile,1}(pos2,2) diffSeaFloorEnuCoor{iFile,1}(pos3,3)];
end
%% ����
%���ĵ�ƽ���λ���߳����
lineType = 'b^-';
planeErroe = [iniInfo.xAxisCoor sqrt(diffCenterEnuCoor(:,1).^2 + diffCenterEnuCoor(:,2).^2)];
subplot(2,1,1)
plotPositDiff(planeErroe,lineType);legend('\fontname{����}ƽ���λ���','Location','NorthEast','Orientation','horizon','Box','off');
elevaError = [iniInfo.xAxisCoor diffCenterEnuCoor(:,3)];
subplot(2,1,2)
plotPositDiff(elevaError,lineType);legend('\fontname{����}�߳����','Location','NorthEast','Orientation','horizon','Box','off');
set(gcf,'Units','centimeter','Position',[5 5 20 15]);
eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,'���ĵ��������','.png'')']);

%����վ��ENU���ֵ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
eSeaFloorMaxError = [iniInfo.xAxisCoor diffSeaFloorEnuCoor_max(:,1)];
subplot(3,1,1)
plotPositDiff(eSeaFloorMaxError,lineType);legend('\fontname{����}E����������','Location','NorthEast','Orientation','horizon','Box','off');
nSeaFloorMaxError = [iniInfo.xAxisCoor diffSeaFloorEnuCoor_max(:,2)];
subplot(3,1,2)
plotPositDiff(nSeaFloorMaxError,lineType);legend('\fontname{����}N����������','Location','NorthEast','Orientation','horizon','Box','off');
uSeaFloorMaxError = [iniInfo.xAxisCoor diffSeaFloorEnuCoor_max(:,3)];
subplot(3,1,3)
plotPositDiff(uSeaFloorMaxError,lineType);legend('\fontname{����}U����������','Location','NorthEast','Orientation','horizon','Box','off');
set(gcf,'Units','centimeter','Position',[5 5 20 25]);
eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,'���׵㷽��������','.png'')']);

%ʱ�����бȽ�++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
load('E:\�о���Ŀ\Dev-main-XZ\Apps\SeafloorDataResolve_v.0.0.2\��ʱ������\Center_standra.mat');
timeSeries = (centerEnuCoor - Center_standra)*100;
timeSeries_xiao = (centerEnuCoor_xiao - Center_standra)*100;
subplot(3,1,1)
plotPositDiff([iniInfo.xAxisCoor timeSeries(:,1)],lineType);hold on;
plotPositDiff([iniInfo.xAxisCoor timeSeries_xiao(:,1)],'r^-');
legend('\fontname{����}�ձ������׼���ĵ��(E)','\fontname{����}���ǽ����׼���ĵ��(E)','Location','NorthEast','Box','off');%'Orientation','horizon',
subplot(3,1,2)
plotPositDiff([iniInfo.xAxisCoor timeSeries(:,2)],lineType);hold on;
plotPositDiff([iniInfo.xAxisCoor timeSeries_xiao(:,2)],'r^-');
legend('\fontname{����}�ձ������׼���ĵ��(N)','\fontname{����}���ǽ����׼���ĵ��(N)','Location','NorthEast','Box','off');%'Orientation','horizon',
subplot(3,1,3)
plotPositDiff([iniInfo.xAxisCoor timeSeries(:,3)],lineType);hold on;
plotPositDiff([iniInfo.xAxisCoor timeSeries_xiao(:,3)],'r^-');
legend('\fontname{����}�ձ������׼���ĵ��(U)','\fontname{����}���ǽ����׼���ĵ��(U)','Location','NorthEast','Box','off');%'Orientation','horizon',
set(gcf,'Units','centimeter','Position',[5 5 20 25]);
eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,'ʱ�����бȽ�','.png'')']);