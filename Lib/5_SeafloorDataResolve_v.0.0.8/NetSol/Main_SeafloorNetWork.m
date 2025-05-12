clc
clear all

%% ++++++++++++ 数据目录定义 +++++++++++
PublicPath = 'G:\New Journal\CirData\FUKU\';
SerialInf  = 'FUKU.2006.meiyo_m5';
ObsPath    = [PublicPath,'Obs',SerialInf,'-obs','\' SerialInf,'-obs.GNSSA'];
SVPPath    = [PublicPath,'Obs',SerialInf,'-svp','\' SerialInf,'-svp.SVP'];
JapPath    = [PublicPath,'\JapSol\',SerialInf '-res.dat'];
ConfigPath = [PublicPath,'\Config\',SerialInf '-initcfg.ini'];

%% ++++++++++++ 数据信息获取 +++++++++++
% 读取配置信息
Config = ReadNSinex(ObsPath);
ConfigInf = Config.Header;
% 时间信息获取
DataUTC = ConfigInf.DateUTC;
DataUTC = str2num(strrep(DataUTC,'-',','));
% 测段信息获取
SessionInf = str2num(ConfigInf.Sessions);  
SesNum = length(SessionInf);
% 点号信息获取
SPNoInf = str2num(ConfigInf.Site_No);  
SPNoNum = length(SPNoInf);

SelCol = [3 4 5];
JapCol = [7 8 9];

for i = 1:SesNum
    ObsPath = [PublicPath,'Obs',SerialInf,'-obs','\' SerialInf,'-obs','.GNSSA'];
%     ObsPath = [PublicPath,'Obs',SerialInf,'-obs','\' SerialInf,'-obs','_S_',num2str(i),'_L_Inf_M_Inf','.GNSSA'];
    SVPPath = [PublicPath,'Obs',SerialInf,'-svp','\' SerialInf,'-svp.SVP'];
    JapPath = [PublicPath,'\JapSol\',SerialInf '-res.dat']; 
%     JapPath = ConfigPath;
    JapSol        = ReadNSinex(JapPath);
    x0s           = Extraction_x0(JapSol);
    x_Jap         = [x0s(:,2),x0s(:,1),x0s(:,3)];
    [AllData,ObsData] = StandardData(ObsPath);
    % [臂长参数]（坐标转换：GNSS天线—>换能器）
    ArmLen   = AllData.Header.Arm_Len;
    %% ++++++++++++ 数据解算 ++++++++++++
    [SolRes,Delay,dL_Com_Rob,MeanTime,ResOutput,RecTime] = SolNetwork(ObsPath,SVPPath,ObsData,ArmLen,x_Jap);
    Times(i) = MeanTime/3600/24;         % 测段时间
    SelLocInf = SolRes(:,SelCol);
    JapLocInf = SolRes(:,JapCol);
    jSelRes = [];
    jJapRes = [];
    for j = 1:SPNoNum
        jSelRes = [jSelRes,SelLocInf(j,:)];
        jJapRes = [jJapRes,JapLocInf(j,:)];
    end
    SelRes(i,:) = jSelRes;
    JapRes(i,:) = jJapRes;
    SesTime(:,i) = RecTime;

    sigma(i) = ResOutput.Sigma;
end

SelLocMean = mean(SelRes);
SelLocDiff = SelRes - SelLocMean;
NLocDiff = SelLocDiff(:,1:3:end);
ELocDiff = SelLocDiff(:,2:3:end);
ULocDiff = SelLocDiff(:,3:3:end);

solres=[SolRes(:,3:5),SolRes(:,7:9),SolRes(:,11:13)];
%%%%%%%%%%%%%%%%%%%%% 绘图部分 %%%%%%%%%%%%%%%%%%%%%%
MedianTime = (sum(SesTime)/2)';
% 时间转换
ReferenceTime = [DataUTC(2) DataUTC(3) 0 0 0];
TimeNum = size(MedianTime,1);
for i = 1:TimeNum
    Date = Sec2Date(ReferenceTime,MedianTime(i));
    x(i,:) = datenum(DataUTC(2),Date(1),Date(2),Date(3),Date(4),Date(5));
    RecordData(i,:) = Date;
end

sign1  ={'r-*' 'g-^' 'b-h', 'm-o','r--*' 'g--^' 'b--h', 'm--o'};
ColPans1 = {[1 0 0]
           [0 1 0]
           [0 0 1]
           [1 0 1]
           [1 0 0]
           [0 1 0]
           [0 0 1]
           [1 0 1]};                
%% 误差时序图 +++++++++++++++++++++++++  
figure(1)
for i = 1:SPNoNum
    subplot(3,1,1)
    hold on
    plot(x,NLocDiff(:,i),sign1{i},'LineWidth',1,'MarkerEdgeColor',ColPans1{i})

    subplot(3,1,2)
    hold on
    plot(x,ELocDiff(:,i),sign1{i},'LineWidth',1,'MarkerEdgeColor',ColPans1{i})
    
    subplot(3,1,3)
    hold on
    plot(x,ULocDiff(:,i),sign1{i},'LineWidth',1,'MarkerEdgeColor',ColPans1{i})
end

for j = 1:SPNoNum
    StnLegend{j} = ['M',num2str(SPNoInf(j))];
end

legend(StnLegend,'orientation','horizontal','Location','best','NumColumns',4, ...
'Position',[0.324166669183307 0.925073570748209 0.395555550522273 0.0726666646798452],'FontSize',12)

subplot(3,1,1);
set(gca,'FontSize',16);grid on;
dateaxis('x',15)
xlabel('Date (Hour/Day)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('N (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');

subplot(3,1,2);
set(gca,'FontSize',16);grid on;
dateaxis('x',15)
xlabel('Date (Hour/Day)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('E (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');

subplot(3,1,3);
set(gca,'FontSize',16);grid on;
dateaxis('x',15)
xlabel('Date (Hour/Day)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('U (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');

set(gcf,'position',[80 100 550 600])

StorgePath = ['D:\Github\Dev\APP-PFP\WorkSpace\MYGI\FigRes\NetWorkSerial_Best','.jpg'];
print(gcf,StorgePath,'-r600','-dtiff');

% %% 误差直方图 +++++++++++++++++++++++++ 
% [mm,nn] = size(NLocDiff);
% TotalNum = mm * nn;
% NLocDiff = reshape(NLocDiff,1,TotalNum);
% ELocDiff = reshape(ELocDiff,1,TotalNum);
% ULocDiff = reshape(ULocDiff,1,TotalNum);
% Rms = [rms(NLocDiff),rms(ELocDiff),rms(ULocDiff)];

% figure(2)
% set(gcf,'position',[80 100 550 600])
% subplot(3,1,1)
% Hist(NLocDiff,10,1,'N')
% subplot(3,1,2)
% Hist(ELocDiff,10,1,'E')
% subplot(3,1,3)
% Hist(ULocDiff,10,1,'U') 
% StorgePath = ['D:\Github\Dev\APP-PFP\WorkSpace\MYGI\FigRes\Net_Hist_3','.jpg'];
% print(gcf,StorgePath,'-r600','-dtiff');