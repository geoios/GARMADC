function plotProf(prof,lineType,label)
%% ����˵��
%���ܣ���������
%% ���ܴ���
plot(prof(:,2),prof(:,1),lineType,'lineWidth',0.75);
%�������ǩ
if(strcmp('T',label) == 1 )
    xlabel('Temperature (\circC)');
elseif(strcmp('S',label) == 1 )
    xlabel('Salinity (PSU)');
elseif(strcmp('A',label) == 1 )    
    xlabel('Sound Speed (m/s)');
end
ylabel('Depth (m)');
%��ʽ����
set(gca,'ydir','reverse',...
        'FontSize',8,...
        'Fontname','Arial',...
        'linewidth',0.75,...
        'tickdir','in',...
        'FontWeight','bold'); 
set(gcf,'Units','centimeter','Position',[5 5 9 8]);
set(0,'defaultfigurecolor','w');


