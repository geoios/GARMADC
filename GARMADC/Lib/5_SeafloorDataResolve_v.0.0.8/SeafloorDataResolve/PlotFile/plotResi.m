function plotResi(dataMatr,LineType)
%% ����˵��
%���ܣ����в�
%���룺
%�����
plot(dataMatr(:,1),dataMatr(:,2),LineType,'linew',0.2,'markers',5,'lineWidth',1);
%��������
xlabel('\fontname{����}�۲���Ԫ\fontname{����}(��)');
ylabel('\fontname{Times New Roman}(m)');

set(gca,'FontSize',12,'Fontname', 'Times New Roman','FontWeight','bold');
set(gca,'linewidth',0.75);
set(gca,'tickdir','in');
grid on;
set(gcf,'Units','centimeter','Position',[5 5 12 8]);
set(0,'defaultfigurecolor','w');
% eval(['print(gcf, ''-dpng'', ''-r600'', ''',expoPlotPath,expoFileName,'.png'')']); 