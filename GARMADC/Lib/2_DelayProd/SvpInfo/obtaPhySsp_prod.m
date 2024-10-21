function [SvpInfo,ExtraProf_phyUse,ExtraProf_phy] = obtaPhySsp_prod(PhySet,JpnIniInfo,PrioStatsInfo)
%% 函数说命
%功能：哥白尼剖面获取
%% 功能代码
%读取Argo格网
statiSeri = (1:size(JpnIniInfo,1))';
spacPoinNum = 4;
for iStat = 1:size(statiSeri,1)
    intePos = JpnIniInfo{iStat}.pos;
    %基于Coper
    [ExtraProf_phyUse{iStat,1},ExtraProf_phy{iStat,1}] = compPhyExte_poinNum_prod(intePos,spacPoinNum,PhySet,PrioStatsInfo);
    for jProf = 1:size(ExtraProf_phyUse{iStat}.pos,2) 
        lat = repmat(ExtraProf_phyUse{iStat}.pos(2,jProf),size(ExtraProf_phyUse{iStat}.depth,1),1);
        GridSvpInfo(jProf,1).pos = ExtraProf_phyUse{iStat}.pos(:,jProf);
        GridSvpInfo(jProf,1).dtslInfo = [ExtraProf_phyUse{iStat}.depth ExtraProf_phyUse{iStat}.temp(:,jProf) ExtraProf_phyUse{iStat}.salt(:,jProf) lat];
    end
    SvpInfo{iStat,1} = GridSvpInfo;
end

