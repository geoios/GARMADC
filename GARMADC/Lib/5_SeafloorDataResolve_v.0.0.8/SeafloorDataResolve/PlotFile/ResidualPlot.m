function  ResidualPlot(X,Y,sigma,FigSet)

%% 绘图
plot(X,Y,FigSet.LineType,'lineWidth',FigSet.lineWidth);
% 设定标题
hTitle = title([FigSet.TitleName,' (Sigma = ',num2str(sigma),')'],'FontSize',FigSet.FontSize);
% 设定坐标轴
hXLabel = xlabel(FigSet.xlabelName);
hYLabel = ylabel(FigSet.ylabelName);
set(gca,'FontSize',FigSet.FontSize,'Fontname', 'Times New Roman',...
    'linewidth',FigSet.linewidth,'FontWeight','bold','tickdir','in');
XLimit = ceil(max(X)/100)*100;
YLimitMax = max(Y) + 0.1;YLimitMin = min(Y) - 0.1;
axis([0 XLimit YLimitMin YLimitMax])

% 指定图窗位置和大小
set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
set(gcf,'unit','centimeters','position',FigSet.Size);
% 图例设置
legend(FigSet.legendName,'FontSize',FigSet.FontSize,...
    'Location','NorthEast','Box','off');
end

