function [StatsInfo] = compArgoStats(ArgoSet,JpnIniInfo,jpnSvpDepth)
%% 函数说明
%功能：获取Argo统计信息
%% 功能代码
%Argo读取
ArgoRange.seaLayerNum = 27;
ArgoRange.lonRange = [JpnIniInfo{1}.lon-1.5 JpnIniInfo{1}.lon+1.5];
ArgoRange.latRange = [JpnIniInfo{1}.lat-1.5 JpnIniInfo{1}.lat+1.5];
ArgoRange.timeRange = [JpnIniInfo{1}.time JpnIniInfo{end}.time];
[ArgoProf] = getArgoData(ArgoSet,ArgoRange);
% %绘温度剖面图
% figure; plotProf_timeSeri(ArgoProf.depth(:,1),ArgoProf.temperature,'T');xlim([0 30]);ylim([0 2000])
% %绘盐度剖面图
% figure; plotProf_timeSeri(ArgoProf.depth(:,1),ArgoProf.salinity,'S');xlim([30 35]);ylim([0 2000])
% %绘声速剖面图
% figure; plotProf_timeSeri(ArgoProf.depth(:,1),ArgoProf.acoSpeed,'A');xlim([1450 1550]);ylim([0 2000])

%% Sb参数统计（2000m）
%插值
if(jpnSvpDepth(end,1) <= 2000)
    for iProf = 1:size(ArgoProf.pos,2)
        inteT(:,iProf) = interp1(ArgoProf.depth(:,1),ArgoProf.temperature(:,iProf),jpnSvpDepth,'linear');
        inteS(:,iProf) = interp1(ArgoProf.depth(:,1),ArgoProf.salinity(:,iProf),jpnSvpDepth,'linear');
        inteV(:,iProf) = interp1(ArgoProf.depth(:,1),ArgoProf.acoSpeed(:,iProf),jpnSvpDepth,'linear');
    end
    %统计
    StatsInfo.depth = jpnSvpDepth(end,1);
else
    inteT = ArgoProf.temperature;
    inteS = ArgoProf.salinity;
    inteV = ArgoProf.acoSpeed;
    %统计
    StatsInfo.depth = 2000;
end
StatsInfo.Tb = [mean(inteT(end,:));std(inteT(end,:))];
StatsInfo.Sb = [mean(inteS(end,:));std(inteS(end,:))];
StatsInfo.Vb = [mean(inteV(end,:));std(inteV(end,:))];