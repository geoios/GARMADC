close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;
%% 
%% 绘制梯度参数后的声速剖面变化
% ComPath='D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\';
% % ParamName='ModelT_MP_SVP_Parameter48_10-4_space_time-height_spacetigma2000-300_U400_Ttigma20000-300_U400_SAGA_1903.mat';
% ParamName='ModelT_MP_SVP_Parameter48_10-4_space_time_SAGA_1903.mat';
% load([ComPath,ParamName]);
% %--------------------------------------------------
% OBSFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% %----------------声速剖面绝对路径-----------------
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% %----------------配置参数设置文件-----------------
% INIFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\initcfg\SAGA\SAGA.1903.kaiyo_k4-initcfg.ini';
% [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% 
% %% 数据解算
% Para=12;
% % 基本参数确定
% spdeg=3;MPNum=[12,12+Para,12+Para*2,12+Para*3];deltap=[10^-4;10^-6];InitialLambda=10;
% %  1.臂长转化
% [OBSData,INIData,SVP] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
% 
% %  2.B样条节点构造
% [knots]=Make_Bspline_knots(OBSData,spdeg,MPNum);%
% 
% % colornum=str2double(INIData.Data_file.N_shot);
% colornum=800;
% dq=jet(colornum);
% 
% MP=ModelT_MP_SVP;
% % 绘制参考声速剖面
% QQ=jet(9);
% tiledlayout(1,2);nexttile;
% FigSet.FontSize=12;
% 
% Transducer_ENU_ST=[1000,1000,0];
% PXP=[500,500,-1200];
% % 计算传波时间
% for i=1:10:colornum
% %     index=OBSData.MTPSign(i);
% %     Transducer_ENU_ST=[OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)];
% %     Transducer_ENU_RT=[OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)];
% %     [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,MP(index:index+2),[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
% %     [NewSVPEnd]=CalSVP(OBSData.RT(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_RT,MP(index:index+2),[INIData.SurE1Mean,INIData.SurN1Mean],INIData);
% 
%     [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,PXP,[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
%     plot(NewSVPStr(:,2),NewSVPStr(:,1),'LineWidth',0.5,'color',dq(i,:));
%     hold on
% end
% 
% FigSet.Name1=['拟合剖面'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% grid on
% set(gca,'YDir','reverse');
% 
% hXLabel = xlabel('\fontname{宋体}{\it声速值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% 
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% % 图例
% % h=legend(a,{'参考声速剖面'},'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
% % set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
% 
% nexttile;
% SVPArrray=[];
% for i=1:10:colornum
%     [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,PXP,[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
%     SVPArrray=[SVPArrray,NewSVPStr(:,2)];
% end
% SVPmean=mean(SVPArrray,2);
% for i=1:10:colornum
% %     index=OBSData.MTPSign(i);
% %     Transducer_ENU_ST=[OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)];
% %     Transducer_ENU_RT=[OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)];
% %     [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,MP(index:index+2),[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
% %     [NewSVPEnd]=CalSVP(OBSData.RT(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_RT,MP(index:index+2),[INIData.SurE1Mean,INIData.SurN1Mean],INIData);
% 
%     [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,PXP,[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
%     plot(NewSVPStr(:,2)-SVPmean,NewSVPStr(:,1),'color',dq(i,:));
%     hold on
% end
% 
% set(gca,'YDir','reverse');
% FigSet.Name1=['声速变化'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% grid on
% % set(gca,'YDir','reverse');
% FigSet.FontSize=20;
% % FigSet.Name1=['正方形航迹仿真声速差'];
% % hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% hXLabel = xlabel('\fontname{宋体}{\it声速变化值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% 
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'SVP1'});
% set(h,'FontName','Times New Roman','FontSize',FigSet.FontSize,'Location','best');

%% 总结观测数据结果
% B样条参数个数
% SAGA1903 = [-46.9688,408.8031,-1345.0479,486.6376,48.3151,-1354.3757,-26.3179,-505.9376,-1335.8946,-538.0387,-22.5777,-1330.4978];
% REF_List=[];RSS_List=[];
% for i=4:2:12
% load(['ModelT_MP_SVP_Parameter',num2str(12+i*3),'_10-4_space_time-height_spacetigma2000-300_U400_Ttigma20000-300_U400_SAGA_1903.mat'])
% PXPs = ModelT_MP_SVP(1:length(SAGA1903));
% [REF,RSS,dX] = SeafloorPositiongOutModel(PXPs,SAGA1903);
% REF_List=[REF_List;REF(3)];
% RSS_List=[RSS_List;RSS(3)];
% end
% NumDataList=[REF_List,RSS_List,REF_List+RSS_List];
% 
% 
% % 双指数截断深度
% REF_List=[];RSS_List=[];
% for i=4:10
% load(['ModelT_MP_SVP_Parameter48_10-4_space_time-height_spacetigma2000-300_U',num2str(i*100),'_Ttigma20000-300_U',num2str(i*100),'_SAGA_1903.mat'])
% PXPs = ModelT_MP_SVP(1:length(SAGA1903));
% [REF,RSS,dX] = SeafloorPositiongOutModel(PXPs,SAGA1903);
% REF_List=[REF_List;REF(3)];
% RSS_List=[RSS_List;RSS(3)];
% end
% HightDataList=[REF_List,RSS_List,REF_List+RSS_List];
% 
% % 南海相邻声速剖面求差，求平均速度，通过时间加权的方式确定单小时内声速变化；
% (0.9354*0.102+0.9862*0.182+0.052*1.246+0.156*1.6757)/(0.9354+0.9862+1.246+1.6757);




%% 绘制梯度参数后的声速剖面变化
% ComPath='D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\';
% ParamName='ModelT_MP_SVP_Parameter48_10-4_space_time-height_spacetigma2000-300_U400_Ttigma20000-300_U400_SAGA_1903.mat';
% ParamName='ModelT_MP_SVP_Parameter48_10-4_space_time_SAGA_1903.mat';
% ParamName='ModelT_T_SVP_Parameter45_10-4_space_time--SAGA_1903.mat';
% ParamName='ModelT_T_SVP_Parameter45_10-4_space_time-height_spacetigma2000-300_U400_Ttigma20000-300_U400_SAGA_1903.mat';
% load([ComPath,ParamName]);
% %--------------------------------------------------
% OBSFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-obs.csv';
% %----------------声速剖面绝对路径-----------------
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% %----------------配置参数设置文件-----------------
% INIFilePath='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\initcfg\SAGA\SAGA.1903.kaiyo_k4-initcfg.ini';
% [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);

% %% 数据解算
% Para=11;
% % 基本参数确定
% spdeg=3;MPNum=[12,12+Para,12+Para*2,12+Para*3];
% %  1.臂长转化
% [OBSData,INIData,SVP,~,T0,scale,V0] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
% 
% %  2.B样条节点构造
% [knots]=Make_Bspline_knots(OBSData,spdeg,MPNum);%

% colornum=str2double(INIData.Data_file.N_shot);
load('1.mat');
colornum=800;
dq=jet(colornum);
% 
MP=ModelT_MP_SVP;
% 绘制参考声速剖面
QQ=jet(9);
tiledlayout(1,2);nexttile;
FigSet.FontSize=18;

Transducer_ENU_ST=[-500,500,0];
PXP=[-500,500,-1200];
% 计算传波时间
for i=1:10:colornum
%     index=OBSData.MTPSign(i);
%     Transducer_ENU_ST=[OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)];
%     Transducer_ENU_RT=[OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)];
%     [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,MP(index:index+2),[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
%     [NewSVPEnd]=CalSVP(OBSData.RT(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_RT,MP(index:index+2),[INIData.SurE1Mean,INIData.SurN1Mean],INIData);

    [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,PXP,[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
    plot(NewSVPStr(:,2),NewSVPStr(:,1),'LineWidth',0.5,'color',dq(i,:));
    hold on
end

a = plot(SVP(1:end,2),SVP(1:end,1),'-k','LineWidth',1);
hold on
FigSet.Name1=['拟合剖面'];
hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
grid on
set(gca,'YDir','reverse');

hXLabel = xlabel('\fontname{宋体}{\it声速值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);

FigSet.PaperPosition=[0,0,20,10];
set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
FigSet.Size=[0,0,30,15];
set(gcf,'unit','centimeters','position',FigSet.Size);
% 改变ylabel离坐标轴的距离
set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% 图例
h=legend(a,{'参考声速剖面'},'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');

nexttile;
SVPArrray=[];
for i=1:colornum
    [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,PXP,[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
    SVPArrray=[SVPArrray,NewSVPStr(:,2)];
end
SVPmean=mean(SVPArrray,2);
for i=1:10:colornum
%     index=OBSData.MTPSign(i);
%     Transducer_ENU_ST=[OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)];
%     Transducer_ENU_RT=[OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)];
%     [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,MP(index:index+2),[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
%     [NewSVPEnd]=CalSVP(OBSData.RT(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_RT,MP(index:index+2),[INIData.SurE1Mean,INIData.SurN1Mean],INIData);

    [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,PXP,[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
    plot(NewSVPStr(:,2)-SVPmean,NewSVPStr(:,1),'LineWidth',0.5,'color',dq(i,:)); % SVPmean
    hold on
end

set(gca,'YDir','reverse');
FigSet.Name1=['声速变化'];
hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
grid on
% set(gca,'YDir','reverse');
FigSet.FontSize=18;
% FigSet.Name1=['正方形航迹仿真声速差'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
hXLabel = xlabel('\fontname{宋体}{\it声速变化值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);

FigSet.PaperPosition=[0,0,20,10];
set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
FigSet.Size=[0,0,30,15];
set(gcf,'unit','centimeters','position',FigSet.Size);
% 改变ylabel离坐标轴的距离
set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'SVP1'});
% set(h,'FontName','Times New Roman','FontSize',FigSet.FontSize,'Location','best');
% 设置颜色栏
cb = colorbar;
colormap jet
cb.Layout.Tile = 'south';
ENDValue=(OBSData.ST(colornum)-OBSData.ST(1))/3600;
cb.Ticks=[0,0.5/ENDValue,1/ENDValue,1];
cb.TickLabels={[num2str(OBSData.ST(1)-OBSData.ST(1)),'(h)'],'0.5(h)','1(h)',[num2str(ENDValue),'(h)']};
cb.Label.String = '观测持续时间(s)';
set(cb.Label,'fontsize',FigSet.FontSize)
% ylim([0,1500]);
% axis([-0.2 0.3 0 1500])
%% B样条曲线拟合声速场水平变化
% subplot(3,1,1);
% N_shot=str2double(INIData.Data_file.N_shot);
% % 绘制时间变化曲线
% for i=1:N_shot
% BValue(i) = Bspline_Function(OBSData.ST(i),ModelT_MP_SVP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,2);
% end
% plot(OBSData.ST-OBSData.ST(1),BValue,'-r','LineWidth',1)
% FigSet.FontSize=12;
% hYLabel = ylabel('\fontname{宋体}{\it时间变化}\fontname{Times new roman}{\it(m/s/km)}','FontSize',FigSet.FontSize);
% h=legend({'时间'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
% set(gca,'FontSize',FigSet.FontSize);
% set(gca,'xtick',0:3600:22600)      
% xlim([0,22600])
% subplot(3,1,2);
% for i=1:N_shot
% BValue(i) = Bspline_Function(OBSData.ST(i),ModelT_MP_SVP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,2);
% end
% plot(OBSData.ST-OBSData.ST(1),BValue,'-b','LineWidth',1)
% hYLabel = ylabel('\fontname{宋体}{\it梯度变化}\fontname{Times new roman}{\it(m/s/km)}','FontSize',FigSet.FontSize);
% h=legend({'水平E'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
% set(gca,'FontSize',FigSet.FontSize);
% xlim([0,22600])
% set(gca,'xtick',0:3600:22600) 
% 
% 
% 
% subplot(3,1,3);
% for i=1:N_shot
% BValue(i) = Bspline_Function(OBSData.ST(i),ModelT_MP_SVP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,2);
% end
% plot(OBSData.ST-OBSData.ST(1),BValue,'-g','LineWidth',1)
% 
% hXLabel = xlabel('\fontname{宋体}{\it观测时间}\fontname{Times new roman}{\it(s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it梯度变化}\fontname{Times new roman}{\it(m/s/km)}','FontSize',FigSet.FontSize);
% h=legend({'水平N'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
% set(gca,'FontSize',FigSet.FontSize);
% xlim([0,22600])
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% set(gca,'xtick',0:3600:22600) 
% 
% figure(5746)
% % 垂直变化
% subplot(1,2,1);
% % 时间变化的垂直声速变化约束
% BValue=[];j=1;
% for i=1:10:SVP(end,1)
% BValue(j) = Bspline_Function(i,ModelT_MP_SVP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,2);
% j=j+1;
% end
% plot(BValue,1:10:SVP(end,1),'-g','LineWidth',1)
% set(gca,'YDir','reverse');
% hXLabel = xlabel('\fontname{宋体}{\it速度变化}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% 
% subplot(1,2,2);
% % 梯度变化的垂直声速变化约束
% BValue=[];j=1;
% for i=1:10:SVP(end,1)
% BValue(j) = Bspline_Function(i,ModelT_MP_SVP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,2);
% j=j+1;
% end
% plot(BValue,1:10:SVP(end,1),'-b','LineWidth',1)
% set(gca,'YDir','reverse');
% hXLabel = xlabel('\fontname{宋体}{\it速度变化}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
%% 双指数模型
% 超参数 sigma_2,U_Cri
sigma=100000*sqrt(2);U_Cri=2000;
sigma2=0;
figure(3)
for i=1:length(SVP(:,1))
    if SVP(i,1)<U_Cri
        y(i) = exp(-(SVP(i,1)-U_Cri)^2/sigma^2);
    else
        y(i) = exp(-(SVP(i,1)-U_Cri)^2/sigma2^2);
    end
end
plot(SVP(:,1),y,'-b',SVP(:,1),y,'sr');
hold on

%% 声速空间梯度对应距离检验
% Centre=[0,0];
% PXP_ENU=[1000,500,-1200];
% Transducer_ENU=[-1000,-500,-5];
% P=[PXP_ENU;Transducer_ENU];
% SVPFilePath ='D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master-v.1.0.0\sample\obsdata\SAGA\SAGA.1903.kaiyo_k4-svp.csv';
% SVPDataTable=readtable(SVPFilePath);
% [SVPDataStruct] = DataTable2DataStruct(SVPDataTable);
% SVP(:,1)=SVPDataStruct.depth;SVP(:,2)=SVPDataStruct.speed;
% a=plot3(P(:,1),P(:,2),P(:,3),'sk');
% hold on 
% b=plot3(P(:,1),P(:,2),P(:,3),'-b');
% for i=1:length(SVP(:,1))
% R_E = ((PXP_ENU(1)-Centre(1))+(Transducer_ENU(1)-PXP_ENU(1))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
% R_N = ((PXP_ENU(2)-Centre(2))+(Transducer_ENU(2)-PXP_ENU(2))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
% c=plot3(R_E,R_N,-SVP(i,1),'.r');
% end
% grid on
% legend([a,b,c],{'起末端点','端点连线','内联点'});



