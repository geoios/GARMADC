function [dX] = CalMPJcb_MTJcb_SVP_ModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,detalp,H)
N_shot=str2double(INIData.Data_file.N_shot);
Jcb=zeros(N_shot,MPNum(end));mp=MP;
%% 按照海底点坐标进行构建雅可比矩阵
for MPIndex = 1:MPNum(end)
    ModelT = zeros(N_shot,1);
    MP(MPIndex) = MP(MPIndex) + detalp;
    for ShotNum = 1 : N_shot
        index = OBSData.MTPSign(ShotNum);

        Transducer_ENU_ST = [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)];
        Transducer_ENU_RT = [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)];

        [NewSVPStr] = CalSVP(OBSData.ST(ShotNum), SVP, MP, MPNum, spdeg, knots, Transducer_ENU_ST, MP(index:index+2), [INIData.SurE0Mean,INIData.SurN0Mean],INIData);
        [NewSVPEnd] = CalSVP(OBSData.RT(ShotNum), SVP, MP, MPNum, spdeg, knots, Transducer_ENU_RT, MP(index:index+2), [INIData.SurE1Mean,INIData.SurN1Mean],INIData);

        SVPDataStr.PF = PFGrad(NewSVPStr,2,1);
        SVPDataEnd.PF = PFGrad(NewSVPEnd,2,1);
        ModelTT1      = P2PInvRayTrace(Transducer_ENU_ST, MP(index:index+2), SVPDataStr);
        ModelTT2      = P2PInvRayTrace(Transducer_ENU_RT, MP(index:index+2), SVPDataEnd);
        ModelT(ShotNum) = ModelTT1 + ModelTT2;
    end
    Jcb(:,MPIndex) = (ModelT-OBSData.ModelT')/detalp;
    MP = mp;
end
%% 粗差剔除
TrueIndex = find(strcmp(OBSData.flag,'True')==1);
Jcb(TrueIndex,:)=[];
detalTOri = OBSData.detalT';
detalTOri(TrueIndex,:) = [];

%% 解算模型
JcbMoodel = 1 ; Mu = 1;
switch JcbMoodel
    case 1
        %% 判断节点是否存在跳动，如果存在删除跳动节点对应的参数
        DeteleList = [];dX = zeros(MPNum(end),1);
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        
        slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
        JCB = Jcb(:,slvidx);

        dx = inv(JCB'*JCB)*JCB'*detalTOri;
        dX(slvidx) = dx;
    case 2
        %% 作为虚拟观测值
        if length(MPNum)== 5
            num = 1;
        else
            num = 2;
        end
        VirObs     = zeros(MPNum(end)-MPNum(end-num),MPNum(end));
        VirObs(:,MPNum(end-num)+1:MPNum(end)) = diag(ones((MPNum(end)-MPNum(end-num)),1));
        JCB        = [Jcb;VirObs];

        %detalT_tmp = MP(MPNum(end-1)+1:MPNum(end));
        detalT_tmp = MP(MPNum(end-num)+1 : MPNum(end));
        detalT_tmp = 0.5 * (  10^-14 * detalT_tmp.^-1 - detalT_tmp); %3.9714*10^-8

        detalT     = [detalTOri; detalT_tmp'];
        dX         = inv(JCB' * JCB) * JCB' * detalT;
    case 3
        %% 相邻约束
        VirObs     = zeros(MPNum(end)-MPNum(2),MPNum(end));
        for  i = 1:length(MPNum)-2
            VirObs(MPNum(i)+1-MPNum(1):MPNum(i+1)-MPNum(1),MPNum(i)+1:MPNum(i+1)) = diag(ones((MPNum(i+1)-MPNum(i)),1));
            VirObs(MPNum(i)+1-MPNum(1):MPNum(i+1)-MPNum(1),MPNum(i+1)+1:MPNum(i+2)) = diag(-1*ones((MPNum(i+2)-MPNum(i+1)),1));
        end

        JCB        = [Jcb;VirObs];
        detalT_tmp = zeros(MPNum(end)-MPNum(2),1);
        detalT     = [detalTOri; detalT_tmp];
        P = diag([ones(1,length(detalTOri)),Mu*ones(1,MPNum(end)-MPNum(2))]);
        dX         = inv(JCB' * P * JCB) * JCB' * P * detalT;
    case 4
        %         VirObs     = zeros(MPNum(end)-MPNum(2),MPNum(end));
        %         for  i = 1:length(MPNum)-2
        %             VirObs(MPNum(i)+1-MPNum(1):MPNum(i+1)-MPNum(1),MPNum(i)+1:MPNum(i+1)) = diag(ones((MPNum(i+1)-MPNum(i)),1));
        %             VirObs(MPNum(i)+1-MPNum(1):MPNum(i+1)-MPNum(1),MPNum(i+1)+1:MPNum(i+2)) = diag(-1*ones((MPNum(i+2)-MPNum(i+1)),1));
        %         end
        %         VirObs([MPNum(7)-MPNum(1)+1:MPNum(8)-MPNum(1),MPNum(14)-MPNum(1)+1:MPNum(15)-MPNum(1)],:)=[];
        %
        nnm = fix(length(MPNum)/(length(INIData.SVPSeg)+1))+1;
        VirObs     = zeros(MPNum(end)-MPNum(nnm),MPNum(end));
        for  i = 1:length(MPNum)-2
            if mod(i,(length(INIData.SVPSeg)+1))==0
                continue;
            end
            Row = MPNum(num)+1-MPNum(1):MPNum(num+1)-MPNum(1);
            Column1 = MPNum(i)+1:MPNum(i+1);
            Column2 = MPNum(i+1) + 1:MPNum(i+2);

            E = diag(ones((MPNum(num+1)-MPNum(num)),1));
            VirObs(Row , Column1) = E;
            VirObs(Row , Column2) = -E;
            num=num + 1;
        end
        JCB        = [Jcb;VirObs];
        detalT_tmp = zeros(MPNum(end)-MPNum(4),1);
        detalT     = [detalTOri; detalT_tmp];
        P = diag([ones(1,length(detalTOri)),Mu*ones(1,MPNum(end)-MPNum(4))]);
        dX         = inv(JCB' * P * JCB) * JCB' * P * detalT;
    case 5
        % 观测间断剔除
        DeteleList = [];dX = zeros(MPNum(end),1);
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
        JCB1 = Jcb(:,slvidx);
        % 相邻约束权阵
        num = 1;
        nnm = fix(length(MPNum)/(length(INIData.SVPSeg)+1)) + 1;
        VirObs     = zeros(MPNum(end)-MPNum(nnm),MPNum(end));
        for  i = 1:length(MPNum)-2
            if mod(i,(length(INIData.SVPSeg)+1))==0
                continue;
            end
            Row = MPNum(num)+1-MPNum(1):MPNum(num+1)-MPNum(1);
            Column1 = MPNum(i)+1:MPNum(i+1);
            Column2 = MPNum(i+1) + 1:MPNum(i+2);

            E = diag(ones((MPNum(num + 1)-MPNum(num)),1));
            VirObs(Row , Column1) = E;
            VirObs(Row , Column2) = -E;
            num = num + 1;

        end
        
        VirObs1 =  VirObs(:,slvidx);
        slvidx2 = [];
        for i = 1:size(VirObs1,1)
            if length(unique (VirObs1(i,:)))==1
                    slvidx2 = [slvidx2 , i];
            end
        end
        VirObs1(slvidx2,:) = [];
        JCB        = [JCB1;VirObs1];
        detalT_tmp = zeros(MPNum(end)-MPNum(4)-length(slvidx2),1);
        detalT     = [detalTOri; detalT_tmp];
        P          = diag([ones(1,length(detalTOri)),Mu*ones(1,MPNum(end)-MPNum(4)-length(slvidx2))]);
        dx         = inv(JCB' * P * JCB) * JCB' * P * detalT;
        dX(slvidx) = dx;

end
end

