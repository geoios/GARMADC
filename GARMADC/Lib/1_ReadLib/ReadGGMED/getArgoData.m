function [Prof] =getArgoData(Argo,ArgoRange) 
%% ����˵��
%���ܣ���Argo�۲��ļ��л�ȡ���Argo��������
%% ���ܴ���
%%����������������
for iData = 1:ArgoRange.seaLayerNum
    findPosition = find((ArgoRange.lonRange(1) <=Argo(iData).data(:,1) & Argo(iData).data(:,1)<= ArgoRange.lonRange(2)) ...
                      & (ArgoRange.latRange(1) <=Argo(iData).data(:,2) & Argo(iData).data(:,2)<= ArgoRange.latRange(2)) ...
                      & (ArgoRange.timeRange(1) <=Argo(iData).data(:,4) & Argo(iData).data(:,4)<= ArgoRange.timeRange(2)));
    n = size(findPosition,1);
    % ÿ���������
    ArgoSearch(iData,:).data = Argo(iData).data(findPosition,:);%������ΪΨһ��ʶ
end

%%��ͬ����ͬԪ����ȡ
if(ArgoRange.seaLayerNum~=1)
    aEle = [ArgoSearch(1,:).data(:,1:2) ArgoSearch(1,:).data(:,4)];
    for iData = 1:ArgoRange.seaLayerNum - 1
        bEle = [ArgoSearch(iData + 1,:).data(:,1:2) ArgoSearch(iData + 1,:).data(:,4)]; 
        aEle = intersect(aEle,bEle,'rows');
    end
    comEleA = aEle;%��ͬԪ��
    % ȥ�ظ�Ԫ��
    [comEleB] = unique(comEleA,'rows'); 
    % ��ȡԪ��(ȫ��)
    for iData = 1:ArgoRange.seaLayerNum
        cEle = [ArgoSearch(iData ,:).data(:,1:2) ArgoSearch(iData ,:).data(:,4)]; 
        [~,comElePos] = intersect(cEle,comEleB,'rows');
        ArgoSearchPro(iData,:).data = ArgoSearch(iData ,:).data(comElePos,:);
    end
    % ͳһ����������
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

%%��ȡ����
% ��ȡ��������(���水������)
Prof.pos(1,:) = ArgoSearchProSort(1,1).data(:,1)';%��,������γ��ʱ��
Prof.pos(2,:) = ArgoSearchProSort(1,1).data(:,2)';%��
Prof.pos(3,:) = ArgoSearchProSort(1,1).data(:,4)';%��
for iData = 1:ArgoRange.seaLayerNum
    Prof.lat(iData,:) = ArgoSearchProSort(iData,1).data(:,2)';
    Prof.depth(iData,:) = ArgoSearchProSort(iData,1).data(:,3)';
    Prof.temperature(iData,:) = ArgoSearchProSort(iData,1).data(:,5)';
    Prof.salinity(iData,:) = ArgoSearchProSort(iData,1).data(:,6)';
end
%��������
for iProf = 1:size(Prof.pos,2)
    [svp] = delGrosso([Prof.depth(:,iProf) Prof.temperature(:,iProf) Prof.salinity(:,iProf) Prof.lat(:,iProf)]);
    Prof.acoSpeed(:,iProf) = svp(:,2);
end



