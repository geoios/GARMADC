function [StatsInfo] = compArgoStats(ArgoSet,JpnIniInfo,jpnSvpDepth)
%% ����˵��
%���ܣ���ȡArgoͳ����Ϣ
%% ���ܴ���
%Argo��ȡ
ArgoRange.seaLayerNum = 27;
ArgoRange.lonRange = [JpnIniInfo{1}.lon-1.5 JpnIniInfo{1}.lon+1.5];
ArgoRange.latRange = [JpnIniInfo{1}.lat-1.5 JpnIniInfo{1}.lat+1.5];
ArgoRange.timeRange = [JpnIniInfo{1}.time JpnIniInfo{end}.time];
[ArgoProf] = getArgoData(ArgoSet,ArgoRange);
% %���¶�����ͼ
% figure; plotProf_timeSeri(ArgoProf.depth(:,1),ArgoProf.temperature,'T');xlim([0 30]);ylim([0 2000])
% %���ζ�����ͼ
% figure; plotProf_timeSeri(ArgoProf.depth(:,1),ArgoProf.salinity,'S');xlim([30 35]);ylim([0 2000])
% %����������ͼ
% figure; plotProf_timeSeri(ArgoProf.depth(:,1),ArgoProf.acoSpeed,'A');xlim([1450 1550]);ylim([0 2000])

%% Sb����ͳ�ƣ�2000m��
%��ֵ
if(jpnSvpDepth(end,1) <= 2000)
    for iProf = 1:size(ArgoProf.pos,2)
        inteT(:,iProf) = interp1(ArgoProf.depth(:,1),ArgoProf.temperature(:,iProf),jpnSvpDepth,'linear');
        inteS(:,iProf) = interp1(ArgoProf.depth(:,1),ArgoProf.salinity(:,iProf),jpnSvpDepth,'linear');
        inteV(:,iProf) = interp1(ArgoProf.depth(:,1),ArgoProf.acoSpeed(:,iProf),jpnSvpDepth,'linear');
    end
    %ͳ��
    StatsInfo.depth = jpnSvpDepth(end,1);
else
    inteT = ArgoProf.temperature;
    inteS = ArgoProf.salinity;
    inteV = ArgoProf.acoSpeed;
    %ͳ��
    StatsInfo.depth = 2000;
end
StatsInfo.Tb = [mean(inteT(end,:));std(inteT(end,:))];
StatsInfo.Sb = [mean(inteS(end,:));std(inteS(end,:))];
StatsInfo.Vb = [mean(inteV(end,:));std(inteV(end,:))];