function [Prof] =getArgoData(Argo,ArgoRange) 
%% 函数说明
%功能：从Argo观测文件中获取多层Argo剖面数据
%% 功能代码
%%初步搜索各层数据
for iData = 1:ArgoRange.seaLayerNum
    findPosition = find((ArgoRange.lonRange(1) <=Argo(iData).data(:,1) & Argo(iData).data(:,1)<= ArgoRange.lonRange(2)) ...
                      & (ArgoRange.latRange(1) <=Argo(iData).data(:,2) & Argo(iData).data(:,2)<= ArgoRange.latRange(2)) ...
                      & (ArgoRange.timeRange(1) <=Argo(iData).data(:,4) & Argo(iData).data(:,4)<= ArgoRange.timeRange(2)));
    n = size(findPosition,1);
    % 每层搜索结果
    ArgoSearch(iData,:).data = Argo(iData).data(findPosition,:);%经度作为唯一标识
end

%%不同层相同元素提取
if(ArgoRange.seaLayerNum~=1)
    aEle = [ArgoSearch(1,:).data(:,1:2) ArgoSearch(1,:).data(:,4)];
    for iData = 1:ArgoRange.seaLayerNum - 1
        bEle = [ArgoSearch(iData + 1,:).data(:,1:2) ArgoSearch(iData + 1,:).data(:,4)]; 
        aEle = intersect(aEle,bEle,'rows');
    end
    comEleA = aEle;%共同元素
    % 去重复元素
    [comEleB] = unique(comEleA,'rows'); 
    % 提取元素(全行)
    for iData = 1:ArgoRange.seaLayerNum
        cEle = [ArgoSearch(iData ,:).data(:,1:2) ArgoSearch(iData ,:).data(:,4)]; 
        [~,comElePos] = intersect(cEle,comEleB,'rows');
        ArgoSearchPro(iData,:).data = ArgoSearch(iData ,:).data(comElePos,:);
    end
    % 统一索引的排序
    for iData = 1:ArgoRange.seaLayerNum
        ArgoSearchProSort(iData,:).data = sortrows(ArgoSearchPro(iData,:).data, [4,1,2]);
    end
else
    [~,pos] = unique(ArgoSearch(1,:).data(:,1:3),'rows'); 
    ArgoSearchProSort(1,:).data = ArgoSearch(1,:).data(pos,:);
end

if(isempty(ArgoSearchProSort(1,:).data))
    a = 1
end

%%获取剖面
% 获取剖面数据(剖面按列排列)
Prof.pos(1,:) = ArgoSearchProSort(1,1).data(:,1)';%行,（经，纬，时）
Prof.pos(2,:) = ArgoSearchProSort(1,1).data(:,2)';%行
Prof.pos(3,:) = ArgoSearchProSort(1,1).data(:,4)';%行
for iData = 1:ArgoRange.seaLayerNum
    Prof.lat(iData,:) = ArgoSearchProSort(iData,1).data(:,2)';
    Prof.depth(iData,:) = ArgoSearchProSort(iData,1).data(:,3)';
    Prof.temperature(iData,:) = ArgoSearchProSort(iData,1).data(:,5)';
    Prof.salinity(iData,:) = ArgoSearchProSort(iData,1).data(:,6)';
end
%计算声速
for iProf = 1:size(Prof.pos,2)
    [svp] = delGrosso([Prof.depth(:,iProf) Prof.temperature(:,iProf) Prof.salinity(:,iProf) Prof.lat(:,iProf)]);
    Prof.acoSpeed(:,iProf) = svp(:,2);
end



