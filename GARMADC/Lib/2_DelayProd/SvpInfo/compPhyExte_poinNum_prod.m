function [ExtraProf_use,ExtraProf_scree] = compPhyExte_poinNum_prod(intePos,spacPoinNum,PhySet,StatsInfo)
%% ����˵��
%���ܣ���������ݼ���ֵ
%% ���ܴ���
count = 0;
for iDay = -1:1%�¼ӵķ�Χ
    jdDay = intePos(3) + iDay;
    %��ȡ
    [ExtraProfTempo] = getPhyData_poinNum(intePos,spacPoinNum,jdDay,PhySet);
    count = count + 1;
    ExtraProf_coper.depth = ExtraProfTempo.depth;
    if(count == 1)
        ExtraProf_coper.pos = [ExtraProfTempo.pos];
        ExtraProf_coper.temp = [ExtraProfTempo.temp];
        ExtraProf_coper.sal = [ExtraProfTempo.sal];
        ExtraProf_coper.svp = [ExtraProfTempo.svp];
    else
        ExtraProf_coper.pos = [ExtraProf_coper.pos ExtraProfTempo.pos];
        ExtraProf_coper.temp = [ExtraProf_coper.temp ExtraProfTempo.temp];
        ExtraProf_coper.sal = [ExtraProf_coper.sal ExtraProfTempo.sal];
        ExtraProf_coper.svp = [ExtraProf_coper.svp ExtraProfTempo.svp];
    end
end
%��ȡ����
ExtraProf_scree.depth = [0;ExtraProf_coper.depth];
ExtraProf_scree.pos = ExtraProf_coper.pos;
ExtraProf_scree.temp = [ExtraProf_coper.temp(1,:);ExtraProf_coper.temp];
ExtraProf_scree.salt = [ExtraProf_coper.sal(1,:);ExtraProf_coper.sal];
%LS����+spline�ڲ�
inteDepthArray = [0;5;10;20;30;50;75;100;125;150;200;250;300;400;500;600;700;800;900;1000;1100;1200;1300;1400;1500;1750;2000];
ExtraProf_use.depth = inteDepthArray;
ExtraProf_use.pos = ExtraProf_scree.pos;
exteDepth = inteDepthArray(end,1);
for iProf = 1:size(ExtraProf_scree.pos,2)
    %�¶�
    temp = [ExtraProf_scree.depth ExtraProf_scree.temp(:,iProf)];
    tempCut = temp(all(~isnan(temp),2),:);
    if(tempCut(end,1) < exteDepth)
        tempCutExte = [tempCut;lsFun(tempCut,exteDepth,2,[StatsInfo.depth StatsInfo.Tb(1)])];
        ExtraProf_use.temp(:,iProf) = interp1(tempCutExte(:,1),tempCutExte(:,2),inteDepthArray,'linear');
    else
        ExtraProf_use.temp(:,iProf) = interp1(tempCut(:,1),tempCut(:,2),inteDepthArray,'linear');
    end
    %�ζ�
	salt = [ExtraProf_scree.depth ExtraProf_scree.salt(:,iProf)];
    saltCut = salt(all(~isnan(salt),2),:);
    if(saltCut(end,1) < exteDepth)
        saltCutExte = [saltCut;lsFun(saltCut,exteDepth,2,[StatsInfo.depth StatsInfo.Sb(1)])];
        ExtraProf_use.salt(:,iProf) = interp1(saltCutExte(:,1),saltCutExte(:,2),inteDepthArray,'linear');
    else
        ExtraProf_use.salt(:,iProf) = interp1(saltCut(:,1),saltCut(:,2),inteDepthArray,'linear');
    end
end

%% ��������
function [SearProf] = getPhyData_poinNum(intePos,spacPoinNum,jdDay,PhySet)
%%����˵��
%���ܣ�����������ȡ
%%���ܴ���
%��Ǿ���������
deltaXy = repmat(intePos(:,1:2),size(PhySet.pos,2),1) - PhySet.pos(1:2,:)';
dist = sqrt(deltaXy(:,1).^2 + deltaXy(:,2).^2);
distTimeMark = [PhySet.pos' dist (1:size(PhySet.pos,2))'];%��
%��ȡ����Ҫ������
distTimeMark_remoTime = distTimeMark((jdDay == distTimeMark(:,3)),:);
sortDistTimeMark_remoTime = sortrows(distTimeMark_remoTime,4);
extaMatr = sortDistTimeMark_remoTime(1:spacPoinNum,:);
index = extaMatr(:,5);
%��ȡ
SearProf.depth = PhySet.depth;
SearProf.pos = PhySet.pos(:,index);
SearProf.temp = PhySet.temp(:,index);
SearProf.sal = PhySet.sal(:,index);
for iProf = 1:size(SearProf.pos,2)
    svpInfo = [SearProf.depth SearProf.temp(:,iProf) SearProf.sal(:,iProf) repmat(SearProf.pos(2,iProf),size(SearProf.depth,1),1)];
    svp = delGrosso(svpInfo);
    SearProf.svp(:,iProf) = svp(:,2);
end