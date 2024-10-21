function plotDistCorr(dataMatr,lineType)
%% 函数说明
%功能：画误差曲线
%% 功能代码
plot(dataMatr(:,1),dataMatr(:,2),lineType,'lineWidth',0.75);
xlabel('Incidence angle (\circ)');
ylabel('Distance error (m)')
%参数设置
set(gca,'FontSize',8,...
        'Fontname','Arial',...
        'FontWeight','bold',...
        'linewidth',0.75,...
        'tickdir','in');
set(gcf,'Units','centimeter','Position',[5 5 8 6]);
set(0,'defaultfigurecolor','w');

