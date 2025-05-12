clear;clc;close all
%%
% Lambda=[65,70,75,78,79,80,81,82,85,90];% Lambda=[11,12,13,14,16,17,18,19];
% for i=1:length(Lambda)
% [t1(i,:),Loop(i,:)]=FindLambda_ComposeFunction(Lambda(i),Data);
% end


%% 加权平均声速绘制
TRI='SmallSquare';
ComPath='G:\Chinese Journal of Geophysics\SimulationData\';
load([ComPath,'指定周期变化\Parameter12_3000_3000_45_300_10-4_',TRI,'.mat']);
load([ComPath,'指定周期变化\',TRI,'\SimulationData1\SimulationData1.mat'])
MP_SVP=mean(ModelT_MP_SVP,1);
LaunchRT=NeedData.LaunchRT;
LaunchTime=Calc_Annual_Second(LaunchRT);
LT=LaunchTime/(3600);
% B样条时间节点范围
KnotSTData=OutData(1).ST_TIME(1,:,1);KnotRTData=OutData(end).RT_TIME(end,:,end);
KnotST=day(datetime(NeedData.Year,KnotSTData(1),KnotSTData(2)),'dayofyear')*24*3600+KnotSTData(3)*3600+KnotSTData(4)*60+KnotSTData(5);
KnotRT=day(datetime(NeedData.Year,KnotRTData(1),KnotRTData(2)),'dayofyear')*24*3600+KnotRTData(3)*3600+KnotRTData(4)*60+KnotRTData(5);
KnotTT=[KnotST,KnotRT];
% 参考声速剖面，加权平均声速
LSVP=SurData(1).MTSVP(1).SVPData(1).PF;
V0=MeanVel(LSVP);
YreaArray=[];YsvpArray=[];
for Num=1
    figure(1)
    TimeNum=1;
    for j=1:length(SurData)
        
        for num=1:size(OutData(j).Sign,2)
            T=SurData(j).T;TStart=Data(j).TStart(num);
            for i=1:length(SurData(j).MTSVP(num).SVPData)
                
                % 读取各个观测时刻声速剖面
                SVPStr=SurData(j).MTSVP(num).SVPData(i).PF;
                %                 SVPEnd=SurData(j).MTSVP(num).SVPEnd(i).PF;
                % 计算加权平均声速
                VStr=MeanVel(SVPStr);
                %                 VEnd=MeanVel(SVPEnd);
                % 读取各个观测时刻
                Time=OutData(j).ST_TIME(i,:,num);
                SecTime=Calc_Annual_Second([2019,Time]);
                ST=SecTime/3600;
                ObsT=ST-LT;
                a=plot(ObsT,VStr-V0,'.r');
                YreaArray=[YreaArray;ObsT,VStr-V0];
                hold on
                TimeList(TimeNum)=ObsT;
                [Newsvp] = SSSdoubleChange2(SecTime,LSVP,MP_SVP(Num,13:end),KnotTT,LaunchTime);
                NewV=MeanVel(Newsvp);
                b=plot(ObsT,NewV-V0,'b.');
                YsvpArray=[YsvpArray;ObsT,NewV-V0];
                TimeNum=TimeNum+1;
            end
        end
    end
    [value,index]=sort(YreaArray(:,1));
    Yrea=[value,YreaArray(index,2)];
    Ysvp=[value,YsvpArray(index,2)];
    for DataNum=1:300
        OBSFilePath=[ComPath,'指定周期变化\',TRI,'\SimulationData',num2str(DataNum),'\Data.SimulationData',num2str(DataNum),'-obs.csv'];
        SVPFilePath=[ComPath,'指定周期变化\',TRI,'\SimulationData',num2str(DataNum),'\Data.SimulationData',num2str(DataNum),'-svp.csv'];
        INIFilePath=[ComPath,'指定周期变化\',TRI,'\SimulationData',num2str(DataNum),'\Data.SimulationData',num2str(DataNum),'-initcfg.ini'];
        [OBSData,SVPData,INIData,MP1]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);MPNum=[12,24];
        [~,~,~,~,~,~,Vo] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
        dV(DataNum,:)=ModelT_MP_T_OBSData(DataNum).gammer*Vo;
    end
    c=plot(sort(TimeList),mean(dV,1),'g.');
    YTArray=[sort(TimeList);mean(dV,1)];
    YTArray=YTArray';
    hold on
    
    
    
    FigSet.FontSize=15;
%     %     FigSet.Name1=['第',num2str(Num),'次实验加权声速变化'];
%     FigSet.Name1=['不同解算方法加权声速变化'];
%     hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
    hXLabel = xlabel('\fontname{宋体}{\it时间}\fontname{Times new roman}{\it(h)}','FontSize',FigSet.FontSize);
    hYLabel = ylabel('\fontname{宋体}{\it声速变化}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
    % 改变坐标轴刻度显示
    % set(gca,'XTick',)
    set(gca,'FontSize',FigSet.FontSize,'FontName','Times New Roman');
    FigSet.PaperPosition=[0,0,20,10];
    set(gcf, 'PaperPosition', FigSet.PaperPosition);
    % 指定figure的尺寸
    FigSet.Size=[0,0,30,15];
    set(gcf,'unit','centimeters','position',FigSet.Size);
    % 改变ylabel离坐标轴的距离
    set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
    %     % 设定图例 名称 字体大小 边框线线宽
    h1=legend([a,b,c],{'仿真实际声速变化','方法2声速变化','方法3声速变化'},...
        'FontSize',FigSet.FontSize,'LineWidth',0.5);%'location','best'
    set(h1,'Fontname', '宋体','FontSize',FigSet.FontSize) %'FontWeight','bold',
     FigSet.Name2=[TRI,'加权声速变化'];
%      savefig(1,FigSet.Name2);
%      print(gcf,FigSet.Name2,'-r600','-dtiff');
end

SVPdetalV = Yrea(:,2)-Ysvp(:,2);
TdetalV = Yrea(:,2) - YTArray(:,2);
SVP_mse = mse(SVPdetalV);
T_mse = mse(TdetalV);





%%
% for mpp=21:27
%     subplot(3,3,mpp-20)
%     eval(['MP_SVP=SVPStruct.MP',num2str(mpp),'(3,:);']);
%     eval(['MP_T=SVPStruct.MP',num2str(mpp),'(3,:);']);
% LaunchRT=NeedData.LaunchRT;
% LaunchTime=Calc_Annual_Second(LaunchRT);
% LT=LaunchTime/(3600);
% % B样条时间节点范围
% KnotSTData=OutData(1).ST_TIME(1,:,1);KnotRTData=OutData(end).RT_TIME(end,:,end);
% KnotST=day(datetime(NeedData.Year,KnotSTData(1),KnotSTData(2)),'dayofyear')*24*3600+KnotSTData(3)*3600+KnotSTData(4)*60+KnotSTData(5);
% KnotRT=day(datetime(NeedData.Year,KnotRTData(1),KnotRTData(2)),'dayofyear')*24*3600+KnotRTData(3)*3600+KnotRTData(4)*60+KnotRTData(5);
% KnotTT=[KnotST,KnotRT];
% % 参考声速剖面，加权平均声速
% LSVP=SurData(1).MTSVP(1).SVPData(1).PF;
% V0=MeanVel(LSVP);
% for Num=1
%     figure(1)
%     for j=1:length(SurData)
%         c=1;
%         for num=1:size(OutData(j).Sign,2)
%             T=SurData(j).T;TStart=Data(j).TStart(num);
%             for i=1:length(SurData(j).MTSVP(num).SVPData)
%
%                 % 读取各个观测时刻声速剖面
%                 SVPStr=SurData(j).MTSVP(num).SVPData(i).PF;
% %                 SVPEnd=SurData(j).MTSVP(num).SVPEnd(i).PF;
%                 % 计算加权平均声速
%                 VStr=MeanVel(SVPStr);
% %                 VEnd=MeanVel(SVPEnd);
%                 % 读取各个观测时刻
%                 Time=OutData(j).ST_TIME(i,:,num);
%                 SecTime=Calc_Annual_Second([2019,Time]);
%                 ST=SecTime/3600;
%                 ObsT=ST-LT;
%                 a=plot(ObsT,VStr-V0,'.r');
%                 hold on
%
%
% %                 Time2=OutData(j).RT_TIME(i,:,num);
% %                 SecTime2=Calc_Annual_Second([2019,Time2]);
% %                 ST2=SecTime2/3600;
% %                 ObsT2=ST2-LT;
% %                 plot(ObsT2,VEnd-V0,'.y');
%                 [Newsvp] = SSSdoubleChange2(SecTime,LSVP,MP_SVP(Num,13:end),KnotTT,LaunchTime);
%                 NewV=MeanVel(Newsvp);
%                 b=plot(ObsT,NewV-V0,'.b');
%
% %                 STHourOfRT=(TStart+i*T-RT)/3600;
% %                 ETHourofRT=STHourOfRT+OutData(j).DoubleTripT2(i,num)/3600;
% %                 [gammerT1]=Generate_gammer(STHourOfRT,mp1(Num,size(OutData(j).Sign,2)*3+1:end),RT,KnotTT);
% %                 [gammerT2]=Generate_gammer(ETHourofRT,mp1(Num,size(OutData(j).Sign,2)*3+1:end),RT,KnotTT);
% %                 % 读取观测时间的时间残差
% %                 dV=(gammerT1+gammerT2)/2*V0;
% %                 b=plot(ObsT,dV,'.b');
% %                 hold on
%
%                 [gammerT1]=Generate_gammer(SecTime,MP_T(Num,size(OutData(j).Sign,2)*3+1:end,1),LaunchTime,KnotTT);
%                 dV=gammerT1*V0;
%                 c=plot(ObsT,dV,'.g');
%                 hold on
%
% %                 [gammerT1]=Generate_gammer(STHourOfRT,mp8(Num,size(OutData(j).Sign,2)*3+1:end,1),RT,KnotTT);
% %                 dV=gammerT1*V0;
% %                 d=plot(ObsT,dV,'.g');
% %                 hold on
% %
% %                 [gammerT1]=Generate_gammer(STHourOfRT,mp8(Num,size(OutData(j).Sign,2)*3+1:end,2),RT,KnotTT);
% %                 dV=gammerT1*V0;
% %                 e=plot(ObsT,dV,'.c');
% %                 hold on
% %
% %                 [gammerT1]=Generate_gammer(STHourOfRT,mp8(Num,size(OutData(j).Sign,2)*3+1:end,3),RT,KnotTT);
% %                 dV=gammerT1*V0;
% %                 f=plot(ObsT,dV,'.m');
% %                 hold on
% %
% %                 [gammerT1]=Generate_gammer(STHourOfRT,mp8(Num,size(OutData(j).Sign,2)*3+1:end,4),RT,KnotTT);
% %                 dV=gammerT1*V0;
% %                 g=plot(ObsT,dV,'*r');
% %                 hold on
%
% %                 [gammerT1]=Generate_gammer(STHourOfRT,mp2(Num,size(OutData(j).Sign,2)*3+1:end,5),RT,KnotTT);
% %                 dV=gammerT1*V0;
% %                 h=plot(ObsT,dV,'*y');
% %                 hold on
%
%             end
%         end
%     end
% %     FigSet.FontSize=12;
% % %     FigSet.Name1=['第',num2str(Num),'次实验加权声速变化'];
% %     FigSet.Name1=['不同解算方法加权声速变化'];
% %     hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% %     hXLabel = xlabel('时间 h','FontSize',FigSet.FontSize);
% %     hYLabel = ylabel('声速变化 m/s','FontSize',FigSet.FontSize);
% %     % 改变坐标轴刻度显示
% %     % set(gca,'XTick',)
% %     FigSet.PaperPosition=[0,0,20,10];
% %     set(gcf, 'PaperPosition', FigSet.PaperPosition);
% %     % 指定figure的尺寸
% %     FigSet.Size=[0,0,30,15];
% %     set(gcf,'unit','centimeters','position',FigSet.Size);
% %     % 改变ylabel离坐标轴的距离
% %     set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% %     %     % 设定图例 名称 字体大小 边框线线宽
% %     %         legend([a,b,c,d,e],{'仿真实际声速','拟合观测时间策略求解声速','施加平滑5后求解声速',...
% %     %             '施加平滑10后求解声速','施加平滑15后求解声速'},'FontSize',FigSet.FontSize,'LineWidth',0.5);
% %     %     legend([a,b,c,d],{'仿真实际声速','拟合声速场策略求解声速','施加平滑25后求解声速',...
% %     %     '施加平滑50后求解声速'},'FontSize',FigSet.FontSize,'LineWidth',0.5);
% %     legend([a,b,c],{'仿真实际声速变化','拟合声速剖面策略声速变化','拟合时间策略声速变化'},...
% %         'FontSize',FigSet.FontSize,'LineWidth',0.5);
%     %     %% 保存
% %     FigSet.Name2=['第',num2str(Num),'次实验加权声速变化'];
% %     savefig(1,FigSet.Name2);
% %     print(gcf,FigSet.Name2,'-r600','-dtiff');
% %
% %      FigSet.Name2=['增添交叉线的实验加权声速变化'];
% %      savefig(1,FigSet.Name2);
% %      print(gcf,FigSet.Name2,'-r600','-dtiff');
% end
%
%
%
% end

%% 有效声速绘制（有效声速的定义：有效声速等于两点之间的几何距离与实际传播时间的比值）
% load('D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\Parameter12_3000_3000_45_300_10-4_BigSmallMi.mat');
% ColorList={'r.','b.','g.','y.'};
% for Num=1
%     figure(1)
%     % 真实有效声速
%     load(['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\BigSmallMi\SimulationData',num2str(1),'\SimulationData',num2str(1),'.mat']);
%     LaunchRT=NeedData.LaunchRT;
%     LaunchTime=Calc_Annual_Second(LaunchRT);
%     LT=LaunchTime/(3600);
%     for i=1:length(TrueOutData)
% 
%         for j=1:size(TrueOutData(i).ST_X,3)
%             % 提取两点之间的真实距离
%             SurSX=TrueOutData(i).ST_X(:,:,j);SurRX=TrueOutData(i).RT_X(:,:,j);
%             FloorMP=Data(i).xx(j,:);
%             for k=1:length(TrueOutData(i).ST_X(:,:,j))
%                 % 有效声速计算
%                 Dis=norm(SurSX(k,:)-FloorMP,2)+norm(SurRX(k,:)-FloorMP,2);
%                 T=TrueOutData(i).DoubleTripT2(k,j);
%                 EV=Dis/T;
%                 % 观测时间确定
%                 Time=OutData(i).ST_TIME(k,:,j);
%                 SecTime=Calc_Annual_Second([2019,Time]);
%                 ST=SecTime/3600;
%                 ObsT=ST-LT;
%                 a=plot(ObsT,EV,ColorList{j});
%                 hold on
%             end
%         end
%     end
%     for DataNum=1:300
%         SVPSX=[ModelT_MP_SVP_OBSData(DataNum).transducer_e0',ModelT_MP_SVP_OBSData(DataNum).transducer_n0',ModelT_MP_SVP_OBSData(DataNum).transducer_u0'];
%         SVPRX=[ModelT_MP_SVP_OBSData(DataNum).transducer_e1',ModelT_MP_SVP_OBSData(DataNum).transducer_n1',ModelT_MP_SVP_OBSData(DataNum).transducer_u1'];
%         LT=ModelT_MP_SVP_OBSData(DataNum).ST(1);
%         for i=1:size(SVPSX,1)
%             NUM=ModelT_MP_SVP_OBSData(DataNum).MTPSign(i);
%             MP=ModelT_MP_SVP(DataNum,NUM:NUM+2);
%             Dis=norm(SVPSX(i,:)-MP,2)+norm(SVPRX(i,:)-MP,2);
%             T=ModelT_MP_SVP_OBSData(DataNum).TT(i);
%             EV=Dis/T;
%             ObsT=(ModelT_MP_SVP_OBSData(DataNum).ST(i)-LT)/3600;
%             b=plot(ObsT,EV,'k.');
%             hold on
%         end
%
%         SVPSX=[ModelT_MP_T_OBSData(DataNum).transducer_e0',ModelT_MP_T_OBSData(DataNum).transducer_n0',ModelT_MP_T_OBSData(DataNum).transducer_u0'];
%         SVPRX=[ModelT_MP_T_OBSData(DataNum).transducer_e1',ModelT_MP_T_OBSData(DataNum).transducer_n1',ModelT_MP_T_OBSData(DataNum).transducer_u1'];
%         LT=ModelT_MP_T_OBSData(DataNum).ST(1);
%         for i=1:size(SVPSX,1)
%             NUM=ModelT_MP_T_OBSData(DataNum).MTPSign(i);
%             MP=ModelT_MP_T(DataNum,NUM:NUM+2);
%             Dis=norm(SVPSX(i,:)-MP,2)+norm(SVPRX(i,:)-MP,2);
%             T=ModelT_MP_T_OBSData(DataNum).TT(i);
%             EV=Dis/T;
%             ObsT=(ModelT_MP_T_OBSData(DataNum).ST(i)-LT)/3600;
%             c=plot(ObsT,EV,'m.');
%             hold on
%         end
%
%
%
%
%     end
%     FigSet.FontSize=12;
%     %     FigSet.Name1=['第',num2str(Num),'次实验加权声速变化'];
%     FigSet.Name1=['不同解算方法加权声速变化'];
%     hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
%     hXLabel = xlabel('时间 h','FontSize',FigSet.FontSize);
%     hYLabel = ylabel('声速变化 m/s','FontSize',FigSet.FontSize);
%     % 改变坐标轴刻度显示
%     % set(gca,'XTick',)
%     FigSet.PaperPosition=[0,0,20,10];
%     set(gcf, 'PaperPosition', FigSet.PaperPosition);
%     % 指定figure的尺寸
%     FigSet.Size=[0,0,30,15];
%     set(gcf,'unit','centimeters','position',FigSet.Size);
%     % 改变ylabel离坐标轴的距离
%     set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
%     %     % 设定图例 名称 字体大小 边框线线宽
%     %         legend([a,b,c,d,e],{'仿真实际声速','拟合观测时间策略求解声速','施加平滑5后求解声速',...
%     %             '施加平滑10后求解声速','施加平滑15后求解声速'},'FontSize',FigSet.FontSize,'LineWidth',0.5);
%     %     legend([a,b,c,d],{'仿真实际声速','拟合声速场策略求解声速','施加平滑25后求解声速',...
%     %     '施加平滑50后求解声速'},'FontSize',FigSet.FontSize,'LineWidth',0.5);
%     legend([a,b,c],{'仿真实际声速变化','拟合声速剖面策略声速变化','拟合时间策略声速变化'},...
%         'FontSize',FigSet.FontSize,'LineWidth',0.5);
%     %     %% 保存
%     %     FigSet.Name2=['第',num2str(Num),'次实验加权声速变化'];
%     %     savefig(1,FigSet.Name2);
%     %     print(gcf,FigSet.Name2,'-r600','-dtiff');
%     %
%     %      FigSet.Name2=['增添交叉线的实验加权声速变化'];
%     %      savefig(1,FigSet.Name2);
%     %      print(gcf,FigSet.Name2,'-r600','-dtiff');
% end
%% 海面图形查看
% plot(OBSData.transducer_e0,OBSData.transducer_n0,'r.');
% hold on
% plot(MP(1:3:12),MP(2:3:12),'bo')
% axis square
%%
% %----------------观测文件绝对路径-----------------
% OBSFilePath=['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\seafloorNet\SimulationData1\Data.SimulationData1-obs.csv'];
% %----------------声速剖面绝对路径-----------------
% SVPFilePath=['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\seafloorNet\SimulationData1\Data.SimulationData1-svp.csv'];
% %----------------配置参数设置文件-----------------
% INIFilePath=['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\Results\seafloorNet\SimulationData1\Data.SimulationData1-initcfg.ini'];
% [OBSData,SVPData,INIData,MP]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% for i=1:61
%     index=strcmp(OBSData.LN,{['L',num2str(i,'%02d')]});
%     Index=find(index==1);
%     MaxValueST=OBSData.ST(max(Index));MinValueST=OBSData.ST(min(Index));
%     dT(i)=MaxValueST-MinValueST;
%     if i>1
%         dSpanT(i)=MinValueST-OBSData.ST(min(Index)-1);
%     end
% end
% dT=round(dT);dSpanT=round(dSpanT);dSpanT(1)=[];
%%
Color={'ro','b*','k.','ys','g.','c.','m.','k.'};
for j=1:12
    for i=1:4
        a=plot(Data(j).X(:,1,i),Data(j).X(:,2,i),Color{i});% 
        hold on
    end
end
% M01=[-2.5000,1103.4000,-2221.3000];
% M02=[-1049.1000,2.9000,-2214.0000];
% M03=[0.6000,-1090.5000,-2217.4000];
% M04=[1253.5000,6.8000,-2226.6000];
% M11=[-20.8000,1108.0000,-2220.4000];
% M12=[1246.9000,18.5000,-2225.8000];
% M13=[-13.3000,-1075.6000,-2216.5000];
% M14=[-1068.5000,21.6000,-2213.7000];
% x=[M01;M11;M04;M12;M03;M13;M02;M14];
% 
% b=plot(x(:,1),x(:,2),'pr')
% 
% axis square
% FigSet.FontSize=12;
% FigSet.Name1=['仿真KAMS布设图'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hXLabel = xlabel('E(m)','FontSize',FigSet.FontSize);
% hYLabel = ylabel('N(m)','FontSize',FigSet.FontSize);
% % 改变坐标轴刻度显示
% set(gca,'FontSize',FigSet.FontSize,'FontName','Times New Roman');
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% % 设定图例 名称 字体大小 边框线线宽
% legend([a,b,c,d,e],{'仿真实际声速','拟合观测时间策略求解声速','施加平滑5后求解声速',...
%     '施加平滑10后求解声速','施加平滑15后求解声速'},'FontSize',FigSet.FontSize,'LineWidth',0.5);
% %% 保存
% FigSet.Name2=['第',num2str(Num),'次实验加权声速变化'];
% savefig(1,FigSet.Name2);
% print(gcf,FigSet.Name2,'-r600','-dtiff');
% 
% FigSet.Name2=['增添交叉线的实验加权声速变化'];
% savefig(1,FigSet.Name2);
% print(gcf,FigSet.Name2,'-r600','-dtiff');

%%
% LAMBDA=[0,2,4,8,10,15,20];
% for i=1:length(LAMBDA)
% t1(i)=FindLambda_ComposeFunction(LAMBDA(i),OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H);
% end

%%
% dX=[2.107309894	0.032717754	0.006324582	0.018259687	0.00951395	0.008331625	0.005502023	0.007814287	0.008133545	0.007394911	0.012634898	0.01560116	0.005623231	0.002834552	0.010509981	0.013026808	0.006541915	0.010310611	0.007309686	0.013020852];
%
% c=plot(1:20,dX,'or');
% hold on
% d=plot(1:20,dX,'r');
%
%
% FigSet.FontSize=12;
% %     FigSet.Name1=['第',num2str(Num),'次实验加权声速变化'];
% FigSet.Name1=['数值法收敛图'];
% hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
% hXLabel = xlabel('迭代次数','FontSize',FigSet.FontSize);
% hYLabel = ylabel('最大改正量','FontSize',FigSet.FontSize);
% % 改变坐标轴刻度显示
% % set(gca,'XTick',)
% FigSet.PaperPosition=[0,0,20,10];
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺寸
% FigSet.Size=[0,0,30,15];
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 改变ylabel离坐标轴的距离
% set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
% axis([2 20 0 0.05])



