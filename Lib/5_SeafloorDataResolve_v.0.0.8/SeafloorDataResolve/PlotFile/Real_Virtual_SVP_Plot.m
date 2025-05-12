close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

%% 数据加载
modelNum = 1;
MpNum = 0;
% TRI={'BigSquare','SmallSquare','Mi','TwoSquare','BigSmallMi'};
% ComPath=['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\指定周期变化\'];
% load([ComPath,'Parameter12_3000_3000_45_300_10-4_',TRI{modelNum},'.mat']);
% load([ComPath,TRI{modelNum},'\SimulationData1\SimulationData1.mat'])
% load('D:\MatlabStu\github\Z_Data\2019年海洋项目原始观测数据\数据整理\SVP\ProfileStrutrue.mat');
% INIDataStruct=ReadNSinex([ComPath,TRI{modelNum},'\SimulationData1\Data.SimulationData1-initcfg.ini']);


% load('G:\dATA\Parameter12_3000_3000_45_300_10-4_BigSmallMi_Single.mat');
% load('G:\dATA\SimulationData1.mat');
% INIDataStruct=ReadNSinex('G:\dATA\Data.SimulationData1-initcfg.ini');

%% 绘制实测声速剖面与平均声速剖面的声速变化

% figure(19)
% QQ=jet(8);
% SubP=ProfileStrutrue.SubProfile;
% n=length(SubP);
% for i=1:n
%     SubSVP = SubP{i};
%     SVP_ini_List(:,i) =  SubSVP(:,2);
% end
% SVP_ini = mean(SVP_ini_List,2);
% 
% 
% for j=1:n
%     SubSVP=SubP{j};
%     dSVP=SubSVP(:,2)-SVP_ini;
%     a=plot(dSVP,SubSVP(:,1),'LineWidth',1.5,'Color',QQ(j,:));
%     hold on
% end
% grid on
% set(gca,'YDir','reverse');
% FigSet.FontSize=18;
% FigSet.Name1=['2019年南海实测声速变化'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hXLabel = xlabel('\fontname{宋体}{\it声速变化值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,20,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'13.22:11','13.23:26','14.14:02','14.15:43','15.00:25','15.01:21','15.12:52','15.13:51'});
% set(h,'FontName','Times New Roman','FontSize',FigSet.FontSize,'Location','best');
% axis([-8 8 0 3100])
% 
% BB=jet(4);
% 
% 
% figure(1435)
% for j=1:n/2
%     SubSVP1=SubP{j*2};
%     SubSVP2=SubP{j*2-1};
%     dSVP=SubSVP1(:,2)-SubSVP2(:,2);
%     detalVmean(j)=mean(dSVP);
%     a=plot(dSVP,SubSVP1(:,1),'LineWidth',1.5,'Color',BB(j,:));
%     hold on
% end
% grid on
% set(gca,'YDir','reverse');
% FigSet.FontSize=18;
% FigSet.Name1=['南海相邻剖面速度变化'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hXLabel = xlabel('\fontname{宋体}{\it声速变化值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,20,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'74:45','100:32','55:31','59:10'});
% set(h,'FontName','Times New Roman','FontSize',FigSet.FontSize,'Location','best');
% axis([-5.5 9 0 3070])


%%
% CC=fieldnames(INIDataStruct.Model_parameter.MT_Pos);
% for i=1:length(CC)
%     if ~isempty(strfind(CC{i},'_dPos'))
%         MpNum=MpNum+1;
%     end
% end
% colornum=str2double(INIDataStruct.Data_file.N_shot)/MpNum;
% dq=jet(colornum);
%% 实际观测声速剖面绘制
% figure(1)
% QQ=jet(9);
% subplot(1,2,1)
% SubP=ProfileStrutrue.SubProfile;
% n=length(SubP);
% for j=1:n
%     SubSVP=SubP{j};
%     plot (SubSVP(:,2),SubSVP(:,1),'LineWidth',1,'Color',QQ(1+j,:));
%     hold on
% end
% grid on
% set(gca,'YDir','reverse');
% FigSet.FontSize=12;
% % FigSet.Name1='仿真声速剖面';
% % hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
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
% h=legend({'SVP1(22:11.37.5)','SVP2()','SVP3','SVP4','SVP5','SVP6','SVP7','SVP8'});
% set(h,'FontName','Times New Roman','FontSize',FigSet.FontSize,'Location','best');
% 将图窗内容保存到Fig文件
% savefig(1,FigSet.Name1);
% print(gcf,FigSet.Name1,'-r600','-dtiff');
% axis([1480 1550 0 3070])
%% 实际声速剖面变化
% subplot(1,2,2);
% SVP_ini=SubP{1};
% for j=1:n
%     SubSVP=SubP{j};
%     dSVP=SubSVP(:,2)-SVP_ini(:,2);
%     a=plot(dSVP,SubSVP(:,1),'LineWidth',1,'Color',QQ(1+j,:));
%     hold on
% end
% grid on
% set(gca,'YDir','reverse');
% FigSet.FontSize=12;
% % FigSet.Name1=['正方形航迹仿真声速差'];
% % hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hXLabel = xlabel('\fontname{宋体}{\it声速变化值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% h=legend({'SVP1','SVP2','SVP3','SVP4','SVP5','SVP6','SVP7','SVP8'});
% set(h,'FontName','Times New Roman','FontSize',FigSet.FontSize,'Location','best');
% 坐标轴范围
% axis([-15 10 0 3070])
% 将图窗内容保存到Fig文件
% FigSet.Name2='实测SVP及其相对基准SVP变化图';
% savefig(1,FigSet.Name2);
% print(gcf,FigSet.Name2,'-r600','-dtiff');

%% 绘制声速剖面图
% PLOT1=figure(2);
% % subplot(1,2,1);
% tiledlayout(1,2);nexttile;
% m=length(SurData);num=1;
% for j=1:m
%     %subplot(2,2,j)
%     n=length(SurData(j).MTSVP(1).SVPData);
%     for i=1:n
%         SVP=SurData(j).MTSVP(1).SVPData(i).PF;
%         plot(SVP(:,2),SVP(:,1),'color',dq(num,:));
%         num=num+1;
%         hold on
%     end
% end
% grid on
% %%%%
% for j=1:2
%     SubSVP=SubP{j};
%     plot (SubSVP(:,2),SubSVP(:,1),'k','LineWidth',1.5);
%     hold on
% end
% %%%%
% set(gca,'YDir','reverse');
% FigSet.FontSize=12;
% % FigSet.Name1=['正方形航迹仿真声速剖面'];
% % hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hXLabel = xlabel('\fontname{宋体}{\it声速值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% % 坐标轴范围
% axis([1480 1550 0 3070])
%% 绘制声速剖面变化图
% figure(2)
% subplot(1,2,2);
% nexttile;
% num=1;
% for j=1:m
%     n=length(SurData(j).MTSVP(1).SVPData);
%     for i=1:n
%         detalSVP=SurData(j).MTSVP(1).SVPData(i).PF(:,2)-SurData(1).MTSVP(1).SVPData(1).PF(:,2);
%         tmp(:,num)=detalSVP;
%         plot(detalSVP,OutData(1).SVPAvg(:,1),'color',dq(num,:));
%         num=num+1;
%         hold on
%     end
% end
% grid on
% %%%%
% for j=1:2
%     SubSVP=SubP{j};
%     dSVP=SubSVP(:,2)-SVP_ini(:,2);
%     a=plot(dSVP,SubSVP(:,1),'LineWidth',1,'Color',QQ(1+j,:));
%     hold on
% end
% %%%%
% set(gca,'YDir','reverse');
% FigSet.FontSize=12;
% % FigSet.Name1=['正方形航迹仿真声速差'];
% % hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hXLabel = xlabel('\fontname{宋体}{\it声速变化值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
% hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% % 坐标轴范围
% axis([-5 3 0 3070])
% % 设置颜色栏
% cb = colorbar;
% colormap jet
% cb.Layout.Tile = 'south';
% cb.Ticks=[linspace(0,1,5)];
% cb.TickLabels={'22:11.37.5','22:41:22.5','23:11:22.5','23:41:22.5','24:11:22.5'};
% % set(colorbar,'tickdir','out')  % 朝外
% colorbar('Direction','reverse',...
%          'location','southoutside',...
%          'Ticks',[linspace(0,1,5)],...
%          'TickLabels',{'22:11.37.5','22:41:22.5','23:11:22.5','23:41:22.5','00:11:22.5'});
% 将图窗内容保存到Fig文件
% FigSet.Name2='仿真SVP及其相对基准SVP变化图';
% savefig(2,FigSet.Name2);
% print(gcf,FigSet.Name2,'-r600','-dtiff');

%% 草稿
% SubP=ProfileStrutrue.SubProfile;
% n=length(SubP);
% for j=1:n
% SubSVP=SubP{j};
% b=plot (SubSVP(:,2),SubSVP(:,1));
% hold on
% end
% xlabel('声速m/s');
% ylabel('水深m');
%
% legend('SVP1','SVP2','SVP3','SVP4','SVP5','SVP6','SVP7','SVP8');
% title('实测声速剖面图');
% set(gca,'YDir','reverse') 

%% SVP中间时刻计算
% t_start = datevec('12:25:48');  % 将开始时间的字符串转换为数组
% t_end = datevec('13:18:25');  % 将结束时间的字符串转换为数组
% dt = etime(t_end,t_start);  % 计算两个时间点之间差了多少秒
% t_start1 = datetime(2019,7,15,12,25,48);  % 将开始时间的字符串转换为数组
% t = t_start1 + seconds(dt/2+0.5)  % 计算过了720秒之后的时间




