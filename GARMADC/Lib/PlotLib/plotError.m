function plotError(diffCoor_1,diffCoor_2,xAxisCoor,sele)
%% 函数说明
%功能：绘定位误差图
%% 功能代码
h1 = subplot(3,1,1);
plotError_line([xAxisCoor diffCoor_1(:,1)],'-^',1,4,[48 151 164]/255,3);hold on
plotError_line([xAxisCoor diffCoor_2(:,1)],'-o',1,4,[240 100 73]/255,3);
xlim([2011 2021]); 
set(gca,'xticklabel',[]);
pos = axis; 
ylabel('{\itE} (m)','position',[2010.2 0]);%(pos(3)+pos(4))/2
ax = gca;
ax.XAxis.TickLength = [0.005, 0.005];
ax.YAxis.TickLength = [0.005, 0.005];
if(sele == 1)
    legend('Without static delay correction','With static delay correction','Location','NorthOutSide','Box','on','position',[0.45 0.88 0.1 0.05],'Orientation','horizon');%
    ylim([-1.4 1.4]);  
    set(gca,'yTick',[-1.4:0.7:1.4]);
elseif(sele == 2)
    legend('Without dynamic delay correction','With dynamic delay correction','Location','NorthOutSide','Box','on','position',[0.45 0.88 0.1 0.05],'Orientation','horizon');%
    ylim([-0.8 0.8])
    set(gca,'yTick',[-0.8:0.4:0.8]);
end

h2 = subplot(3,1,2);
plotError_line([xAxisCoor diffCoor_1(:,2)],'-^',1,4,[48 151 164]/255,3);hold on
plotError_line([xAxisCoor diffCoor_2(:,2)],'-o',1,4,[240 100 73]/255,3);
xlim([2011 2021]);
set(gca,'xticklabel',[]);
pos = axis;
ylabel('{\itN} (m)','position',[2010.2 0]);%(pos(3)+pos(4))/2-0.3
ax = gca;
ax.XAxis.TickLength = [0.005, 0.005];
ax.YAxis.TickLength = [0.005, 0.005];
if(sele == 1)
    ylim([-3 3])
    set(gca,'yTick',[-3:1.5:3]);
    ylab = string(num2str(get(gca,'yTick')','%.1f'));
    ylab(3,1) = '0';
    set(gca,'yTickLabel',ylab);
elseif(sele == 2)
    ylim([-0.8 0.8])
    set(gca,'yTick',[-0.8:0.4:0.8]);
    ylab = string(num2str(get(gca,'yTick')','%.1f'));
    ylab(3,1) = '0';
    set(gca,'yTickLabel',ylab);
end

h3 = subplot(3,1,3);
plotError_line([xAxisCoor diffCoor_1(:,3)],'-^',1,4,[48 151 164]/255,3);hold on
plotError_line([xAxisCoor diffCoor_2(:,3)],'-o',1,4,[240 100 73]/255,3);
xlim([2011 2021]);
xlabel('Date');
pos = axis;
ylabel('{\itU} (m)','position',[2010.2 0]);%(pos(3)+pos(4))/2-5
ax = gca;
ax.XAxis.TickLength = [0.005, 0.005];
ax.YAxis.TickLength = [0.005, 0.005];
if(sele == 1)
    ylim([-40 40])
    set(gca,'yTick',[-40:20:40]);
    ylab = string(num2str(get(gca,'yTick')','%.1f'));
    ylab(3,1) = '0';
    set(gca,'yTickLabel',ylab);
elseif(sele == 2)
    ylim([-4.2 4.2])
    set(gca,'yTick',[-4.2:2.1:4.2]);
end

set(gcf,'Units','centimeter','Position',[5 5 12 9]);

%设置子图位置
set(h1,'position',[0.1 0.65 0.8 0.2])
set(h2,'position',[0.1 0.40 0.8 0.2])
set(h3,'position',[0.1 0.15 0.8 0.2])

%% 辅助函数
function plotError_line(dataMatr,lineType,alfa,sizePoin,color,sele)
%%函数说明
%功能：画误差曲线
%%功能代码
if(sele==1)
    scatter(dataMatr(:,1),dataMatr(:,2),sizePoin,'filled',lineType,'MarkerFaceAlpha',alfa,'MarkerEdgeAlpha',alfa,'LineWidth',1);%'filled',
elseif(sele==2)
    scatter(dataMatr(:,1),dataMatr(:,2),sizePoin,lineType,'MarkerFaceAlpha',alfa,'MarkerEdgeAlpha',alfa,'LineWidth',1);%'filled',
elseif(sele==3)
    plot1 = plot(dataMatr(:,1),dataMatr(:,2),lineType,...
                 'Linew',0.5,...
                 'Markers',sizePoin,...
                 'LineWidth',1,...
                 'MarkerEdgeColor',color,...
                 'MarkerFaceColor',color);
    plot1.Color(4) = alfa;
end
%参数设置
set(gca,'FontSize',8,'Fontname','Arial','linewidth',0.75,'FontWeight','bold');%,'FontWeight','bold','tickdir','in',
set(0,'defaultfigurecolor','w');
