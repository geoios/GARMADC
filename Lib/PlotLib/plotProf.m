function plotProf(prof,lineType,label)
%% 函数说明
%功能：绘制剖面
%% 功能代码
plot(prof(:,2),prof(:,1),lineType,'lineWidth',0.75);
%横纵轴标签
if(strcmp('T',label) == 1 )
    xlabel('Temperature (\circC)');
elseif(strcmp('S',label) == 1 )
    xlabel('Salinity (PSU)');
elseif(strcmp('A',label) == 1 )    
    xlabel('Sound Speed (m/s)');
end
ylabel('Depth (m)');
%格式设置
set(gca,'ydir','reverse',...
        'FontSize',8,...
        'Fontname','Arial',...
        'linewidth',0.75,...
        'tickdir','in',...
        'FontWeight','bold'); 
set(gcf,'Units','centimeter','Position',[5 5 9 8]);
set(0,'defaultfigurecolor','w');


