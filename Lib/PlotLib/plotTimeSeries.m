function plotTimeSeries(t,StnLegend,CenterOffset,CenterLineY)
date1 = [2011,3,11,0,0,0];
date2 = [2012,1,1,0,0,0];

MarkerSize   = 20;
FontSize     = 8;
XYFontSize   = 8;
LineWidth    = 0.75;
LegendSize   = 8;
% StnLegend{1} = Model1;
% StnLegend{2} = Model2;
PointSign1   = {'b.' 'r.' 'g.'};
LineSign2    = {'b-' 'r-' 'g-'};

for i = 1:length(CenterOffset.E(1,:))
    subplot(3,1,1)
    plot(t,CenterOffset.E(:,i),PointSign1{i},'MarkerSize',MarkerSize) 
    hold on;grid on;
    plot(t,CenterLineY.E(:,i),LineSign2{i},'LineWidth',LineWidth,'HandleVisibility','off')
    hold on;grid on;

    subplot(3,1,2)
    plot(t,CenterOffset.N(:,i),PointSign1{i},'MarkerSize',MarkerSize)
    hold on;grid on;
    plot(t,CenterLineY.N(:,i),LineSign2{i},'LineWidth',LineWidth,'HandleVisibility','off')
    hold on;grid on;

    subplot(3,1,3)
    plot(t,CenterOffset.U(:,i),PointSign1{i},'MarkerSize',MarkerSize) 
    hold on;grid on;
    plot(t,CenterLineY.U(:,i),LineSign2{i},'LineWidth',LineWidth,'HandleVisibility','off')
    hold on;grid on;
end

legend(StnLegend,'Position',[0.71 0.88 0.01 0.01],'FontSize',LegendSize,'FontName','Arial');

subplot(3,1,1);
ylim([-0.5 0.5])
fill([datenum(date1) datenum(date1) datenum(date2) datenum(date2)],[0.5 -0.5 -0.5 0.5],'k','facealpha',0.1,'EdgeColor','none','HandleVisibility','off');
set(gca,'FontSize',XYFontSize,'FontWeight','bold');
dateaxis('x',10)
%xlabel('Date (Year)','FontWeight','bold','FontSize',FontSize,'FontName','Arial');
ylabel('{\itE} (m)','FontWeight','bold','FontSize',FontSize,'FontName','Arial');

subplot(3,1,2);
ylim([-0.5 0.5])
fill([datenum(date1) datenum(date1) datenum(date2) datenum(date2)],[0.5 -0.5 -0.5 0.5],'k','facealpha',0.1,'EdgeColor','none','HandleVisibility','off');
set(gca,'FontSize',XYFontSize,'FontWeight','bold');
dateaxis('x',10)
%xlabel('Date (Year)','FontWeight','bold','FontSize',FontSize,'FontName','Arial');
ylabel('{\itN} (m)','FontWeight','bold','FontSize',FontSize,'FontName','Arial');

subplot(3,1,3);
ylim([-0.5 0.5])
fill([datenum(date1) datenum(date1) datenum(date2) datenum(date2)],[0.5 -0.5 -0.5 0.5],'k','facealpha',0.1,'EdgeColor','none','HandleVisibility','off');
set(gca,'FontSize',XYFontSize,'FontWeight','bold');
dateaxis('x',10)
xlabel('Date','FontWeight','bold','FontSize',FontSize,'FontName','Arial');
ylabel('{\itU} (m)','FontWeight','bold','FontSize',FontSize,'FontName','Arial');

% set(gcf,'position',[100 10 800 800])
set(gcf,'Units','centimeter','Position',[5 5 12 12]);

% % StorgePath = ['E:\办公室电脑备份\桌面\协助研究\未完成\静态声呐延迟文章实验补充\24.07.13_Result\Fig\虚拟中心点偏移量时序图(2011-2020).jpg'];
% % print(gcf,StorgePath,'-r600','-dtiff');



