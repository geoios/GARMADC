function plotDistCorr(dataMatr,lineType)
%% ����˵��
%���ܣ����������
%% ���ܴ���
plot(dataMatr(:,1),dataMatr(:,2),lineType,'lineWidth',0.75);
xlabel('Incidence angle (\circ)');
ylabel('Distance error (m)')
%��������
set(gca,'FontSize',8,...
        'Fontname','Arial',...
        'FontWeight','bold',...
        'linewidth',0.75,...
        'tickdir','in');
set(gcf,'Units','centimeter','Position',[5 5 8 6]);
set(0,'defaultfigurecolor','w');

