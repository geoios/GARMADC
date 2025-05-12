function [SurData,NeedData,P,C] = ErrorCoefficient2(Sur,SF,FA,Cum) %
% 正多边形参数（中心坐标X、Y、边数、外接圆半径、旋转角度）(可更改参数)
for i=1:1:4
    P(i,:)=[0,0,4,SF/2,pi/4];
end

% 要求由于声速剖面时间范围（2019.7.13.21:30:17——2019.7.15.13:18:26），因此起止时间应在其内。
% % 圆形（中心坐标XY，半径，角速度，角加速度，间隔时间，初始时间，结束时间，偏转角度）(可更改参数)
% l=24;
% T=22*3600+10*60+37.5;
% for i=1:1:1
%     C(i,:)=[0,0,1000,2*pi/(l*3600),0,5*60,194*24*60*60+T,194*24*60*60+l*3600+T,0];
% end

% 玫瑰形（中心坐标XY，包络半径，形状参数，角速度，角加速度，间隔时间，初始时间，结束时间，偏转角度）(可更改参数)
% l=0.5;
% T=1800*1;
% for i=1:5
%     C(i,:)=[0,0,2.5*1000,2,2*pi/(l*3600),0,5,195*24*3600+T,195*24*3600+l*3600+T,0]+[0,0,0,0,0,0,0,l*(i-1)*3600,l*(i-1)*3600,0];
% end

% 螺旋形（中心坐标XY，初始半径，角速度，角加速度，初始螺距，螺距增长速度，螺距增长加速度，间隔时间，初始时间，结束时间，偏转角度）(可更改参数)
% for i=1:1:6
%     C(i,:)=[0,0,500,pi/1800,0,50,0,0,5,195*24*3600,195*24*3600+3600,0]+[0,0,50,0,0,0,0,0,0,(i-1)*3600,(i-1)*3600,0];
% end

% 线段（中心坐标XY，速度，加速度，间隔时间，初始时间，结束时间，偏转角度）    (可更改参数)
T=22*3600+11*60+37.5;
TimeNum=1800;TNum=20;
V1=Sur*sqrt(2)/TimeNum;
XSide1=Sur*sin((180+45+FA)*pi/180);YSide1=Sur*cos((180+45+FA)*pi/180);
XSide2=Sur*sin((90+45+FA)*pi/180);YSide2=Sur*cos((90+45+FA)*pi/180);
XSide3=Sur*sin((45+FA)*pi/180);YSide3=Sur*cos((45+FA)*pi/180);
XSide4=Sur*sin((-45+FA)*pi/180);YSide4=Sur*cos((-45+FA)*pi/180);
XSide5=Sur*sin((225+FA)*pi/180);YSide5=Sur*cos((225+FA)*pi/180);
XSide6=Sur*sin((90+FA)*pi/180);YSide6=Sur*cos((90+FA)*pi/180);
XSide7=Sur*sin((-45+FA)*pi/180);YSide7=Sur*cos((-45+FA)*pi/180);
XSide8=Sur*sin((180+FA)*pi/180);YSide8=Sur*cos((180+FA)*pi/180);
V2=2*Sur/TimeNum;
C=[ XSide1,YSide1,V1,0,TNum,194*24*3600+T,194*24*3600+TimeNum+T,90+FA
    XSide2,YSide2,V1,0,TNum,194*24*3600+TimeNum+T,194*24*3600+2*TimeNum+T,0+FA
    XSide3,YSide3,V1,0,TNum,194*24*3600+2*TimeNum+T,194*24*3600+3*TimeNum+T,270+FA
    XSide4,YSide4,V1,0,TNum,194*24*3600+3*TimeNum+T,194*24*3600+4*TimeNum+T,180+FA];
%     XSide1/2,YSide1/2,V1/2,0,TNum,194*24*3600+4*TimeNum+T,194*24*3600+5*TimeNum+T,90+FA
%     XSide2/2,YSide2/2,V1/2,0,TNum,194*24*3600+5*TimeNum+T,194*24*3600+6*TimeNum+T,0+FA
%     XSide3/2,YSide3/2,V1/2,0,TNum,194*24*3600+6*TimeNum+T,194*24*3600+7*TimeNum+T,270+FA
%     XSide4/2,YSide4/2,V1/2,0,TNum,194*24*3600+7*TimeNum+T,194*24*3600+8*TimeNum+T,180+FA
    %     XSide5,YSide5,V1,0,TNum,194*24*3600+0*TimeNum+T,194*24*3600+1*TimeNum+T,90
    %     Side,-Side,V1,0,TNum,194*24*3600+1*TimeNum+T,194*24*3600+2*TimeNum+T,0
    %     Side,Side,V1,0,TNum,194*24*3600+2*TimeNum+T,194*24*3600+3*TimeNum+T,270
    %     XSide6,YSide6,V1,0,TNum,194*24*3600+3*TimeNum+T,194*24*3600+4*TimeNum+T,180
%     XSide5,YSide5,V2,0,TNum,194*24*3600+4*TimeNum+T,194*24*3600+5*TimeNum+T,45+FA
%     XSide6,YSide6,V2,0,TNum,194*24*3600+5*TimeNum+T,194*24*3600+6*TimeNum+T,270+FA
%     XSide7,YSide7,V2,0,TNum,194*24*3600+6*TimeNum+T,194*24*3600+7*TimeNum+T,135+FA
%     XSide8,YSide8,V2,0,TNum,194*24*3600+7*TimeNum+T,194*24*3600+8*TimeNum+T,FA];
n=size(P,1);
% 声速剖面相关
%%%%%%%%%%%%%%%%%%%%%%%原始声速剖面导入部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('SVPX.mat');load('SVP1X.mat');load('SVP2X.mat');load('SVP3X.mat');
load('SVPS.mat');load('SVP1S.mat');load('SVP2S.mat');load('SVP3S.mat');
PF{1} = SVPX;PF{2} = SVPS;PF{3} = SVP1X;PF{4} = SVP1S;
PF{5} = SVP2X;PF{6} = SVP2S;PF{7} = SVP3X;PF{8} = SVP3S;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NeedData.Pf=PF;NeedData.filename='ProfileData.mat'; % 原始声速剖面及其信息导入
NeedData.Step=10;                                   % 预处理分层间隔
NeedData.AssignSpan=[10:10:200,250:50:550,600:100:900,1000:400:3000,3070]; % 指定SVP分层间隔
%NeedData.LaunchRT=[2019,7,14,17,56,22.5];             % 预处理声速剖面参考时间
NeedData.LaunchRT=[2019,7,13,22,11,37.5];

NeedData.Year=2019;NeedData.MaxH=3075;              % 预处理声速剖面最大深度
% 单层声速剖面模型([标准随机系数项，常数项，线性项，sin振幅项，sin周期项])
NeedData.MonolayerFun=[0,1490,0,3,1/4];
% EOF相对于平均声速剖面声速扰动检验倍数,
NeedData.EOFCheck=1;
% EOF投影值PC添加系统|偶然误差比例系数
NeedData.EOFPCPencent=0;
% EOF投影值PC添加系统|偶然误差
NeedData.EOFPCMistake=[1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0];
% EOF函数(经验正交函数)系数A([标准随机系数项，常数项，线性项，sin振幅项，sin周期项 sin初相 cos振幅项，cos周期项
% cos初相])在周期项上以天为基准，0.75表示0.75天
% NeedData.EOFA={[0,1],[0,0,0,1,1.1],[0,0,0,0,1,0,1,1.1],[0]
%                [0,1],[0,0,1],[0,0,0,1,0.75],[0,0,0,0,1,0,1,0.75]
%                [0,1],[0,0,1],[0,0,0,1,0.75],[0,0,0,0,1,0,1,0.75]
%                [0,1],[0,0,1],[0,0,0,1,0.75],[0,0,0,0,1,0,1,0.75]
%                [0,1],[0,0,1],[0],[0]};

for i=1:5
    NeedData.EOFA{i,1}=[0,0,0,1,1];
    NeedData.EOFA{i,2}=[0,0,0,1,1/2,pi];
    NeedData.EOFA{i,3}=[0,0,0,1,1/4,pi];
    NeedData.EOFA{i,4}=[0,0,0,1,1/8];
    NeedData.EOFA{i,5}=[0,0,0,1,1/24,pi];
    NeedData.EOFA{i,6}=[0,0,0,1,1/48,pi];
    NeedData.CoefficientMatrix(:,i)=[3;2;1;0.5;0.75;0.5];
end

% 粗差添加位置
% 发射时刻([月,日,时,分,秒,X,Y,Z,Heading,Pitch,Roll])
NeedData.STMistake=[6,7,8,9,10,11];
% 接收时刻([月,日,时,分,秒,标号,双程观测时间/2,X,Y,Z,Heading,Pitch,Roll])
NeedData.RTMistake=[7,8,9,10,11,12,13];
% 按比例随机添加粗差
NeedData.EporchPencent=0.00;
% 比例粗差形式([标准随机系数项，常数项])
NeedData.PencentMistake=[0,0;0,0;0,0];

% 指定发射时刻([月,日,时,分,秒,X,Y,Z,Heading,Pitch,Roll])
NeedData.STAMistake=[6,7,8,9];
% 指定接受时刻([月,日,时,分,秒,标号,双程观测时间/2,X,Y,Z,Heading,Pitch,Roll])
NeedData.RTAMistake=[7,8,9,10,11];
% 指定历元添加(胞元数组（行数:测段数，列数:发射、接受时刻）数组（行数:海底点数，列数:历元数）)
for i=1:1:n
    for j=1:2
        EporchAssign{i,j}=[1;1;1;1;1];
    end
end
NeedData.EporchAssign=EporchAssign;
% 指定历元粗差形式(胞元数组（行数:测段数，列数:发射、接受时刻）数组（行数:时间、坐标、姿态，列数:[标准随机系数项，常数项]）)
for i=1:1:n
    for j=1:2
        AssignMistake{i,j}=[0,0,0;0,0,0;0,0,0];
    end
end
NeedData.AssignMistake=AssignMistake;
% 海面图形高程、姿态角生成、偶然|系统误差添加
for i=1:size(P,1)
    % 海底点高程
    SurData(i).h=[0,-3000,0];
    % 海面高程运动轨迹([标准随机系数项，常数项，线性项，sin振幅项，sin周期项 sin初相 cos振幅项，cos周期项 cos初相])
    for j=1:1:n
        H(j,:)=[0,-5,0];
    end
    SurData(i).H=H;
    % 海底测站观测间隔
    SurData(i).TSecond=4;                                                   %%修改
    % 海面姿态角运动轨迹
    SurData(i).AttitudeFun=[0,0.01,0
        0,0.01,0
        0,0.01,0];
    %声速剖面模式选择（0:平均声速剖面。1:EOF内插声速剖面。2:观测时刻常声速，不同观测时刻声速不同）
    SurData(i).SVPRandom=1;
    % 误差系数([标准随机系数项，常数项，线性项，sin振幅项，sin周期项])
    % GNSS天线误差
    SurData(i).CoordianteError=[0.05;0.05;0.10];%[0;0;0]
    % 传播时间误差
    SurData(i).TimeError=[5*10^-5,0];%[0,0];
    % 姿态角误差
    SurData(i).AttitudeError=[0;0;0];%[10^-3;10^-3;10^-3]
    % 臂长参数误差
    SurData(i).ATDError=[0;0;0];
    % 海底坐标点误差
    SurData(i).SolidTideError=[0;0;0];
    % 臂长参数
    SurData(i).Forward= 1.5547;SurData(i).Rightward=-1.2690;SurData(i).Downward=13.7295;%
    % 硬件延迟提取
    SurData(i).HardwareDelay=SurData(i).TimeError(2);
    SurData(i).TimeError(2)=0;
end
% 数据保存地址            %% 同名文件夹大小写不敏感
NeedData.SaveAddress=['Results\BigSquare_4_1\Inch',num2str(Sur),'_',num2str(SF),'_',num2str(FA),'\'];%
% 数据输出格式            %% 1：海面图形保存格式；2：海面浮标保存格式
NeedData.model=1;
% 完善判断文件是否存在，如果存在删掉重建，不存在，创建
str=['.\',NeedData.SaveAddress(1:end-1)];
% str=[NeedData.SaveAddress(1:end-1)];
if ~exist(str,'dir')
    mkdir(str)
    oldpath=path;
    path(oldpath,str)
% else
%     rmdir(str,'s') %该删除不经过回收站，慎重使用
%     mkdir(str)
%     oldpath=path;
%     path(oldpath,str)
end
end
% %----------------观测文件绝对路径-----------------
% OBSFilePath=['D:\GARPOS(用于GNSS声学海底定位的分析工具)\data_Tohoku2011-2020\obsdata\KAMS\KAMS.1204.meiyo_m4-obs.csv'];
% %----------------声速剖面绝对路径-----------------
% SVPFilePath=['D:\GARPOS(用于GNSS声学海底定位的分析工具)\data_Tohoku2011-2020\obsdata\KAMS\KAMS.1204.meiyo_m4-svp.csv'];
% %----------------配置参数设置文件-----------------
% INIFilePath=['D:\GARPOS(用于GNSS声学海底定位的分析工具)\data_Tohoku2011-2020\initcfg\KAMS\KAMS.1204.meiyo_m4-initcfg.ini'];
% [OBSData]=ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
% for i=1:56
%     index=strcmp(OBSData.LN,{['L',num2str(i,'%02d')]});
%     Index=find(index==1);
%     MaxValueST=OBSData.ST(max(Index));MinValueST=OBSData.ST(min(Index));
%     dT(i)=MaxValueST-MinValueST;
%     if i>1
%         dSpanT(i)=MinValueST-OBSData.ST(min(Index)-1);
%     end
% end
% for i=1:8
% NewC=[XSide8,YSide8,V2((i-1)*7+2),0,TNum,194*24*3600+TimeNumSum((i-1)*7+1)+TimeSpanSum((i-1)*7+1)+T,194*24*3600+TimeNumSum((i-1)*7+2)+TimeSpanSum((i-1)*7+1)+T,180
%     XSide6,-YSide6,V2((i-1)*7+3),0,TNum,194*24*3600+TimeNumSum((i-1)*7+2)+TimeSpanSum((i-1)*7+2)+T,194*24*3600+TimeNumSum((i-1)*7+3)+TimeSpanSum((i-1)*7+2)+T,45
%     -XSide7,YSide7,V2((i-1)*7+4),0,TNum,194*24*3600+TimeNumSum((i-1)*7+3)+TimeSpanSum((i-1)*7+3)+T,194*24*3600+TimeNumSum((i-1)*7+4)+TimeSpanSum((i-1)*7+3)+T,270
%     XSide5,-YSide5,V2((i-1)*7+5),0,TNum,194*24*3600+TimeNumSum((i-1)*7+4)+TimeSpanSum((i-1)*7+4)+T,194*24*3600+TimeNumSum((i-1)*7+5)+TimeSpanSum((i-1)*7+4)+T,135
%
%     XSide2,YSide2,V1((i-1)*7+6),0,TNum,194*24*3600+TimeNumSum((i-1)*7+5)+TimeSpanSum((i-1)*7+5)+T,194*24*3600+TimeNumSum((i-1)*7+5)+TimeNum((i-1)*7+6)/4+TimeSpanSum((i-1)*7+5)+T,270+FA
%     XSide1,YSide1,V1((i-1)*7+6),0,TNum,194*24*3600+TimeNumSum((i-1)*7+5)+TimeNum((i-1)*7+6)/4+TimeSpanSum((i-1)*7+5)+T,194*24*3600+TimeNumSum((i-1)*7+5)+TimeNum((i-1)*7+6)/4*2+TimeSpanSum((i-1)*7+5)+T,0+FA
%     XSide4,YSide4,V1((i-1)*7+6),0,TNum,194*24*3600+TimeNumSum((i-1)*7+5)+TimeNum((i-1)*7+6)/4*2+TimeSpanSum((i-1)*7+5)+T,194*24*3600+TimeNumSum((i-1)*7+5)+TimeNum((i-1)*7+6)/4*3+TimeSpanSum((i-1)*7+5)+T,90+FA
%     XSide3,YSide3,V1((i-1)*7+6),0,TNum,194*24*3600+TimeNumSum((i-1)*7+5)+TimeNum((i-1)*7+6)/4*3+TimeSpanSum((i-1)*7+5)+T,194*24*3600+TimeNumSum((i-1)*7+6)+TimeSpanSum((i-1)*7+5)+T,180+FA
%
%     XSide5,YSide5,V1((i-1)*7+7),0,TNum,194*24*3600+TimeNumSum((i-1)*7+6)+TimeSpanSum((i-1)*7+6)+T,194*24*3600+TimeNumSum((i-1)*7+6)+TimeNum((i-1)*7+7)/4+TimeSpanSum((i-1)*7+6)+T,0
%     -Side,Side,V1((i-1)*7+7),0,TNum,194*24*3600+TimeNumSum((i-1)*7+6)+TimeNum((i-1)*7+7)/4+TimeSpanSum((i-1)*7+6)+T,194*24*3600+TimeNumSum((i-1)*7+6)+TimeNum((i-1)*7+7)/4*2+TimeSpanSum((i-1)*7+6)+T,90
%     Side,Side,V1((i-1)*7+7),0,TNum,194*24*3600+TimeNumSum((i-1)*7+6)+TimeNum((i-1)*7+7)/4*2+TimeSpanSum((i-1)*7+6)+T,194*24*3600+TimeNumSum((i-1)*7+6)+TimeNum((i-1)*7+7)/4*3+TimeSpanSum((i-1)*7+6)+T,180
%     -XSide6,-YSide6,V1((i-1)*7+7),0,TNum,194*24*3600+TimeNumSum((i-1)*7+6)+TimeNum((i-1)*7+7)/4*3+TimeSpanSum((i-1)*7+6)+T,194*24*3600+TimeNumSum((i-1)*7+7)+TimeSpanSum((i-1)*7+6)+T,270
%
%     XSide1/2,YSide1/2,V1((i-1)*7+8)/2,0,TNum,194*24*3600+TimeNumSum((i-1)*7+7)+TimeSpanSum((i-1)*7+7)+T,194*24*3600+TimeNumSum((i-1)*7+7)+TimeNum((i-1)*7+8)/4+TimeSpanSum((i-1)*7+7)+T,90+FA
%     XSide2/2,YSide2/2,V1((i-1)*7+8)/2,0,TNum,194*24*3600+TimeNumSum((i-1)*7+7)+TimeNum((i-1)*7+8)/4+TimeSpanSum((i-1)*7+7)+T,194*24*3600+TimeNumSum((i-1)*7+7)+TimeNum((i-1)*7+8)/4*2+TimeSpanSum((i-1)*7+7)+T,0+FA
%     XSide3/2,YSide3/2,V1((i-1)*7+8)/2,0,TNum,194*24*3600+TimeNumSum((i-1)*7+7)+TimeNum((i-1)*7+8)/4*2+TimeSpanSum((i-1)*7+7)+T,194*24*3600+TimeNumSum((i-1)*7+7)+TimeNum((i-1)*7+8)/4*3+TimeSpanSum((i-1)*7+7)+T,270+FA
%     XSide4/2,YSide4/2,V1((i-1)*7+8)/2,0,TNum,194*24*3600+TimeNumSum((i-1)*7+7)+TimeNum((i-1)*7+8)/4*3+TimeSpanSum((i-1)*7+7)+T,194*24*3600+TimeNumSum((i-1)*7+8)+TimeSpanSum((i-1)*7+7)+T,180+FA];
% C=[C;NewC];
% end
% Side=Sur;TimeNum=610;TNum=10;V1=(2*Side+100)/TimeNum;C=[];
% for i=1:61
% NewC=[-Side,Side-(i-1)*100,V1,0,TNum,194*24*3600+T+(i-1)*TimeNum,194*24*3600+i*TimeNum+T,45+FA];
% C=[C;NewC];
% end
