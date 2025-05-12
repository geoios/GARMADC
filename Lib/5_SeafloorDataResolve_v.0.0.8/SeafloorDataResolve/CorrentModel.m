function [dX] = CorrentModel(Jcb,OBSData,MP,MPNum,model,H)
switch model
    case 1
        %% 初始
        dX=inv(Jcb'*Jcb)*Jcb'*OBSData.detalT';
    case 2
        %% 作为虚拟观测值
        VirObs     = zeros(MPNum(end)-MPNum(end-1),MPNum(end));
        VirObs(:,MPNum(end-1)+1:MPNum(end)) = diag(ones((MPNum(end)-MPNum(end-1)),1));
        JCB        = [Jcb;VirObs];

        %detalT_tmp = MP(MPNum(end-1)+1:MPNum(end));
        detalT_tmp = MP(MPNum(end-1)+1 : MPNum(end));
        detalT_tmp = 0.5 * ( 10^-14  * detalT_tmp.^-1 - detalT_tmp); % 3.9714*10^-8

        detalT     = [OBSData.detalT'; detalT_tmp'];
        dX         = inv(JCB' * JCB) * JCB' * detalT;

        %% B样条惩罚函数做虚拟观测
    case 3
        VirObs     = zeros(MPNum(end)-MPNum(end-1),MPNum(end));
        VirObs(:,MPNum(1)+1:MPNum(end)) = H;
        JCB        = [Jcb;VirObs];

        detalT_tmp = zeros(MPNum(end)-MPNum(1),1);
        detalT     = [OBSData.detalT'; detalT_tmp];
        dX         = inv(JCB' * JCB) * JCB' * detalT;
end

end

