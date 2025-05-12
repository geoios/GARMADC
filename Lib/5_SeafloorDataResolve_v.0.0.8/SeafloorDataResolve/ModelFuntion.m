function [y] = ModelFuntion(ScoreArray,Hyperpara,model)

%% Double_exp
if strcmp(model,'Constent')
    y = 1;
elseif strcmp(model,'Double_exp')
    U_Cri = Hyperpara.U_Cri;
    sigma1 = Hyperpara.sigma1;
    sigma2 = Hyperpara.sigma2;
    if ScoreArray<U_Cri
        y = exp(-(ScoreArray-U_Cri)^2/sigma1^2);
    else
        y = exp(-(ScoreArray-U_Cri)^2/sigma2^2);
    end
end
end

