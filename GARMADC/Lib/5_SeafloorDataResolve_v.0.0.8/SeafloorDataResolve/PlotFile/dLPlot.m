function [ValueSTD,ValueRMS,ValueRRS] = dLPlot(DataStruct,SVP,FigSet)
%% 去粗�?
% FigSet.PlotModel = 'cos(Depth_Angle)';
% FigSet.legendName = {'sin高度角导�?',FigSet.legendName};
xvalue = 1:length(DataStruct.detalL);
index = find(strcmp(DataStruct.flag,'True'));
xvalue(index)=[];DataStruct.detalL(index)=[];
dL = DataStruct.detalL;
% if strcmp(FigSet.PlotModel,'Depth_Angle')
%     DataStruct.Phi(index)=[];
%     Phi = asin(DataStruct.Phi);
%     dPhi = [0,Phi(2:end)-Phi(1:end-1)];
%     plot(xvalue,dPhi,'-r','lineWidth',FigSet.lineWidth);
% elseif strcmp(FigSet.PlotModel,'cos(Depth_Angle)')
%     DataStruct.Phi(index)=[];
%     Phi = asin(DataStruct.Phi);
%     dPhi = cos(Phi);
%     plot(xvalue,dPhi,'-y','lineWidth',FigSet.lineWidth);
% end
% hold on
plot(xvalue,dL,FigSet.LineType,'lineWidth',FigSet.lineWidth);
%% 残差计算
ValueRMS = rms(dL);
ValueRRS = dL'*dL;
% RobLS 后续更改
sigma = std(dL);
ValueSTD = sigma;

%% 绘图
% 设定标题
% hTitle = title([FigSet.TitleName,' (Sigma = ',num2str(sigma),')'],'FontSize',FigSet.FontSize);
% % 设定坐标�?
% hXLabel = xlabel(FigSet.xlabelName);
% hYLabel = ylabel(FigSet.ylabelName);
% set(gca,'FontSize',FigSet.FontSize,...
%     'linewidth',FigSet.linewidth,'FontWeight','bold','tickdir','in');
% XLimit = ceil(max(xvalue)/100)*100;
% YLimitMax = max(dL) + 0.1;YLimitMin = min(dL) - 0.1;
% axis([0 XLimit YLimitMin YLimitMax])
% 
% % 指定图窗位置和大�?
% set(gcf, 'PaperPosition', FigSet.PaperPosition);
% % 指定figure的尺�?
% set(gcf,'unit','centimeters','position',FigSet.Size);
% % 图例设置
% legend(FigSet.legendName,'FontSize',FigSet.FontSize,...
%     'Location','NorthEast','Box','off');

% 图片保存
print(gcf,'ͼ','-r600','-dtiff');

end

