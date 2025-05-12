function plotPositDiff(dataMatr,LineType)
%% 函数说明
%功能：画残差声速剖面
%输入：
%输出：
plot(dataMatr(:,1),dataMatr(:,2),LineType,'linew',0.2,'markers',5,'lineWidth',1.5);
%参数设置
xlabel('\fontname{宋体}观测时间\fontname{Times New Roman}(year)');
ylabel('\fontname{Times New Roman}(cm)');

set(gca,'FontSize',12,'Fontname', 'Times New Roman','FontWeight','bold');
set(gca,'linewidth',0.75);
set(gca,'tickdir','in');
grid on;
set(gcf,'Units','centimeter','Position',[5 5 12 8]);
set(0,'defaultfigurecolor','w');
% eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,expoFileName,'.png'')']); 