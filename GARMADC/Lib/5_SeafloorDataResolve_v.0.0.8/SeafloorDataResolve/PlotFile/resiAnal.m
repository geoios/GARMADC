%% �ű�˵��
%���ܣ��в����
%���룺+ModelT_MP_T_OBSData

sequNum = 25;%���к�
%% �޳��ֲ� 
pos = find(strcmp('False',ModelT_MP_T_OBSData{sequNum, 1}.flag) == 1);
obsTimeResi = ModelT_MP_T_OBSData{sequNum, 1}.detalT(pos,:);
obsDistResi = obsTimeResi.*MeanVel(SVP);
plotResi([(1:size(obsDistResi,1))' obsDistResi],'b-');
legend('\fontname{����}��������в�','Location','NorthEast','Box','off');