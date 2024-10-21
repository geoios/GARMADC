function [dX,JCB] = CalMPJcb_MTJcb_T_ModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,H)
N_shot=str2double(INIData.Data_file.N_shot);
Jcb=zeros(N_shot,MPNum(end));
C = MeanVel(SVP);
% SVPDataCri.PF= PFGrad(SVP,2,1);
PF= PFGrad(SVP,2,1);
%% 坐标部分雅可比矩�?
for ShotNum = 1:N_shot
    index = OBSData.MTPSign(ShotNum);
    
    Transducer_ENU_ST = [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)];
    Transducer_ENU_RT = [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)];
    
    e0 = RayJac_Num(Transducer_ENU_ST,MP(index:index+2),PF);
    e1 = RayJac_Num(Transducer_ENU_RT,MP(index:index+2),PF);
    
    Jcb(ShotNum,index:index + 2) = -(e0 + e1) ./C;
end

%% B样条参数部分雅可�?
GamTmp = zeros(1,MPNum(end)-MPNum(1));
for GamNum = 1:length(GamTmp)
    GamTmp(GamNum) = 1;detalT = zeros(N_shot,1);
    for ShotNum = 1:N_shot
        index = OBSData.MTPSign(ShotNum);
        alpha0 = [OBSData.alpha0_Vessel(ShotNum),OBSData.alpha0_Ray(ShotNum)];
        alpha1 = [OBSData.alpha1_Vessel(ShotNum),OBSData.alpha1_Ray(ShotNum)];
        Z0     = [OBSData.Z0_Vessel(ShotNum),OBSData.Z0_Ray(ShotNum)];
        Z1     = [OBSData.Z1_Vessel(ShotNum),OBSData.Z1_Ray(ShotNum)];
        [detalT1] = CalT_ZTD_002(OBSData.ST(ShotNum),[MP(1:MPNum(1)),GamTmp],MPNum,...
            spdeg,knots,alpha0,Z0,INIData,OBSData.transducer_u0(ShotNum),OBSData.gammar0(ShotNum,:),index,OBSData.Lambda0(ShotNum));
        [detalT2] = CalT_ZTD_002(OBSData.RT(ShotNum),[MP(1:MPNum(1)),GamTmp],MPNum,...
            spdeg,knots,alpha1,Z1,INIData,OBSData.transducer_u1(ShotNum),OBSData.gammar1(ShotNum,:),index,OBSData.Lambda1(ShotNum));
        detalT(ShotNum) = detalT1 + detalT2;
    end
    Jcb(:,MPNum(1)+ GamNum) = detalT;
    GamTmp(GamNum) = 0;
end

%% 粗差剔除
TrueIndex = find(strcmp(OBSData.flag,'True')==1);
Jcb(TrueIndex,:)=[];
detalTOri = OBSData.detalT;
detalTOri(TrueIndex,:) = [];
Phi = OBSData.Phi;
Phi(TrueIndex)=[];

%% 无观测数据参数剔�?
DeteleList = [];dX = zeros(MPNum(end),1);
for i = 1:length(knots)
    dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
    index = find(dknots>mode(dknots));
    for j = 1 :length(index)
        DeteleIndex = index(j)-spdeg:index(j);
        DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
    end
end
for i = 1:MPNum(end)
    if length(unique(Jcb(:,i)))<3
        DeteleList =[DeteleList, i];
    end
end
DeteleList = unique(DeteleList);
slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
JCB = Jcb(:,slvidx);

%% 解算模型
JcbMoodel = INIData.JcbMoodel; Mu = INIData.Mu;RobK1 = 3;RobK2 = 5;BSpan = INIData.BSpan;Mu3 = INIData.Mu3;
switch JcbMoodel
    case 1           %% 参数无约束策�?%%
        P = diag(Phi.^2);
        dx = inv(JCB'*P*JCB)*JCB'*P*detalTOri;
        dX(slvidx) = dx;
    case 2          %% 历元间随机约�?%%
        detalT_tmp=[];P= [];
        VirObsNum = (length(detalTOri)-1)*(length(MPNum)-1);
        VirObs = zeros(VirObsNum , MPNum(end));
        for j = 1:length(MPNum)-1
            BlockRow = length(detalTOri)-1;
            Row = BlockRow * (j-1) + 1:BlockRow * j;
            Low = MPNum(j)+1:MPNum(j+1);
            VirObs(Row,Low) = Jcb(2:BlockRow+1,Low)-Jcb(1:BlockRow,Low);
            
            TMP = zeros(1,MPNum(end));
            TMP(Low) = MP(Low);num=1;
            for ShotNum = 1:N_shot
                if ismember(ShotNum,TrueIndex)
                    continue;
                end
                index = OBSData.MTPSign(ShotNum);
                alpha0 = [OBSData.alpha0_Vessel(ShotNum),OBSData.alpha0_Ray(ShotNum)];
                alpha1 = [OBSData.alpha1_Vessel(ShotNum),OBSData.alpha1_Ray(ShotNum)];
                Z0     = [OBSData.Z0_Vessel(ShotNum),OBSData.Z0_Ray(ShotNum)];
                Z1     = [OBSData.Z1_Vessel(ShotNum),OBSData.Z1_Ray(ShotNum)];
                [detalT1] = CalT_ZTD(OBSData.ST(ShotNum),TMP,MPNum,spdeg,...
                    knots,alpha0,Z0,INIData,OBSData.transducer_u0(ShotNum),OBSData.gammar0(ShotNum,:),index,OBSData.Lambda0(ShotNum));
                [detalT2] = CalT_ZTD(OBSData.RT(ShotNum),TMP,MPNum,spdeg,...
                    knots,alpha1,Z1,INIData,OBSData.transducer_u1(ShotNum),OBSData.gammar1(ShotNum,:),index,OBSData.Lambda1(ShotNum));
                tmp_detalT(num,1) = detalT1 + detalT2;
                P_subdiag(num) = (OBSData.ST(ShotNum)+OBSData.RT(ShotNum))/2;
                num= num+1;
            end
            %
            P_sub = diag(1./(P_subdiag(2:end)-P_subdiag(1:end-1)));
            P = blkdiag(P,P_sub);
            detalT_tmp =[detalT_tmp;tmp_detalT(1:end-1,1)-tmp_detalT(2:end,1)];
        end
        JCB        = [Jcb;VirObs];
        
        DeteleList = [];dX = zeros(MPNum(end),1);
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        for i = 1:MPNum(end)
            if length(unique(JCB(:,i)))<3
                DeteleList =[DeteleList, i];
            end
        end
        DeteleList = unique(DeteleList);
        slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
        JCB = JCB(:,slvidx);
        
        detalT     = [detalTOri; detalT_tmp];
        P = blkdiag(diag(Phi.^2),Mu*P);
        dx = inv(JCB'*P*JCB)*JCB'*P*detalT;
        dX(slvidx) = dx;
        
    case 3              %% 节点中点随机游走约束 %%       
        detalT_tmp=[];P= [];
        % 2.将中间时刻带入到B样条基函数求虚拟观测
        Gam_Tmp = zeros(1,MPNum(end)-MPNum(1));
        for GamNum = 1:length(Gam_Tmp)
            Gam_Tmp(GamNum) = 1;
            % 判断参数�?属区�?
            MPList = MPNum - MPNum(1);
            KnotsIndex = interp1([MPList realmax],0:length(MPList),GamNum','next','extrap'); %左开右闭 
            % 1.确定观测区间节点中间时刻
            KnotsMiddleT = (knots{KnotsIndex}(spdeg+1:end-spdeg-1) + knots{KnotsIndex}(spdeg+2:end-spdeg))/2;
            Jcb_Bbase = zeros(length(KnotsMiddleT),1);MP_tmp = [MP(1:MPNum(1)),Gam_Tmp];
            for ShotNum = 1:length(KnotsMiddleT)
                [Jcb_Bbase(ShotNum)] = Bspline_Function(KnotsMiddleT(ShotNum),MP_tmp(MPNum(KnotsIndex)+1:MPNum(KnotsIndex+1)),...
                    knots{KnotsIndex},spdeg,INIData.nchoosekList,2);
            end
            VirObs_tmp(:,MPNum(1)+ GamNum) = Jcb_Bbase;
            Gam_Tmp(GamNum) = 0;
        end
        
        BlockRow = zeros(1,length(MPNum));
        for j = 1:length(MPNum)-1
            KnotsMiddleT = (knots{j}(spdeg+1:end-spdeg-1) + knots{j}(spdeg+2:end-spdeg))/2;
            BlockRow(j+1) = length(KnotsMiddleT)-1;
            CumBlockRow = cumsum(BlockRow);
            Row = CumBlockRow(j) + 1:CumBlockRow(j+1);
            Low = MPNum(j)+1:MPNum(j+1);
            VirObs(Row,Low) = VirObs_tmp(2:end,Low)-VirObs_tmp(1:end-1,Low);
            
            TMP = zeros(1,MPNum(end));
            TMP(Low) = MP(Low);tmp_detalT=zeros(length(KnotsMiddleT),1);
            for ShotNum = 1:length(KnotsMiddleT)
                [tmp_detalT(ShotNum)] = Bspline_Function(KnotsMiddleT(ShotNum),TMP(MPNum(KnotsIndex)+1:MPNum(KnotsIndex+1)),...
                    knots{KnotsIndex},spdeg,INIData.nchoosekList,2);
            end
            dknots = round(knots{j}(2:end)-knots{j}(1:end-1));
            P_sub = diag(mode(dknots)./(KnotsMiddleT(2:end)-KnotsMiddleT(1:end-1)));
            P = blkdiag(P,P_sub);
            detalT_tmp =[detalT_tmp;tmp_detalT(1:end-1,1) - tmp_detalT(2:end,1)];
        end
        VirObs(:,slvidx)=VirObs(:,slvidx);
        JCB = [JCB;VirObs];
        detalT     = [detalTOri; detalT_tmp];
        P = blkdiag(diag(Phi.^2),Mu*P);
        dx = inv(JCB'*P*JCB)*JCB'*P*detalT;
        dX(slvidx) = dx;
        
        
    case 4          %% 参数连续连续性约束策�? %%
        DeteleList = [];Mu_dT=[];detalT_tmp=[];
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            Mu_dT = [Mu_dT,mode(dknots)/BSpan(i)/60];
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        
        VirObsNum = MPNum(end)-MPNum(1)-(length(MPNum)-1)*(spdeg+1);
        VirObs = zeros(VirObsNum,MPNum(end));
        
        for i = 1:length(MPNum)-1
            MU = Mu*sqrt(1/Mu_dT(i));
            
            Row = MPNum(i)+1-MPNum(1)-(spdeg+1)*(i-1):MPNum(i+1)-MPNum(1)-(spdeg+1)*i;
            Column1 = MPNum(i)+1:MPNum(i+1)-spdeg-1;
            Column2 = MPNum(i)+spdeg+2:MPNum(i+1);
            
            for j = 1:length(Row)
                VirObs(Row(j),Column1(j)) = MU;
                VirObs(Row(j),Column2(j)) = -MU;
            end
            detalT_tmp = [detalT_tmp,MP(MPNum(i)+spdeg+2:MPNum(i+1))-MP(MPNum(i)+1:MPNum(i+1)-spdeg-1)];
        end
        JCB        = [Jcb;VirObs];
        detalT     = [detalTOri; detalT_tmp'];
        
        dX = inv(JCB'*JCB)*JCB'*detalT;
        
        % 抗差权RobLS
        %         sig = VarEst(detalTOri,1,'Med');
        %         P = ones(length(detalT),1);
        %         for sk = 1:length(detalT)
        %             P(sk,1)  = P(sk) * IGG3_w(RobK1,RobK2,detalT(sk)/sig);
        %         end
        %         P=diag(P);
        %         dX = inv(JCB'*P*JCB)*JCB'*P*detalT;
        
    case 5
        DeteleList = [];dX = zeros(MPNum(end),1);
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        for i = 1:MPNum(end)
            if length(unique(Jcb(:,i)))<=6
                DeteleList =[DeteleList, i];
            end
        end
        DeteleList = unique(DeteleList);
        slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
        JCB = Jcb(:,slvidx);
        
        % 抗差�?
        sig = VarEst(OBSData.detalT,1,'Med');
        P = ones(N_shot,1);
        for sk = 1:N_shot
            P(sk,1)  = P(sk) * IGG3_w(RobK1,RobK2,OBSData.detalT(sk)/sig);
        end
        P = diag(P);
        dx = inv(JCB'*P*JCB)*JCB'*P*OBSData.detalT;
        dX(slvidx) = dx;
        
    case 6
        DeteleList = [];
        for i = MPNum(1):MPNum(end)
            if length(unique(Jcb(:,i))) <= 6
                DeteleList =[DeteleList, i];
            end
        end
        dDetList = DeteleList(2:end)-DeteleList(1:end-1);
        index = [1,find(dDetList>1)+1];
        if ~isempty(dDetList)
            AddDeteleList = sort([DeteleList,DeteleList(index) - 1]);
            % 添加虚拟观测
            VirObsNum  = length(AddDeteleList);
            VirObs = zeros(VirObsNum,MPNum(end));
            for i = 1:VirObsNum - 1
                VirObs(i,AddDeteleList(i)) = 1;
                VirObs(i,AddDeteleList(i)+1) = -1;
            end
            JCB        = [Jcb;VirObs];
            detalT_tmp = zeros(VirObsNum,1);
            detalT     = [OBSData.detalT; detalT_tmp];
        else
            JCB = Jcb;
            detalT = OBSData.detalT;
        end
        sig = VarEst(OBSData.detalT,1,'Med');
        P = ones(N_shot,1);
        %         for sk = 1:N_shot_Vir
        %             P(sk,1)  = P(sk) * IGG3_w(RobK1,RobK2,detalT(sk)/sig);
        %         end
        P=diag(P);
        dX = inv(JCB'*P*JCB)*JCB'*P*detalT;
        
    case 7
        detalT_tmp=[];P= [];BlockRow = zeros(1,length(MPNum));
        for j = 1:length(MPNum)-1
            if j<MPNum(1)/3+1
                MPIndex = j;
            else
                MPIndex = ceil((j-MPNum(1)/3)/2);
            end
            MTPSign = OBSData.MTPSign;MTPSign(TrueIndex)=[];
            MPOBSIndex = find(MTPSign == (MPIndex-1)*3+1);
            OrdorList = 1:N_shot;OrdorList(TrueIndex)=[];
            Middle_T = (OBSData.ST(OrdorList(MPOBSIndex)) + OBSData.RT(OrdorList(MPOBSIndex)))/2;
            %             Middle_T = (OBSData.ST(MPOBSIndex) + OBSData.RT(MPOBSIndex))/2;
            dknots = round(knots{j}(2:end)-knots{j}(1:end-1));
            TList = interp1([knots{j} realmax],0:length(knots{j}),Middle_T','next','extrap');
            TListIndex = unique(TList);
            MiddleList = zeros(1,length(TListIndex));
            for k =1:length(TListIndex)
                SpanIndex = find(TList==TListIndex(k));
                ObsSpanTLsit = Middle_T(SpanIndex);
                KnotsMiddleT = (knots{j}(TListIndex(k))+knots{j}(TListIndex(k)+1))/2;
                [~,SpanIndexIndex] = min(abs(ObsSpanTLsit - KnotsMiddleT));
                MiddleList(k) = MPOBSIndex(SpanIndex(SpanIndexIndex));
                % MiddleList(k) = fix(median(find(TList==TListIndex(k))));
            end
            BlockRow(j+1) = length(MiddleList)-1;
            CumBlockRow = cumsum(BlockRow);
            Row = CumBlockRow(j) + 1:CumBlockRow(j+1);
            Low = MPNum(j)+1:MPNum(j+1);
            VirObs(Row,Low) = Jcb(MiddleList(2:end),Low)-Jcb(MiddleList(1:end-1),Low);
            
            TMP = zeros(1,MPNum(end));
            TMP(Low) = MP(Low);num=1;tmp_detalT=[];P_subdiag=[];
            
            for ShotNum = 1:length(MiddleList)
                index = OBSData.MTPSign(OrdorList(MiddleList(ShotNum)));
                alpha0 = [OBSData.alpha0_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.alpha0_Ray(OrdorList(MiddleList(ShotNum)))];
                alpha1 = [OBSData.alpha1_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.alpha1_Ray(OrdorList(MiddleList(ShotNum)))];
                Z0     = [OBSData.Z0_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.Z0_Ray(OrdorList(MiddleList(ShotNum)))];
                Z1     = [OBSData.Z1_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.Z1_Ray(OrdorList(MiddleList(ShotNum)))];
                [detalT1] = CalT_ZTD(OBSData.ST(OrdorList(MiddleList(ShotNum))),TMP,MPNum,spdeg,knots,...
                    alpha0,Z0,INIData,OBSData.transducer_u0(OrdorList(MiddleList(ShotNum))),OBSData.gammar0(OrdorList(MiddleList(ShotNum)),:),index,OBSData.Lambda0(OrdorList(MiddleList(ShotNum))));
                [detalT2] = CalT_ZTD(OBSData.RT(OrdorList(MiddleList(ShotNum))),TMP,MPNum,spdeg,knots,...
                    alpha1,Z1,INIData,OBSData.transducer_u1(OrdorList(MiddleList(ShotNum))),OBSData.gammar1(OrdorList(MiddleList(ShotNum)),:),index,OBSData.Lambda1(OrdorList(MiddleList(ShotNum))));
                tmp_detalT(num,1) = (detalT1 + detalT2);
                P_subdiag(num) = (OBSData.ST(OrdorList(MiddleList(ShotNum)))+ OBSData.RT(OrdorList(MiddleList(ShotNum))))/2;
                num= num+1;
            end
            %
            P_sub = diag(mode(dknots)./(P_subdiag(2:end)-P_subdiag(1:end-1)));
            P = blkdiag(P,P_sub);
            detalT_tmp =[detalT_tmp;tmp_detalT(1:end-1,1)-tmp_detalT(2:end,1)];
        end
        JCB        = [Jcb;VirObs];
        
        DeteleList = [];dX = zeros(MPNum(end),1);
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        for i = 1:MPNum(end)
            if length(unique(JCB(:,i)))<3
                DeteleList =[DeteleList, i];
            end
        end
        DeteleList = unique(DeteleList);
        slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
        JCB = JCB(:,slvidx);
        
        detalT     = [detalTOri; detalT_tmp];
        P = blkdiag(diag(Phi.^2),Mu*P);
        dx = inv(JCB'*P*JCB)*JCB'*P*detalT;
        dX(slvidx) = dx;
        
    case 8
        detalT_tmp=[];P= [];BlockRow = zeros(1,length(MPNum));
        for j = 1:length(MPNum)-1
            OrdorList = 1:N_shot;OrdorList(TrueIndex)=[];
            if j<MPNum(1)/3+1
                MPIndex = j;
                MTPSign = OBSData.MTPSign;MTPSign(TrueIndex)=[];
                MPOBSIndex = find(MTPSign == (MPIndex-1)*3+1);
                Middle_T = (OBSData.ST(OrdorList(MPOBSIndex)) + OBSData.RT(OrdorList(MPOBSIndex)))/2;
            else
                MTPSign = OBSData.MTPSign;MTPSign(TrueIndex)=[];
                MPOBSIndex = find(MTPSign > 0);
                Middle_T = (OBSData.ST(OrdorList(MPOBSIndex)) + OBSData.RT(OrdorList(MPOBSIndex)))/2;
            end
            
            dknots = round(knots{j}(2:end)-knots{j}(1:end-1));
            TList = interp1([knots{j} realmax],0:length(knots{j}),Middle_T','next','extrap');
            TListIndex = unique(TList);
            MiddleList = zeros(1,length(TListIndex));
            for k =1:length(TListIndex)
                SpanIndex = find(TList==TListIndex(k));
                ObsSpanTLsit = Middle_T(SpanIndex);
                KnotsMiddleT = (knots{j}(TListIndex(k))+knots{j}(TListIndex(k)+1))/2;
                [~,SpanIndexIndex] = min(abs(ObsSpanTLsit - KnotsMiddleT));
                MiddleList(k) = MPOBSIndex(SpanIndex(SpanIndexIndex));
                % MiddleList(k) = fix(median(find(TList==TListIndex(k))));
            end
            BlockRow(j+1) = length(MiddleList)-1;
            CumBlockRow = cumsum(BlockRow);
            Row = CumBlockRow(j) + 1:CumBlockRow(j+1);
            Low = MPNum(j)+1:MPNum(j+1);
            VirObs(Row,Low) = Jcb(MiddleList(2:end),Low)-Jcb(MiddleList(1:end-1),Low);
            
            TMP = zeros(1,MPNum(end));
            TMP(Low) = MP(Low);num=1;tmp_detalT=[];P_subdiag=[];
            
            for ShotNum = 1:length(MiddleList)
                index = OBSData.MTPSign(OrdorList(MiddleList(ShotNum)));
                alpha0 = [OBSData.alpha0_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.alpha0_Ray(OrdorList(MiddleList(ShotNum)))];
                alpha1 = [OBSData.alpha1_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.alpha1_Ray(OrdorList(MiddleList(ShotNum)))];
                Z0     = [OBSData.Z0_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.Z0_Ray(OrdorList(MiddleList(ShotNum)))];
                Z1     = [OBSData.Z1_Vessel(OrdorList(MiddleList(ShotNum))),OBSData.Z1_Ray(OrdorList(MiddleList(ShotNum)))];
                [detalT1] = CalT_ZTD(OBSData.ST(OrdorList(MiddleList(ShotNum))),TMP,MPNum,spdeg,knots,...
                    alpha0,Z0,INIData,OBSData.transducer_u0(OrdorList(MiddleList(ShotNum))),OBSData.gammar0(OrdorList(MiddleList(ShotNum)),:),index,OBSData.Lambda0(OrdorList(MiddleList(ShotNum))));
                [detalT2] = CalT_ZTD(OBSData.RT(OrdorList(MiddleList(ShotNum))),TMP,MPNum,spdeg,knots,...
                    alpha1,Z1,INIData,OBSData.transducer_u1(OrdorList(MiddleList(ShotNum))),OBSData.gammar1(OrdorList(MiddleList(ShotNum)),:),index,OBSData.Lambda1(OrdorList(MiddleList(ShotNum))));
                tmp_detalT(num,1) = (detalT1 + detalT2);
                P_subdiag(num) = (OBSData.ST(OrdorList(MiddleList(ShotNum)))+ OBSData.RT(OrdorList(MiddleList(ShotNum))))/2;
                num= num+1;
            end
            %
            P_sub = diag(mode(dknots)./(P_subdiag(2:end)-P_subdiag(1:end-1)));
            P = blkdiag(P,P_sub);
            detalT_tmp =[detalT_tmp;tmp_detalT(1:end-1,1)-tmp_detalT(2:end,1)];
        end
        JCB        = [Jcb;VirObs];
        
        DeteleList = [];dX = zeros(MPNum(end),1);
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        for i = 1:MPNum(end)
            if length(unique(JCB(:,i)))<3
                DeteleList =[DeteleList, i];
            end
        end
        DeteleList = unique(DeteleList);
        slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
        JCB = JCB(:,slvidx);
        
        detalT     = [detalTOri; detalT_tmp];
        P = blkdiag(diag(Phi.^2),Mu*P);
        dx = inv(JCB'*P*JCB)*JCB'*P*detalT;
        dX(slvidx) = dx;
    case 9
        Low = MPNum(1)-3;
        C = zeros(Low,MPNum(end));Wx = zeros(Low,1);
        for i = 1:Low
            C(i,i) = 1;
            C(i,i+3) = -1;
            Wx(i) = INIData.MP(i) - INIData.MP(i+3) + MP(i+3) - MP(i);
        end
        
        P1 = diag(Phi.^2);P2 = diag(ones(Low,1));
        NBB = JCB'*P1*JCB;Wl = JCB'*P1*detalTOri;
        NCC = C*inv(NBB)*C';
        dx = (inv(NBB)-inv(NBB)*C'*inv(NCC)*C*inv(NBB))*Wl+inv(NBB)*C'*inv(NCC)*(-Wx);
        dX(slvidx) = dx;
    case 10
        Low = MPNum(1)-3;
        C = zeros(Low,MPNum(end));Wx = zeros(Low,1);
        for i = 1:Low
            C(i,i) = 1;
            C(i,i+3) = -1;
            Wx(i) = INIData.MP(i) - INIData.MP(i+3) + MP(i+3) - MP(i);
        end
        
        P1 = diag(Phi.^2);P2 = diag(ones(Low,1));
        P = blkdiag(P1,Mu3*P2);
        JCB =[JCB;C];detalTOri = [detalTOri;Wx];
        dx = inv(JCB'*P*JCB)*JCB'*P*detalTOri;
        
        dX(slvidx) = dx;
        
        
end
end