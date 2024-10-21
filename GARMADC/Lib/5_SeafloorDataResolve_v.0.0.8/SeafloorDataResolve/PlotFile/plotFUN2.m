% close all; clear; clc;close("all");
%% 获取当前脚本的位置
% ScriptPath      = mfilename('fullpath');      % 脚本位置
% [FilePath] = fileparts(ScriptPath);      % 文件夹位置
% cd(FilePath);
% clear FilePath;


x=-1:0.1:1;
y=-1:0.1:1;
[xx,yy]=meshgrid(x,y);
zz=xx.*exp(-xx.^2-yy.^2);
surf(xx,yy,zz);

%%
x0 = 0; y0 = 0; z0 = 0;
plot3(x0,y0,z0,'*k','linewidth',2,'markersize',10);
plot3(indexcol,indexrow,z0,'*k','linewidth',2,'markersize',10);
plot3(indexcol,indexrow,maxScore,'*k','linewidth',2,'markersize',10);
xx2(1) = x0; xx2(2) = indexcol;
yy2(1) = y0; yy2(2) = indexrow;
zz2(1) = z0; zz2(2) = z0;
plot3(xx2, yy2, zz2, 'r','linewidth',2);
%% 残差图绘制


% MatList = {'SAGA1903_OnlyT.mat','SAGA1903_ConstrianT_7-30_u_0.001.mat','SAGA1903_ConstrianT_7-30_u_0.01.mat','SAGA1903_ConstrianT_7-30_u_0.1.mat',...
%     'SAGA1903_ConstrianT_7-30_u_1.mat','SAGA1903_ConstrianT_7-30_u_10.mat','SAGA1903_ConstrianT_7-30_u_100.mat','SAGA1903_ConstrianT_7-30_u_1000.mat'};
% MatList = {'SAGA1903_ConstrianT_21-30_u_1.mat'};
% MatNum=[1];
% 
% for i=1:1
%     load(MatList{MatNum(i)});
%     xvalue = 1:length(ModelT_MP_SVP_OBSData.detalT);
%     index = find(strcmp(ModelT_MP_SVP_OBSData.flag,'True'));
%     V0 = MeanVel(SVP);
%     xvalue(index)=[];ModelT_MP_SVP_OBSData.detalT(index)=[];
%     plot(xvalue,ModelT_MP_SVP_OBSData.detalT*V0,'LineWidth',1);
%     hold on
%     ValueRMS(i)=rms(ModelT_MP_SVP_OBSData.detalT*V0);
% end
% 
% % % 数据格式转化
% %----------------观测文件绝对路径-----------------
% OBSFilePath='D:\GitHub\garpos-master-v.1.0.0\garpos-master\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% %----------------声速剖面绝对路径-----------------
% SVPFilePath ='D:\GitHub\garpos-master-v.1.0.0\garpos-master\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% %----------------配置参数设置文件-----------------
% INIFilePath='D:\GitHub\garpos-master-v.1.0.0\garpos-master\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-res.dat';
% [OBSData,SVP,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% V0 = MeanVel(SVP);
% OBSData.ResiTT(index)=[];OBSData.TT(index)=[];
% plot(xvalue,OBSData.ResiTT*V0);
% hold on
% ValueRMS(i+1)=rms(OBSData.ResiTT.*V0);
% 
% FigSet.FontSize=18;
% FigSet.Name1=['SAGA.1903 距离残差序列'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% 
% hXLabel = xlabel('\fontname{宋体}{\it观测历元}\fontname{宋体}{\it(个)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,20,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% 
% h=legend({['7层(RMS:',num2str(ValueRMS(1)),')'],['GARPOS(RMS:',num2str(ValueRMS(2)),')']});
% set(h,'FontSize',FigSet.FontSize,'Location','best');
% 
% axis([0 3700 -0.4 0.4])
% set(gca,'Box','on')

%% SAGA1903 参考声速剖面解算距离残差
% figure(213123)

% OBSFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% INIFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-res.dat';
% [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% index=1;
% for i=1:3614
% if strcmp(OBSData.flag{i},'True')
%     Value(index)=i;
%     index=index+1;
% end
% end



% xvalue=1:length(ModelT_MP_OBSData.detalT);
% xvalue(Value)=[];
% ModelT_MP_OBSData.detalT(Value)=[];
% V0 = MeanVel(SVP);
% plot(xvalue,ModelT_MP_OBSData.detalT*V0,'b');
% hold on
%
% FigSet.FontSize=18;
% FigSet.Name1=['SAGA.1903 距离残差序列'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
%
% hXLabel = xlabel('\fontname{宋体}{\it观测历元}\fontname{宋体}{\it(个)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,20,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'参考声速剖面求解'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
%
% axis([0 3700 -1.5 1.5])

%%
% figure(456)
%
% load('D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter12_10-4_SAGA_1903.mat');
% V0 = MeanVel(SVP);
% plot(1:length(ModelT_MP_OBSData.detalT),ModelT_MP_OBSData.detalT*V0,'b');
% hold on
%
% % 数据格式转化
% %----------------观测文件绝对路径-----------------
% OBSFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% %----------------声速剖面绝对路径-----------------
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% %----------------配置参数设置文件-----------------
% INIFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-res.dat';
% [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% MPNum=[12,24,54,84];
% %  1.臂长转化
% [~,INIData,SVP] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
% V0 = MeanVel(SVP);
% plot(1:length(OBSData.ResiTT),OBSData.ResiTT.*OBSData.TT*V0,'y');
% hold on
%
% load('D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter48_10-4_space_time-height_spacetigma2000-300_U400_Ttigma20000-300_U400_SAGA_1903.mat')
% V0 = MeanVel(SVP);
% plot(1:length(ModelT_MP_SVP_OBSData.detalT),ModelT_MP_SVP_OBSData.detalT*V0,'r');
% hold on
%
% %---------------------------------------------------------------------------------------%
% FigSet.FontSize=12;
% FigSet.Name1=['SAGA.1903 残差序列'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
%
% hXLabel = xlabel('\fontname{宋体}{\it观测历元}\fontname{宋体}{\it(个)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'参考声速剖面求解','GARPOS','声速剖面补偿解算'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
% axis([0 3700 -2.5 4.5])
% %----------------------------------------------------------------------------------------%
%
%
%
%
% %%
% figure(45)
%
% load('D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter12_10-4_SAGA_1903.mat');
% V0 = MeanVel(SVP);
% plot(1:length(ModelT_MP_OBSData.detalT),ModelT_MP_OBSData.detalT*V0,'b');
% hold on
%
% load('D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter48_10-4_space_time-height_spacetigma2000-300_U400_Ttigma20000-300_U400_SAGA_1903.mat')
% V0 = MeanVel(SVP);
% plot(1:length(ModelT_MP_SVP_OBSData.detalT),ModelT_MP_SVP_OBSData.detalT*V0,'r');
% hold on
%
%
% % 数据格式转化
% %----------------观测文件绝对路径-----------------
% OBSFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% %----------------声速剖面绝对路径-----------------
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% %----------------配置参数设置文件-----------------
% INIFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-res.dat';
% [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% MPNum=[12,24,54,84];
% %  1.臂长转化
% [~,INIData,SVP] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
% V0 = MeanVel(SVP);
% plot(1:length(OBSData.ResiTT),OBSData.ResiTT*V0,'y');
% hold on
%
% FigSet.FontSize=12;
% FigSet.Name1=['SAGA.1903 残差序列'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
%
% hXLabel = xlabel('\fontname{宋体}{\it观测历元}\fontname{宋体}{\it(个)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'参考声速剖面求解','声速剖面补偿解算','GARPOS'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
%
%
% axis([0 3700 -1 2])



%% 时变解算残差时序绘制
% figure(4543)
% 数据格式转化
% ----------------观测文件绝对路径-----------------
% OBSFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% ----------------声速剖面绝对路径-----------------
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% ----------------配置参数设置文件-----------------
% INIFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-res.dat';
% [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% index=1;
% for i=1:3614
%     if strcmp(OBSData.flag{i},'True')
%         Value(index)=i;
%         index=index+1;
%     end
% end
% MatList={'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter12_10-4_SAGA_1903.mat',...
%         'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter48_10-4_space_time_SAGA_1903.mat',...
%         'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_T_SVP_Parameter48_10-4_space_time_SAGA_1903.mat'};
% 
% MatList={'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter12_10-4_SAGA_1903.mat',...
%          'ModelT_MP_SVP_Parameter36_10-4_space-time_SAGA_1903.mat',...
%         'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter48_10-4_space_time_SAGA_1903.mat'};
% 
% MatList={'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter12_10-4_SAGA_1903.mat',...
%          'ModelT_MP_SVP_Parameter36_10-4_space-time_SAGA_1903.mat',...
%         'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_T_SVP_Parameter45_10-4_space_time--SAGA_1903.mat'};
% 
% 
% 
% 
% MatList={'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_MP_SVP_Parameter12_10-4_SAGA_1903.mat',...
%     'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_T_SVP_Parameter45_10-4_space_time--SAGA_1903.mat',...
%     'D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\ModelT_T_SVP_Parameter45_10-4_space_time-height_spacetigma2000-300_U400_Ttigma20000-300_U400_SAGA_1903.mat'};
% 
% load(MatList{1});
% xvalue=1:length(ModelT_MP_OBSData.detalT);
% xvalue(Value)=[];
% ModelT_MP_OBSData.detalT(Value)=[];
% V0 = MeanVel(SVP);
% plot(xvalue,ModelT_MP_OBSData.detalT*V0,'LineWidth',1);
% hold on
% 
% load(MatList{2});
% ModelT_MP_SVP_OBSData.detalT(Value)=[];
% V0 = MeanVel(SVP);
% plot(xvalue,ModelT_MP_SVP_OBSData.detalT*V0,'LineWidth',1);
% ValueRMS(1)=rms(ModelT_MP_SVP_OBSData.detalT*V0);
% 
% load(MatList{3});
% ModelT_MP_T_OBSData.LogdetalT(Value)=[];
% ModelT_MP_T_OBSData.TT(Value)=[];
% V0 = MeanVel(SVP);
% plot(xvalue,ModelT_MP_T_OBSData.LogdetalT.*ModelT_MP_T_OBSData.TT'*V0,'LineWidth',1);
% 
% ModelT_MP_SVP_OBSData.detalT(Value)=[];
% V0 = MeanVel(SVP);
% plot(xvalue,ModelT_MP_SVP_OBSData.detalT*V0,'LineWidth',1);
% 
% ValueRMS(2)=rms(ModelT_MP_SVP_OBSData.detalT*V0);
% 
% 
% 
% OBSFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% INIFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\demo_prep\SAGA\SAGA.1903.kaiyo_k4-res.dat';
% [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% MPNum=[12,24,54,84];
% [~,INIData,SVP] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
% 
% V0 = MeanVel(SVP);
% OBSData.ResiTT(Value)=[];
% plot(xvalue,OBSData.ResiTT*V0,'LineWidth',1);
% hold on
% 
% ValueRMS(3)=rms(OBSData.ResiTT*V0);
% 
% FigSet.FontSize=18;
% FigSet.Name1=['SAGA.1903 距离残差序列'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% 
% hXLabel = xlabel('\fontname{宋体}{\it观测历元}\fontname{宋体}{\it(个)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
% FigSet.Size=[0,0,20,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
%  h=legend({'方法A','方法B','方法C'});
%  h=legend({'方法B','方法D'});
% h=legend({'方法D','方法E','GARPOS'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
% 
% 
% axis([0 3700 -2.5 4.5])
% axis([0 3700 -0.7 0.7])
% set(gca,'Box','on')
