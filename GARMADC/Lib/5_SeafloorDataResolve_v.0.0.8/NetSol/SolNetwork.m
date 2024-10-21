function [zz,Delay,dL_Com_Rob,MeanTime,ResOutput,RecTime] = SolNetwork(AllObsPath,SVPPath,ObsData,ArmLen,x_Jap) 
% function [zz,Delay,dL_Com_Rob,MeanTime] = SolNetwork(AllObsPath,SVPPath,ObsData,ArmLen,x_Jap,CutTime,Muu) 
%% ++++++++++++ 参数配置 +++++++++++
AllObs     = ReadNSinex(AllObsPath);
StnInf     = [AllObs.Header.Site_name,AllObs.Header.DateUTC];
StnInf     = strrep(StnInf,'-','_');
AllObs     = AllObs.Data.SET_LN_MT;

StnSeq = unique(AllObs(:,3));
StnNum       = length(StnSeq) ;   % 解算点号
BreakTime    = 1.3 * 60;          % 间断时间(Unit:Sec) % 1.3
CutTime      = 5 * 60;            % 分块时间(Unit:Sec)  % 2,1.4
% CutTime      = CutTime * 60;    % 分块时间(Unit:Sec)
MedBreakTime = 3000000000 * 60;   % 间断时间(Unit:Sec) 
MedCutTime   = 3000000000 * 60;   % 分块时间(Unit:Sec)
% 参数约束矩阵
Mu = [zeros(1,3*StnNum) 1000 1000 10000 100000*ones(1,StnNum) 10000]; 
Mu_Delay    = [0 0 0];
Mu_MedDelay = [10000 10000 10000];
% 附加参数连续性约束
Mu2 = 10;
% Mu2 = Muu;
Mu3 = 1;
% 分段时间差（权）定义方式
WeightType = 3;   % 1-等权; 2-时间差; 3-时间差倒数; 4-时间差倒数平方 
% 定位点迭代收敛条件
MaxIter     = 20;
Termination = 10^-4;
% 粗差
RobK1 = 3;
RobK2 = 5;

%% ++++++++++++ 整体信息获取 +++++++++++
% [数据提取索引] 
DelayIdx     = [4];         % 声线传播时间
STimeIdx     = [9];         % 声线发射时刻时间
RTimeIdx     = [16];        % 声线接收时刻时间
SControlIdx  = [10 11 12];  % 声线发射时刻坐标
RControlIdx  = [17 18 19];  % 声线接收时刻坐标
SAttitudeIdx = [13 14 15];  % 声线发射时刻姿态
RAttitudeIdx = [20 21 22];  % 声线接收时刻姿态

% [数据整体信息获取] 
AllObsNum  = size(AllObs,1);
LinkList = zeros(StnNum,AllObsNum);
for i = 1:AllObsNum
    iObsNo = AllObs(i,3);
    StnLoc = find(StnSeq==iObsNo);    
    LinkList(StnLoc,i) = 1;
end
AllObsTime = AllObs(:,STimeIdx);
MeanTime = mean(AllObsTime);
RecTime = [AllObs(1,9);AllObs(end,9)];

% [观测数据断点探测]
BreakPoint = BreakPointDetect(AllObsTime,BreakTime);
BreakPoint(end) = BreakPoint(end) + 1;
% 延迟分段
[BlockIdx,MeanSecTime] = TimeSegment(BreakPoint,CutTime,AllObsTime);
% 中心点延迟分段
MedBreakPoint = BreakPointDetect(AllObsTime,MedBreakTime);
MedBreakPoint(end) = MedBreakPoint(end) + 1;
[MedBlockIdx,MedMeanSecTime] = TimeSegment(MedBreakPoint,MedCutTime,AllObsTime);

%% ++++++++++++ 数据提取 ++++++++++++
% [延迟时段差值计算]
BlockNum = length(BlockIdx);
for i = 1:BlockNum - 1
    DeltaSecTime(i,:) = MeanSecTime(i+1) - MeanSecTime(i);
end
Mu1 = BlockWeight(DeltaSecTime,Mu2,WeightType);

% [延迟时段差值计算]
MedBlockNum = length(MedBlockIdx);
for i = 1:MedBlockNum - 1
    MedDeltaSecTime(i,:) = MedMeanSecTime(i+1) - MedMeanSecTime(i);
end
if MedBlockNum ==1
    Mu4 = 1;
else
    Mu4 = BlockWeight(MedDeltaSecTime,Mu3,WeightType);
end
% [延迟约束+中心延迟约束]
Mu_Delay    = repmat(Mu_Delay,1,BlockNum);
Mu_MedDelay = repmat(Mu_MedDelay,1,MedBlockNum);

%% ++++++++++++ 声速剖面数据处理 ++++++++++++
SVPData = ReadNSinex(SVPPath);
% PF      = SVPData.Data.depth;
PF      = SVPData.Data.SVP;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [声速剖面拓展]
WindowNum = 2;          
Order     = 1;         
PF        = PFGrad(PF,WindowNum,Order); 
% [协议声速计算]
c0 = MeanVel(PF);

% [参数初值设置]
x0 = [];  % [x_Jap(1,:),x_Jap(2,:),x_Jap(3,:),x_Jap(4,:)];
for i = 1:StnNum
    x0 = [x0,x_Jap(i,:)];
end

HDelay = zeros(1,StnNum);
RadVel = 0;
MainX  = [x0,ArmLen(1:3),HDelay,RadVel];
MainParNum = length(MainX);

BlockNum = length(BlockIdx);
Delay    = zeros(1,3*BlockNum);     % iBlockDelay = [ZDelay NDelay EDelay]
DelayNum = BlockNum * 3;
DelayPos = MainParNum+1:MainParNum + 3*BlockNum;

MedDelay    = zeros(1,3*MedBlockNum);
MedDelayNum = MedBlockNum * 3;
MedDelayPos = DelayPos(end)+1:DelayPos(end) + 3*MedBlockNum;

x_ini = [MainX,Delay,MedDelay];
ParNum = length(x_ini);

StnBlockInf = zeros(StnNum,BlockNum);
Record = [];     % Temp

for Loop = 1:MaxIter
    B_Com  = [];
    dL_Com = [];
    P_Com  = [];

    for sn = 1:StnNum    
       Stnx0(sn,:) =  x_ini(3*sn-2:3*sn);
    end
    
    MedPoint = mean(Stnx0);
    
    for s = 1:StnNum
        sObs = ObsData{s};
        sLinkList = LinkList(s,:);
        % [观测数据提取]
        DelayTime  = sObs(:,DelayIdx);
        SEpochTime = sObs(:,STimeIdx);
        REpochTime = sObs(:,RTimeIdx);
        SPoints    = sObs(:,SControlIdx);
        RPoints    = sObs(:,RControlIdx);
        SAttitude  = sObs(:,SAttitudeIdx);
        RAttitude  = sObs(:,RAttitudeIdx);

        % [观测值计算]
        L             = DelayTime * c0;
        sDataNum      = size(DelayTime,1);
        StnDataNum(s) = sDataNum;
        % [迭代变量清除]
        % 坐标、旋转矩阵
        STraLoc = []; SRs = []; RTraLoc = []; RRs = [];
        % 设计矩阵、时间延迟、距离
        e1 = []; t1 = []; dis1 = []; e2 = []; t2 = []; dis2 = [];
        % 臂长
        ArmE1 = []; ArmE2 = [];
        % 水平延迟
        SCosElv = []; RCosElv = [];
        STanElv = []; RTanElv = [];
        fSN = []; fRN = []; bSN = []; bRN = [];
        fSE = []; fRE = []; bSE = []; bRE = [];
        % 行驶速率
        SVelocity = []; RVelocity = [];
 
        for i = 1:sDataNum
            % 臂长转换
            [STraLoc(i,:),SRs(:,:,i)] = ArmCalibration_Jap(x_ini(3*StnNum+1:3*StnNum+3)',SAttitude(i,:),SPoints(i,:));
            [RTraLoc(i,:),RRs(:,:,i)] = ArmCalibration_Jap(x_ini(3*StnNum+1:3*StnNum+3)',RAttitude(i,:),RPoints(i,:));
            % 坐标部分
            [e1(i,:),t1(i,:)] = RayJac_Num(STraLoc(i,:),x_ini(3*s-2:3*s),PF);
            dis1(i,:) = t1(i,:) * c0;
            [e2(i,:),t2(i,:)] = RayJac_Num(RTraLoc(i,:),x_ini(3*s-2:3*s),PF);
            dis2(i,:) = t2(i,:) * c0;
            % 臂长部分
            ArmE1(i,:) = [e1(i,:) * SRs(:,1,i),e1(i,:) * SRs(:,2,i),e1(i,:) * SRs(:,3,i)];
            ArmE2(i,:) = [e2(i,:) * RRs(:,1,i),e2(i,:) * RRs(:,2,i),e2(i,:) * RRs(:,3,i)];
        end
        Dis = dis1 + dis2;
        % 天顶延迟(垂直方向)
        SElevation = e1(:,3);
        RElevation = e2(:,3);
        % 1/Sina --> Mapping fun
        MapE1 = 1./SElevation;
        MapE2 = 1./RElevation;
 
        % 天顶延迟(水平方向)
        SCosAzi = e1(:,2);
        RCosAzi = e2(:,2);
        SSinAzi = e1(:,1);
        RSinAzi = e2(:,1);
        for t =1:sDataNum
            SCosElv(t,:) = sqrt(1-SElevation(t)^2);
            RCosElv(t,:) = sqrt(1-RElevation(t)^2);
            STanElv(t,:) = SElevation(t)/ SCosElv(t);
            RTanElv(t,:) = RElevation(t)/ RCosElv(t);
            bSN(t,:) = SCosAzi(t) * (1/(SElevation(t) + STanElv(t)));
            bRN(t,:) = RCosAzi(t) * (1/(RElevation(t) + RTanElv(t)));
            bSE(t,:) = SSinAzi(t) * (1/(SElevation(t) + STanElv(t)));
            bRE(t,:) = RSinAzi(t) * (1/(RElevation(t) + RTanElv(t)));
        end
        
        StaP = 1; EndP = 0;
        f1  = []; f2  = [];
        fSN = []; fRN = [];
        fSE = []; fRE = [];
        
       
        for k = 1:BlockNum
    
            kBlock = BlockIdx{k};                     % 整体时间分块
            BlockEpochNum = sLinkList(kBlock);        % 时间分块链表
            StnBlockNum  = sum(BlockEpochNum);        % 测站分块观测个数
            StnBlockInf(s,k) = StnBlockNum;
            %%%%%% Note:可能有空矩阵的存在
            if StnBlockNum == 0
                continue
            end
            EndP = EndP + StnBlockNum;
            kBlockIdx = 3*k-2:3*k;
            % 垂直方向Z
            kf1 = MapE1(StaP:EndP,:) * x_ini(DelayPos(kBlockIdx(1)));
            kf2 = MapE2(StaP:EndP,:) * x_ini(DelayPos(kBlockIdx(1)));

            f1 = [f1;kf1];
            f2 = [f2;kf2];
            % 水平方向N
            kfSN = SCosAzi(StaP:EndP,:) .* x_ini(DelayPos(kBlockIdx(2))) .* (1./(SElevation(StaP:EndP,:) + STanElv(StaP:EndP,:)));
            kfRN = RCosAzi(StaP:EndP,:) .* x_ini(DelayPos(kBlockIdx(2))) .* (1./(RElevation(StaP:EndP,:) + RTanElv(StaP:EndP,:)));
            fSN = [fSN;kfSN];
            fRN = [fRN;kfRN];
            % 水平方向E
            kfSE = SSinAzi(StaP:EndP,:) .* x_ini(DelayPos(kBlockIdx(3))) .* (1./(SElevation(StaP:EndP,:) + STanElv(StaP:EndP,:)));
            kfRE = RSinAzi(StaP:EndP,:) .* x_ini(DelayPos(kBlockIdx(3))) .* (1./(RElevation(StaP:EndP,:) + RTanElv(StaP:EndP,:)));
            fSE = [fSE;kfSE];
            fRE = [fRE;kfRE];
            StaP = EndP + 1;
        end
        fZ = f1  + f2 ;
        fN = fSN + fRN;
        fE = fSE + fRE;  
        
        % 中心点延迟
        sMedDiff = (Stnx0(s,:) - MedPoint)/1000; % 
        B_MedSZ  = MapE1  * sMedDiff(3);
        B_MedRZ  = MapE2  * sMedDiff(3);
        B_MedSN  = bSN * sMedDiff(1);
        B_MedRN  = bRN * sMedDiff(1);
        B_MedSE  = bSE * sMedDiff(2);
        B_MedRE  = bRE * sMedDiff(2);
        
        Medf1  = [];  Medf2 = [];
        MedfSN = [];  MedfRN = [];
        MedfSE = [];  MedfRE = [];
        StaP = 1; EndP = 0;
        for k = 1:MedBlockNum
            kBlock = MedBlockIdx{k};                     % 整体时间分块
            BlockEpochNum = sLinkList(kBlock);        % 时间分块链表
            MedStnBlockNum  = sum(BlockEpochNum);        % 测站分块观测个数
            MedStnBlockInf(s,k) = MedStnBlockNum;
            %%%%%% Note:可能有空矩阵的存在
            if MedStnBlockNum == 0
                continue
            end
            EndP = EndP + MedStnBlockNum;
            kBlockIdx = 3*k-2:3*k;
            % 垂直方向Z
            kMedf1 = B_MedSZ(StaP:EndP,:) * x_ini(MedDelayPos(kBlockIdx(1)));
            kMedf2 = B_MedRZ(StaP:EndP,:) * x_ini(MedDelayPos(kBlockIdx(1)));
            Medf1 = [Medf1;kMedf1];
            Medf2 = [Medf2;kMedf2];
            % 水平方向N
            kMedfSN = B_MedSN(StaP:EndP,:) .* x_ini(MedDelayPos(kBlockIdx(2))); 
            kMedfRN = B_MedRN(StaP:EndP,:) .* x_ini(MedDelayPos(kBlockIdx(2)));
            MedfSN = [MedfSN;kMedfSN];
            MedfRN = [MedfRN;kMedfRN];
            % 水平方向E
            kMedfSE = B_MedSE(StaP:EndP,:) .* x_ini(MedDelayPos(kBlockIdx(3))) ;
            kMedfSE = B_MedRE(StaP:EndP,:) .* x_ini(MedDelayPos(kBlockIdx(3))) ;
            MedfSE = [MedfSE;kMedfSE];
            MedfRE = [MedfRE;kMedfSE];
            StaP = EndP + 1;
        end
        
        MedfZ = Medf1  + Medf2 ;
        MedfN = MedfSN + MedfRN;
        MedfE = MedfSE + MedfRE;
        
        % 硬件延迟       15 ????
        fHDelay = x_ini(3*StnNum+3+s) * c0 * ones(sDataNum,1);

        % 径向速率
        for j = 1:sDataNum
            X_velocity = (RTraLoc(j,1) - STraLoc(j,1))/DelayTime(j);
            Y_velocity = (RTraLoc(j,2) - STraLoc(j,2))/DelayTime(j);
            Z_velocity = (RTraLoc(j,3) - STraLoc(j,3))/DelayTime(j);
            SVelocity(j,:)  = e1(j,:) * [X_velocity Y_velocity Z_velocity]';
            RVelocity(j,:)  = e2(j,:) * [X_velocity Y_velocity Z_velocity]';
        end
        
        fRadVel = (SVelocity + RVelocity) * x_ini(3*StnNum+3+StnNum+1);

        % 设计矩阵生成
        E1 = [e1 ArmE1 ones(sDataNum,1)*c0 SVelocity MapE1 bSN bSE B_MedSZ B_MedSN B_MedSE];
        E2 = [e2 ArmE2 ones(sDataNum,1)*c0 RVelocity MapE2 bRN bRE B_MedRZ B_MedRN B_MedRE];
        
        B  = E1 + E2;
        dL = L - (Dis + 2*fHDelay + fRadVel + fZ + fN + fE + MedfZ + MedfN + MedfE);
        % 初始权
        sig = VarEst(dL,1,'Med');
        P = ones(sDataNum,1);
        for sk = 1:sDataNum
            P(sk,1)  = P(sk) * IGG3_w(RobK1,RobK2,dL(sk)/sig);
        end
        DelayMat{s}    = B(:,9:11);   
        MedDelayMat{s} = B(:,12:14);
    
        B_Com  = [B_Com;B];
        dL_Com = [dL_Com;dL];
        P_Com  = [P_Com;P];
    end
    % [矩阵分裂]
    % 测站坐标 + 硬件延迟部分
    StnCol = 1:3;
    HarCol = 7;
    StnSta = 1;
    StnEnd = 0;
    B_Stn = []; 
    B_Har = [];
    for o = 1:StnNum
        oStnObsNum =  StnDataNum(o);
        StnEnd = StnEnd + oStnObsNum;
        oStnB = B_Com(StnSta:StnEnd,StnCol);
        oHarB = B_Com(StnSta:StnEnd,HarCol);
        B_Stn = blkdiag(B_Stn,oStnB);
        B_Har = blkdiag(B_Har,oHarB);
        StnSta = StnEnd + 1;
    end

    % 臂长部分
    B_Arm = B_Com(:,4:6);

    % 径向速率
    B_Rad = B_Com(:,8);

    % 延迟部分
    B_Delay = [];
    for r = 1:StnNum
        rDelay = zeros(StnDataNum(r),3*BlockNum);
        rRowSta = 1;
        rRowEnd = 0;
        for z = 1:BlockNum
            if StnBlockInf(r,z) == 0
                continue
            end
            rColSta = 3 * z - 2;
            rColEnd = 3 * z;
            rRowEnd = rRowEnd + StnBlockInf(r,z);
            zBlock = DelayMat{r}(rRowSta:rRowEnd,:);
            rDelay(rRowSta:rRowEnd,rColSta:rColEnd) = zBlock;  
            rRowSta = rRowEnd + 1;        
        end
        B_Delay    = [B_Delay;rDelay]; 
    end
    
    % 中心点延迟部分
    B_MedDelay = [];
    for r = 1:StnNum
        rDelayMed = zeros(StnDataNum(r),3*MedBlockNum);
        rRowSta = 1;
        rRowEnd = 0;
        for z = 1:MedBlockNum
            if MedStnBlockInf(r,z) == 0
                continue
            end
            rColSta = 3 * z - 2;
            rColEnd = 3 * z;
            rRowEnd = rRowEnd + MedStnBlockInf(r,z);
            zBlockMed = MedDelayMat{r}(rRowSta:rRowEnd,:);
            rDelayMed(rRowSta:rRowEnd,rColSta:rColEnd) = zBlockMed;      
            rRowSta = rRowEnd + 1;        
        end
        B_MedDelay = [B_MedDelay;rDelayMed];
    end
   
     BB = [B_Stn,B_Arm,B_Har,B_Rad,B_Delay,B_MedDelay];
     % 约束
     BlockVar = x_ini(DelayPos);
     ZDelay   = BlockVar(1:3:end);
     NDelay   = BlockVar(2:3:end);
     EDelay   = BlockVar(3:3:end);
     
     MedBlockVar = x_ini(MedDelayPos);
     MedZDelay   = MedBlockVar(1:3:end);
     MedNDelay   = MedBlockVar(2:3:end);
     MedEDelay   = MedBlockVar(3:3:end);

     ConsL = [];
     MedConsL = [];
     ConsMat = zeros(3*(BlockNum-1),3*BlockNum + MainParNum + 3*MedBlockNum);
     MedConsMat = zeros(3*(MedBlockNum-1),3*BlockNum + MainParNum + 3*MedBlockNum);
     
     DiffMat = [-1*eye(3),eye(3)];
     % 延迟部分约束
     for t = 1:BlockNum - 1
         % 约束(矩阵)
         RowS = 3 * t - 2;
         RowE = 3 * t;
         ColS = 3 * t - 2 + MainParNum;
         ColR = 3 * t + 3 + MainParNum;      
         ConsMat(RowS:RowE,ColS:ColR) = DiffMat;
         % 约束(观测值)
         iConsL = -[ZDelay(t+1) - ZDelay(t)
                    NDelay(t+1) - NDelay(t)
                    EDelay(t+1) - EDelay(t)];
         ConsL = [ConsL;iConsL];
     end
     
     % 中心点延迟部分约束
     for t = 1:MedBlockNum - 1
         % 约束(矩阵)
         RowS = 3 * t - 2;
         RowE = 3 * t;
         MedColS = 3 * t - 2 + MainParNum + 3*BlockNum;
         MedColR = 3 * t + 3 + MainParNum + 3*BlockNum;
         MedConsMat(RowS:RowE,MedColS:MedColR) = DiffMat;
         % 约束(观测值)
         iMedConsL = -[MedZDelay(t+1) - MedZDelay(t)
                       MedNDelay(t+1) - MedNDelay(t)
                       MedEDelay(t+1) - MedEDelay(t)];
         MedConsL = [MedConsL;iMedConsL];
     end
   
     % 主参数约束
     ConsMain  = diag(Mu);
     ConsMainL = (MainX - x_ini(1:MainParNum)).*Mu;
     
     % 延迟约束
     ConsDelay   = diag(Mu_Delay);
     ConsDelayL  = (Delay - x_ini(DelayPos)).*Mu_Delay;
     
     % 中心延迟约束
     ConsMedDelay   = diag(Mu_MedDelay);
     ConsMedDelayL  = (MedDelay - x_ini(MedDelayPos)).*Mu_MedDelay;
     

     % 附加参数约束
     ConsMat = [[ConsMain zeros(MainParNum,DelayNum+MedDelayNum)];Mu1.*ConsMat;Mu4.*MedConsMat;...
                [zeros(DelayNum,MainParNum) ConsDelay zeros(DelayNum,MedDelayNum)];...
                [zeros(MedDelayNum,MainParNum+DelayNum) ConsMedDelay] ];
     ConsL   = [ConsMainL';ConsL.*Mu1;MedConsL.*Mu4;ConsDelayL';ConsMedDelayL'];
     
     ConsP   = ones(length(ConsL),1);
     
     % 方程 + 约束
     Com_A = [BB;ConsMat];
     Com_L = [dL_Com;ConsL];
     Com_P = [P_Com;ConsP];
     
     [dx,sigma,L_est,v,N,Qx,J] = WLS(Com_A,Com_L,Com_P);
     dL_Com_Rob = dL_Com.*P_Com;

     Record_dx(Loop,:) = dx';
     x_ini(1:StnNum*3)     = x_ini(1:StnNum*3) - dx(1:StnNum*3)';
     x_ini(StnNum*3+1:end) = x_ini(StnNum*3+1:end) + dx(StnNum*3+1:end)';
     
     for i = 1:StnNum
         Stn_S = 3 * i - 2;
         Stn_T = 3 * i;
         Har_S = 15 + i;
         iStn = x_ini(Stn_S:Stn_T);
         iArm = x_ini(3*StnNum+1:15);
         iHar = x_ini(Har_S);
         iRad = x_ini(20);
         iDel = x_ini(21:end);
         iRec = [iStn,iArm,iHar,iRad,iDel];
         Record = [Record;iRec];
     end
     
     if max(abs(dx)) < Termination
         % 粗差率
         ErrorNum = length(find(P_Com==0));
         ResOutput.ErrorRate = ErrorNum/length(P_Com);
         % 单位权中误差
         ResOutput.Sigma = sigma;
         % 三维坐标分量方差
         Sigmaii = diag(Qx);
         LocSigmaii = Sigmaii(1:3*StnNum)*sigma^2;
         for mm = 1:StnNum
             LocSigma(mm,:) = LocSigmaii(3*mm-2:3*mm);
         end
         ResOutput.Dx = sqrt(LocSigma);      
         break;
     end
end
Loop

for gg = 1:StnNum
    SolRes(gg,:) =  x_ini(3*gg-2:3*gg);
end

diffval = SolRes - x_Jap;
zz = [StnSeq ones(StnNum,1) SolRes ones(StnNum,1) x_Jap ones(StnNum,1) diffval];

BlockVar = x_ini(DelayPos);
ZDelay   = BlockVar(1:3:end);
NDelay   = BlockVar(2:3:end);
EDelay   = BlockVar(3:3:end);
Delay    = [ZDelay' NDelay' EDelay'];

MedBlockVar = x_ini(MedDelayPos);
MedZDelay   = MedBlockVar(1:3:end);
MedNDelay   = MedBlockVar(2:3:end);
MedEDelay   = MedBlockVar(3:3:end);

MedDelay = [MedZDelay' MedNDelay' MedEDelay'];







