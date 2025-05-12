close all;clear;clc;
load("Center_standra.mat")
time = readmatrix('G:\sdlgxz_github\Dev\Apps\SeafloorDataResolve_v.0.0.2\SeafloorDataResolve\year.xlsx');  % 年月日表格

Wildcard = '\*';
StnName  = 'MYGI';
StnPath2  = 'D:\GARPOS(用于GNSS声学海底定位的分析工具)\data_Tohoku2011-2020\';  % 日本原始数据路径
% 观测文件目录
ObsPath  = [StnPath2,'obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 配置文件目录
ConfPath = [StnPath2,'initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);
% 日本解算结果文件目录
JapSolPath = [StnPath2,'single-default\',StnName];
JapSolTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,JapSolPath,JapSolTag);

for m = 1:length(time)
    t(m,1) = datenum(time(m,1),time(m,2),time(m,3));
end
for j = 1:35
    try
    iJapSolFile  = FileStruct.SubFileList{4,j};
    JapSol        = ReadNSinex(iJapSolFile);
    x0s           = Extraction_x0(JapSol);
%     E(j,:) = mean(x0s(1:3:end));
%     N(j,:) = mean(x0s(2:3:end));
%     U(j,:) = mean(x0s(3:3:end));
    E_JapJap(j,:) = mean(x0s(1:3:end));
    N_JapJap(j,:) = mean(x0s(2:3:end));
    U_JapJap(j,:) = mean(x0s(3:3:end));

%     load(['D:\Github\Dev2\Dev\Apps\SeafloorDataResolve_v.0.0.2\SeafloorDataResolve\单层模型_gamma_BSpan_30\',num2str(j),'.mat'],'ModelT_MP_T')  % 解算结果路径
%     Positing = ModelT_MP_T(1:length(x0s)) - x0s;
%     E(j,:) = mean(Positing(1:3:end));
%     N(j,:) = mean(Positing(2:3:end));
%     U(j,:) = mean(Positing(3:3:end));

    load(['G:\sdlgxz_github\Dev\Apps\SeafloorDataResolve_v.0.0.2\四公共一局部_30\',num2str(j),'.mat'],'ModelT_MP_T')
    %% 读取
%     filename = 'C:\Users\86178\Desktop\数据处理统计2.xlsx';
%     sheet = 2;
%     xlRange = 'C6:Z40';
%     ModelT_MP_T = xlsread(filename,sheet,xlRange);
    Positing_Jap = ModelT_MP_T(1:length(x0s));%- x0s
    E_Jap(j,:) = mean(Positing_Jap(1:3:end));
    N_Jap(j,:) = mean(Positing_Jap(2:3:end));
    U_Jap(j,:) = mean(Positing_Jap(3:3:end));

%     
    catch
        continue 
    end
end

Center_JapJap = [E_JapJap N_JapJap U_JapJap];
Center_Jap = [E_Jap N_Jap U_Jap];
Center_Jap(8,:)=[0,0,0];Center_JapJap(8,:)=[0,0,0];
Center_Jap(34,:)=[0,0,0];Center_JapJap(34,:)=[0,0,0];
% Center = [E N U];
% JapPro_Jap = [E,N,U];
dCenter_JapJap = Center_JapJap - Center_standra;
dCenter_Jap = Center_Jap - Center_standra;
% dCenter_JapJap(8,:)=[0,0,0];dCenter_Jap(8,:)=[0,0,0];
% dCenter_JapJap(34,:)=[0,0,0];dCenter_Jap(34,:)=[0,0,0];
ans = Center_Jap - Center_JapJap;
% dCenter = Center - Center_standra;
% dJap = JapPro_100d - JapPro_Jap;
%%
subplot(3,1,1)
plot(t,dCenter_JapJap(:,1),'r-*')
hold on;grid on;
plot(t,dCenter_Jap(:,1),'b-+')
% plot(t(35),dCenter_Jap(35,1),'r-*')
% plot(t(1:7),Center(1:7,1),'b-+')
% plot(t(9:33),Center(9:33,1),'b-+')
% plot(t(35),Center(35,1),'b-+')
dateaxis('x',2);
ylabel('E(m)')
legend('日本程序','我们程序')
set(gca,'FontSize',8,'FontWeight','bold');
set(get(gca,'XLabel'),'FontSize',12,'FontWeight','bold');
set(get(gca,'YLabel'),'FontSize',12,'FontWeight','bold');

subplot(3,1,2)
plot(t,dCenter_JapJap(:,2),'r-*')
hold on;grid on;
plot(t,dCenter_Jap(:,2),'b-+')
% plot(t(35),dCenter_JapJap(35,2),'r-*')
% plot(t(1:7),Center(1:7,2),'b-+')
% plot(t(9:33),Center(9:33,2),'b-+')
% plot(t(35),Center(35,2),'b-+')
dateaxis('x',2);
ylabel('N(m)')
set(gca,'FontSize',8,'FontWeight','bold');
set(get(gca,'XLabel'),'FontSize',12,'FontWeight','bold');
set(get(gca,'YLabel'),'FontSize',12,'FontWeight','bold');

subplot(3,1,3)
plot(t,dCenter_JapJap(:,3),'r-*')
hold on;grid on;
plot(t,dCenter_Jap(:,3),'b-+')
% plot(t(35),dCenter_JapJap(35,3),'r-*')
% plot(t(1:7),Center(1:7,3),'b-+')
% plot(t(9:33),Center(9:33,3),'b-+')
% plot(t(35),Center(35,3),'b-+')
dateaxis('x',2);
xlabel('Month/Day/Year')
ylabel('U(m)')
set(gca,'FontSize',8,'FontWeight','bold');
set(get(gca,'XLabel'),'FontSize',12,'FontWeight','bold');
set(get(gca,'YLabel'),'FontSize',12,'FontWeight','bold');
sgtitle('网解：一局部四公共   BSpan:40');