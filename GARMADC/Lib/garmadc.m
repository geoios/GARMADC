function [centCoor,TranCoor,centCoorFix_array,TranCoorFix_array,arrayOffsetFix_array] = garmadc(parSet,impoObsPath,impoIniPath,expoIniPath_array,PhySet,ArgoSet)
%% Founction description
%Founction:GNSS-A Ranging Model with Acoustic Delay Corrections
%% Founction code

%% Single epoch solution
% Data
[IniFileDetaPath] = getFileDetaPath(impoIniPath,'*-initcfg.ini');
[ObsFileDetaPath] = getFileDetaPath(impoObsPath,'*-obs.csv');
[SvpFileDetaPath] = getFileDetaPath(impoObsPath,'*svp.csv');
statiSeri = (1:size(ObsFileDetaPath,1))';
% solution
[JpnIniInfo] = getIniData(IniFileDetaPath);
if(parSet(1) == 0)% SSP-based ray-tracing
    for iStatiSeri = 1:size(statiSeri,1)
        [ModelT_MP_T{iStatiSeri},ModelT_MP_T_OBSData{iStatiSeri}] = compPositResu_v002(ObsFileDetaPath{iStatiSeri},SvpFileDetaPath{iStatiSeri},IniFileDetaPath{iStatiSeri});
    end
elseif(parSet(1) ~= 0)
    [JpnSvpInfo] = getSvpData(SvpFileDetaPath);
    [PrioStatsInfo] = compArgoStats(ArgoSet,JpnIniInfo,JpnSvpInfo{1}(:,1));%Prior statistical information
    [SvpInfo] = obtaPhySsp_prod(PhySet,JpnIniInfo,PrioStatsInfo);
    for iStati = 1:size(SvpInfo,1)%Delay grid products
        for jProf = 1:size(SvpInfo{iStati},1)
            [ParGrid{iStati,1}{jProf,1}] = makeParGrid_prod(SvpInfo{iStati,1}(jProf));
            [ParGrid{iStati,1}{jProf,1}] = inteModeling_prod(ParGrid{iStati,1}{jProf,1});%Interpolation parameter
        end
    end
    if(parSet(1) == 1)%CSS-based ranging
        soluType = 1;
    elseif(parSet(1) == 2)%CSS-based ranging + Static delay
        soluType = 3;
    elseif(parSet(1) == 3)%CSS-based ranging + Static delay + Dynamic delay
        soluType = 4;
    end
    for iStatiSeri = 1:size(statiSeri,1)
        intePos = JpnIniInfo{iStatiSeri}.pos;
        [ModelT_MP_T{iStatiSeri,1},ModelT_MP_T_OBSData{iStatiSeri,1}] = compPositResu_v008(intePos,soluType,ParGrid{iStatiSeri},ObsFileDetaPath{iStatiSeri},IniFileDetaPath{iStatiSeri});
    end
end
% Extract positioning results
for iStatiSeri = 1:size(statiSeri,1)
    [centCoor(iStatiSeri,:),TranCoor{iStatiSeri,1}] = readXiaoInfo(ModelT_MP_T{iStatiSeri},size(JpnIniInfo{iStatiSeri}.statName,1));
end

%% Array solution
if(parSet(2) == 0)
    % Extract positioning results
    centCoorFix_array = [];
    TranCoorFix_array = [];
    arrayOffsetFix_array = [];
elseif(parSet(2) == 1)
    fixFilePath = FixArrayRef_ljs(impoObsPath,impoIniPath,TranCoor,expoIniPath_array);
    OffsetType = parSet(2);
    [IniFileDetaPath_array] = getFileDetaPath([expoIniPath_array 'FixArrayCoor\MYGI\'],'*-fix.ini');
    [JpnIniInfo_array] = getIniData(IniFileDetaPath_array);
    if(parSet(1) == 0)
        for iStatiSeri = 1:size(statiSeri,1)
            [ModelT_MP_T_array{iStatiSeri},ModelT_MP_T_OBSData_array{iStatiSeri}] = compPositResu_v002_xz(ObsFileDetaPath{iStatiSeri},SvpFileDetaPath{iStatiSeri},IniFileDetaPath_array{iStatiSeri});
        end
    elseif(parSet(1) ~= 0)
        for iStatiSeri = 1:size(statiSeri,1)
            intePos = JpnIniInfo_array{iStatiSeri}.pos;
            [ModelT_MP_T_array{iStatiSeri,1},ModelT_MP_T_OBSData_array{iStatiSeri,1}] = compPositResu_v008_xz(intePos,soluType,ParGrid{iStatiSeri},ObsFileDetaPath{iStatiSeri},IniFileDetaPath_array{iStatiSeri});
        end
    end
    % Extract positioning results
    for iStatiSeri = 1:size(statiSeri,1)
        [centCoorFix_array(iStatiSeri,:),TranCoorFix_array{iStatiSeri,1},arrayOffsetFix_array(iStatiSeri,:)] = readXiaoInfo(ModelT_MP_T_array{iStatiSeri},size(JpnIniInfo_array{iStatiSeri}.statName,1));
    end
end
