%% 脚本说明
%功能：残差分析
%输入：+ModelT_MP_T_OBSData

sequNum = 25;%序列号
%% 剔除粗差 
pos = find(strcmp('False',ModelT_MP_T_OBSData{sequNum, 1}.flag) == 1);
obsTimeResi = ModelT_MP_T_OBSData{sequNum, 1}.detalT(pos,:);
obsDistResi = obsTimeResi.*MeanVel(SVP);
plotResi([(1:size(obsDistResi,1))' obsDistResi],'b-');
legend('\fontname{宋体}传播距离残差','Location','NorthEast','Box','off');