% close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

%% 常声速声线gammar1、2检验
PF(:,1)=[0.0,10.0,20.0,30.0,40.0,50.0,60.0,70.0,80.0,90.0,100.0,110.0,120.0,130.0,140.0,150.0,160.0,170.0,180.0,190.0,200.0,...
    250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,700.0,800.0,900.0,1000.0,1400.0,1800.0,2200.0,2600.0,3000.0,3070.0];
PF(:,2) = [1544.5020000000,1544.5829470000,1544.7515010000,1544.9000150000,1544.1861270000,1535.4117650000,1531.0164070000,...
    1526.2005470000,1522.2396850000,1519.2934510000,1516.8302570000,1515.4464760000,1514.0708339999,1512.2235240000,1510.6631180000,1509.5828480000,...
    1508.4710070000,1507.5544210000,1507.2301790000,1506.40326400000,1505.7738200000,1501.2562950000,1498.2653680000,1496.2434610000,1494.4406810000,...
    1492.3007280000,1491.4129269999,1489.7511430000,1489.1623710000,1486.8847740000,1485.6419500000,1484.80687900000,1484.5754350000,1484.9972920000,...
    1489.5930640000,1495.4919220000,1501.8969270000,1508.0994730000,1509.1849180000];

% 数值积分
PF = PFGrad(PF,2,1);
SVPLayerNum = size(PF,1);
syms U
Value_gammar1 = 0;Value_gammar2 = 0;
for i = 1: SVPLayerNum -1
%     C = (PF(i,2))^-2;
%     Value_gammar1  = Value_gammar1 + double(int(C,PF(i,1),PF(i+1,1)));
    CU = U * (PF(i,2))^-2;
    Value_gammar2  = Value_gammar2 + double(int(CU,PF(i,1),PF(i+1,1)));
end

% 解析公式
Analysis_gammar1 = 0;Analysis_gammar2 = 0;
for i = 1: SVPLayerNum -1
    U0 = PF(i,1);U1 = PF(i+1,1);C0 = PF(i,2);
%     SubGamma1 = (U1 - U0)/C0^2;
%     Analysis_gammar1  = Analysis_gammar1 + SubGamma1;
    SubGamma2 = (U1^2 - U0^2)/(2 * C0^2);
    Analysis_gammar2  = Analysis_gammar2 + SubGamma2;
end

% detal_gammar1_cosnt = Analysis_gammar1 - Value_gammar1;
detal_gammar2_cosnt = Analysis_gammar2 - Value_gammar2;



%% 等梯度声线跟踪gammar1、2检验

PF(:,1)=[0.0,10.0,20.0,30.0,40.0,50.0,60.0,70.0,80.0,90.0,100.0,110.0,120.0,130.0,140.0,150.0,160.0,170.0,180.0,190.0,200.0,...
    250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,700.0,800.0,900.0,1000.0,1400.0,1800.0,2200.0,2600.0,3000.0,3070.0];
PF(:,2) = [1544.5020000000,1544.5829470000,1544.7515010000,1544.9000150000,1544.1861270000,1535.4117650000,1531.0164070000,...
    1526.2005470000,1522.2396850000,1519.2934510000,1516.8302570000,1515.4464760000,1514.0708339999,1512.2235240000,1510.6631180000,1509.5828480000,...
    1508.4710070000,1507.5544210000,1507.2301790000,1506.40326400000,1505.7738200000,1501.2562950000,1498.2653680000,1496.2434610000,1494.4406810000,...
    1492.3007280000,1491.4129269999,1489.7511430000,1489.1623710000,1486.8847740000,1485.6419500000,1484.80687900000,1484.5754350000,1484.9972920000,...
    1489.5930640000,1495.4919220000,1501.8969270000,1508.0994730000,1509.1849180000];

PF = PFGrad(PF,2,1);
SVPLayerNum = size(PF,1);


% 数值方法
syms U
Value_gammar1 = 0;Value_gammar2 = 0;
for i = 1: SVPLayerNum -1
    C = (PF(i,2) + PF(i,4) * (U - PF(i,1)))^-2;
    Value_gammar1  = Value_gammar1 + double(int(C,PF(i,1),PF(i+1,1)));
    CU = U * (PF(i,2) + PF(i,4) * (U - PF(i,1)))^-2;
    Value_gammar2  = Value_gammar2 + double(int(CU,PF(i,1),PF(i+1,1)));
end

% 解析方法
Analysis_gammar1 = 0;Analysis_gammar2 = 0;
for i = 1: SVPLayerNum -1
    C0 = PF(i,2);C1 = PF(i+1,2);U0 = PF(i,1);U1 = PF(i+1,1);G0 = PF(i,4);
    SubGamma1 = (U1 - U0)/(C0 * C1);
    Analysis_gammar1  = Analysis_gammar1 + SubGamma1;
    SubGamma2 = G0^-2 * log(C1/C0) - (C0/G0 - U0) * (U1 - U0) * (C0 * C1)^-1;
    Analysis_gammar2  = Analysis_gammar2 + SubGamma2;
end
detal_gammar1_equal = Analysis_gammar1 - Value_gammar1;
detal_gammar2_equal = Analysis_gammar2 - Value_gammar2;



%%
% PF(:,1)=[0.0,10.0,20.0,30.0,40.0,50.0,60.0,70.0,80.0,90.0,100.0,110.0,120.0,130.0,140.0,150.0,160.0,170.0,180.0,190.0,200.0,...
%     250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,700.0,800.0,900.0,1000.0,1400.0,1800.0,2200.0,2600.0,3000.0,3070.0];
% PF(:,2) = [1544.5020000000,1544.5829470000,1544.7515010000,1544.9000150000,1544.1861270000,1535.4117650000,1531.0164070000,...
%     1526.2005470000,1522.2396850000,1519.2934510000,1516.8302570000,1515.4464760000,1514.0708339999,1512.2235240000,1510.6631180000,1509.5828480000,...
%     1508.4710070000,1507.5544210000,1507.2301790000,1506.40326400000,1505.7738200000,1501.2562950000,1498.2653680000,1496.2434610000,1494.4406810000,...
%     1492.3007280000,1491.4129269999,1489.7511430000,1489.1623710000,1486.8847740000,1485.6419500000,1484.80687900000,1484.5754350000,1484.9972920000,...
%     1489.5930640000,1495.4919220000,1501.8969270000,1508.0994730000,1509.1849180000];

PF = SVP;
H = max(abs(MP1(3:3:end)));
Angle = 80;
PF= PFGrad(PF,2,1);
num1=1;
for i = 5:5:Angle
    num2=1;
    for j = 50:50:H
        [~,Y,Z] = RayTracing( PF, i/180*pi, +inf,+inf,j);
        Z0_Ray = Y/Z;
        [~,~,~,~,~,~,RayInf] = InvRayTrace(PF,+inf,Y,Z);
        snellC = RayInf.alfae/RayInf.ce;
        cos_betaList = cos(asin(snellC .* PF(:,2)));
        cos_AvgBeta = sum(cos_betaList.*PF(:,3))/sum(PF(:,3));
        Lambda0(num1,num2) = cos(atan(Z0_Ray))^-1 * cos_AvgBeta;
        num2 =num2 +1;
    end
    num1 = num1 + 1;
end

x=50:50:H;
y=5:5:Angle;
[xx,yy]=meshgrid(x,y);
surf(xx,yy,Lambda0);

FontS = 15; %大小为12pt
FontW = 'bold';  %粗细为加粗 [不加粗用normal或缺省]
az = 50; el = 20; %旋转的角度设置
Length = 20; Width = 15; %设置图片长宽
Start_x = 6; Start_y = 6; %设置图片起始位置
colormap jet; %设置colormap的格式
c = colorbar; %加上色条
c.Label.String = '\fontname{Times New Roman}\bf \it\lambda(u)';
c.Label.FontSize = FontS+3;
FigSet.TitleName = 'Lambda(u)';
FigSet.StorgePath = ['FigResults\',FigSet.TitleName,'.jpg'];
%图像调整
view([az,el]); %设置观察角度
xlim([0,ceil(H/100)*100])
% axis([min(x) max(x) min(y) max(y)... %设置坐标范围
%         min(min(Z)) max(max(Z))]) %这里由于Z是二维需要用两层最值函数
set(gcf,'Units','centimeters','Position',[Start_x Start_y Length Width]); %设置图片大小
%坐标调整（设置为LaTeX文字格式）
L(1) = xlabel('Depth(m)','FontSize',FontS,'FontWeight',FontW,'FontName','Times New Roman');
L(2) = ylabel('Incident angle(°)','FontSize',FontS,'FontWeight',FontW,'FontName','Times New Roman');
L(3) = zlabel('\fontname{Times New Roman}\bf \it\lambda(u)','FontSize',FontS,'FontWeight',FontW,'FontName','Times New Roman');
set(gca,'FontSize',FontS);
% L(4) = title('$z = 1-\sqrt{x^{2}+(y-1)^{2}}$','interpreter','latex','FontSize',FontS,'FontWeight',FontW);
%图像保存
% saveas(Fig,'Example.png'); %保存为.png格式
%eps格式保存：需增加'psc2'不然图像为黑白
%saveas(Fig,'Example.eps','psc2');
print(gcf,FigSet.StorgePath,'-r300','-dtiff');

% 典型入射角度绘图
figure(2)
dq = jet(8);
FigSet.FontSize=18;FigSet.Size=[0,0,20,15];FigSet.PaperPosition=[0,0,20,10];
FigSet.LineType = 'b-';FigSet.lineWidth = 1;FigSet.linewidth = 1;
FigSet.TitleName=['典型入射角的Lambda(t)曲线'];
FigSet.xlabelName = ['\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}'];
FigSet.ylabelName = ['\fontname{Times new roman}{\itLambda(t)}'];
FigSet.legendName = {'10°','20°','30°','40°','50°','60°','70°'};
FigSet.StorgePath = ['FigResults\',FigSet.TitleName,'.tiff'];
num1 = 1;
for i = 10:10:70
    num2=1;Lambda0=[];
    for j = 50:50:3050
        [~,Y,Z] = RayTracing( PF, i/180*pi, +inf,+inf,j);
        Z0_Ray = Y/Z;
        [~,~,~,~,~,~,RayInf] = InvRayTrace(PF,+inf,Y,Z);
        snellC = RayInf.alfae/RayInf.ce;
        cos_betaList = cos(asin(snellC .* PF(:,2)));
        cos_AvgBeta = sum(cos_betaList.*PF(:,3))/sum(PF(:,3));
        Lambda0(num2) = cos(atan(Z0_Ray))^-1 * cos_AvgBeta;
        num2 =num2 +1;
    end
    xvalue = 50:50:3050;
    plot(50:50:3050,Lambda0,'-','color',dq(num1,:),'lineWidth',FigSet.lineWidth);
    hold on 
    num1 = num1 + 1;
end
% 设定标题
hTitle = title(FigSet.TitleName,'FontSize',FigSet.FontSize);
% 设定坐标轴
hXLabel = xlabel(FigSet.xlabelName);
hYLabel = ylabel(FigSet.ylabelName);
set(gca,'FontSize',FigSet.FontSize,...
    'linewidth',FigSet.linewidth,'FontWeight','bold','tickdir','in');

XLimit = ceil(max(xvalue)/100)*100;
YLimitMax = max(Lambda0) + 0.01;YLimitMin = min(Lambda0) - 0.01;
axis([0 XLimit YLimitMin YLimitMax])

% 指定图窗位置和大小
set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
set(gcf,'unit','centimeters','position',FigSet.Size);
% 图例设置
legend(FigSet.legendName,'FontSize',FigSet.FontSize,...
    'Location','NorthEast','Box','off');

% 图片保存
print(gcf,FigSet.StorgePath,'-r600','-dtiff');




%% 声线跟踪检验
PF(:,1)=[0.0,10.0,20.0,30.0,40.0,50.0,60.0,70.0,80.0,90.0,100.0,110.0,120.0,130.0,140.0,150.0,160.0,170.0,180.0,190.0,200.0,...
    250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,700.0,800.0,900.0,1000.0,1400.0,1800.0,2200.0,2600.0,3000.0,3070.0];
PF(:,2) = [1544.5020000000,1544.5829470000,1544.7515010000,1544.9000150000,1544.1861270000,1535.4117650000,1531.0164070000,...
    1526.2005470000,1522.2396850000,1519.2934510000,1516.8302570000,1515.4464760000,1514.0708339999,1512.2235240000,1510.6631180000,1509.5828480000,...
    1508.4710070000,1507.5544210000,1507.2301790000,1506.40326400000,1505.7738200000,1501.2562950000,1498.2653680000,1496.2434610000,1494.4406810000,...
    1492.3007280000,1491.4129269999,1489.7511430000,1489.1623710000,1486.8847740000,1485.6419500000,1484.80687900000,1484.5754350000,1484.9972920000,...
    1489.5930640000,1495.4919220000,1501.8969270000,1508.0994730000,1509.1849180000];

SurFaceP = [0,0,-5];SeafloorP = [1000,1000,-3000];
PF = PFGrad(PF,2,1);
Data.PF = PF;

[T1,Y,Z,L,~,Iteration,RayInf]= P2PInvRayTrace(SurFaceP,SeafloorP,Data);

YY = norm(SurFaceP(1:2)-SeafloorP(1:2));
[theta,T2]=calc_ray_path(YY,-SeafloorP(3),-SurFaceP(3),Data.PF(:,1),Data.PF(:,2),size(Data.PF,1));

T1-T2
[T,Y,Z,L] = RayTracing( PF, 87/180*pi, +inf,+inf,3000);
Y