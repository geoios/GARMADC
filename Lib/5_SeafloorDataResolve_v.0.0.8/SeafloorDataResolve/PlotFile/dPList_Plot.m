function dPList_Plot(X,Y,FigSet)
%% 绘图
plot(X,Y,FigSet.LineType,'lineWidth',FigSet.lineWidth);
% 设定标题
hTitle = title([FigSet.TitleName],'FontSize',FigSet.FontSize);
% 设定坐标轴
hXLabel = xlabel(FigSet.xlabelName);
hYLabel = ylabel(FigSet.ylabelName);
set(gca,'FontSize',FigSet.FontSize,'Fontname', 'Times New Roman',...
    'linewidth',FigSet.linewidth,'FontWeight','bold','tickdir','in');
XLimit = ceil(max(xvalue));
xlim([0,XLimit]);
end

