function  Mu = BlockWeight(BlockTime,Mu2,WeightType)
%% ++ Input
% BlockTime; �ֶ�ʱ���
% Mu2:ϵ��
% WeightType:Ȩ��������
%% ++ Output
% Mu; ʱ��ֶ�Ȩ
BlockNum = length(BlockTime) + 1;
if WeightType == 1
    Mu1 = ones(BlockNum-1,1);

else
    if WeightType == 2       % Ȩ���䣨ʱ��
        Weight = BlockTime./sum(BlockTime);
        Mu1    = repelem(Mu1,3);
    elseif WeightType == 3   % Ȩ���䣨ʱ������
        Weight = 1./BlockTime;
        Mu1    = (Weight/sum(Weight));
    elseif WeightType == 4   % Ȩ���䣨ʱ����ƽ����
        Weight = (1./BlockTime).^2;
        Mu1    = (Weight/sum(Weight));
    end
    Mu1 = Mu1 .* (Mu2 * BlockNum);
end

Mu = repelem(Mu1,3);

end 