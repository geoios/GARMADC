close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

% 测站名称
COMName = 'MYGI.' ;
PosNameList = {'1103','1104','1105','1108','1111','1201','1204','1209','1211','1212','1302','1306',...
    '1309','1311','1401','1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'};

Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = 'D:\GARPOS(用于GNSS声学海底定位的分析工具)\data_Tohoku2011-2020';
% 观测文件目录
ObsPath1  = [StnPath,'\single-default\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath1,IndexTag);
ObsPath2  = [StnPath,'\obsdata\',StnName];
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath2,SvpTag);
% 配置文件目录
ConfPath = [StnPath,'\single-default\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

for ListNum = 1 : FileStruct.FileNum
    figure(ListNum)
    Value =[];
    %% GARPOS 
    OBSFilePath = FileStruct.SubFileList{1,ListNum};
    SVPFilePath = FileStruct.SubFileList{2,ListNum};
    INIFilePath = FileStruct.SubFileList{3,ListNum};
    
    [OBSData,SVPData,INIData,MP1,MPNum]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [~,INIData,SVP] = Ant_ATD_Transducer(OBSData,INIData,SVPData,MP1,MPNum);%
    N_shot=str2double(INIData.Data_file.N_shot);
    index=1;
    for i=1:N_shot
        if strcmp(OBSData.flag{i},'True')
            Value(index)=i;
            index=index+1;
        end
    end
    xvalue=1:N_shot;

    V0 = MeanVel(SVP);
    if ~isempty(Value)
        xvalue(Value)=[];
        OBSData.ResiTT(Value)=[];
    end
    plot(xvalue,OBSData.ResiTT*V0,'LineWidth',1);
    hold on
    
    ValueRMS(1)=rms(OBSData.ResiTT*V0);
    
   
    
    %% 指数形约束
    MatList={['D:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\MYGI\',num2str(ListNum),'.mat'],...
        ['G:\github\GARPOS-Study\SSS\Simulation_ResolveFunction\MYGI\',num2str(ListNum),'.mat']};
    
    load(MatList{1});
     if ~isempty(Value)
    ModelT_MP_SVP_OBSData.detalT(Value)=[];
     end
    V0 = MeanVel(SVP);
    plot(xvalue,ModelT_MP_SVP_OBSData.detalT*V0,'LineWidth',1);
    ValueRMS(2)=rms(ModelT_MP_SVP_OBSData.detalT*V0);
    hold on
    
    load(MatList{2});
     if ~isempty(Value)
    ModelT_MP_SVP_OBSData.detalT(Value)=[];
     end
    V0 = MeanVel(SVP);
    plot(xvalue,ModelT_MP_SVP_OBSData.detalT*V0,'LineWidth',1);
    ValueRMS(3)=rms(ModelT_MP_SVP_OBSData.detalT*V0);
    hold on
    
    
    
    FigSet.FontSize=18;
    FigSet.Name1=[COMName,PosNameList{ListNum},' 距离残差序列'];
    hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
    
    hXLabel = xlabel('\fontname{宋体}{\it观测历元}\fontname{宋体}{\it(个)}','FontSize',FigSet.FontSize);
    hYLabel = ylabel('\fontname{宋体}{\it距离残差}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
    FigSet.PaperPosition=[0,0,20,10];
    set(gcf, 'PaperPosition', FigSet.PaperPosition);
    % 指定figure的尺寸
    FigSet.Size=[0,0,20,15];
    set(gcf,'unit','centimeters','position',FigSet.Size);
    % 改变ylabel离坐标轴的距离
    set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
    
    h=legend({'GARPOS','指数形约束','浮标建模SVP指数形约束'});
    set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
    
    xlim([0,ceil(N_shot/100)*100])
    set(gca,'Box','on')
end
ValueRMS;