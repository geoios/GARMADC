function plotProf_timeSeri(depth,prof,label)
%% ����˵��
%���ܣ���������
%% ���ܴ���
dq = jet(size(prof,2));
for iProf = 1:size(prof,2)
    plot(prof(:,iProf),depth,'-','lineWidth',0.75,'color',dq(iProf,:));hold on
end
%�������ǩ
if(strcmp('T',label))
    xlabel('Temperature (\circC)');
elseif(strcmp('S',label))
    xlabel('Salinity (PSU)');
elseif(strcmp('A',label))    
    xlabel('Sound Speed (m/s)');
    xlim([1450 1550]);
end
ylabel('Depth (m)');
ylim([depth(1,1) 2000]);
%�����ʽ����
set(gca,'FontSize',8,...
        'Fontname','Arial',...
        'linewidth',0.5,...
        'tickdir','in',...
        'ydir','reverse',...
        'FontWeight','bold');
set(gcf,'Units','centimeter','Position',[5 5 10 7]);
set(0,'defaultfigurecolor','w');
%Colorbar����
colormap jet
cb = colorbar;
set(get(cb,'title'),'string','Time');
set(cb,'YTick',[0 0.5 1],'YTickLabel',{'20110328' '20151105' '20200615'});%ɫ��ֵ��Χ����ʾ���