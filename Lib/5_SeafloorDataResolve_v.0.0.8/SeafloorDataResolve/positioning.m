function [positX0] = positioning(StaObsFileDetaPath,StaSvpFileDetaPath,IniFileDetaPath)
%% 函数说明
%功能：纯声线跟踪单点定位程序封装
%输入：+StaObsFileDetaPath 标准化观测文件详细路径
%      +StaSvpFileDetaPath 标准化声速剖面文件详细路径
%      +IniFileDetaPath 配置文件详细路径
%输出：

%% 功能代码
%传递观测文件路径
GNSSAFilePath = StaObsFileDetaPath;%模块接口
SVPFilePath = StaSvpFileDetaPath;%模块接口
ConfigFile = IniFileDetaPath;%模块接口

% + Reading GNSSA data+++++++++++++++++++++++++++++++++++++++++++++++++++++
GNSSAData    = ReadNSinex(GNSSAFilePath);
TotalObsData = GNSSAData.Data.SET_LN_MT;  
% + Reading Sound velocity profile data
SVPData    = ReadNSinex(SVPFilePath);
PF         = SVPData.Data.SVP;  
% + Reading Config data
ConfigData = ReadNSinex(ConfigFile);

% [Observation information obtaining]
ArmLength = GNSSAData.Header.Arm_Len;            
Stations  = str2num(GNSSAData.Header.Site_No);    % Number of stations
Sessions  = str2num(GNSSAData.Header.Sessions);   % Number of sessions
Lines     = str2num(GNSSAData.Header.Lines);      % Number of lines
StationX0 = Extraction_x0(ConfigData);

    for iStationNum = 1:size(Stations,2)
        [positX0(iStationNum,:),STraLoc{iStationNum,1}] = dealWithFun(iStationNum,TotalObsData,PF,ArmLength,Stations,StationX0);
        %plotPositTrack(STraLoc{iStationNum,1},positX0(iStationNum,:));hold on
    end
    
    function [positX0,STraLoc] = dealWithFun(iStationNum,TotalObsData,PF,ArmLength,Stations,StationX0)
        % [Parameter setting]
        % + Solution parameters setting
        Session  = 1;
        Line     = inf;
        Station  = Stations(iStationNum);%海底站
        IdxExtra = [Session Line Station]; 
        Stn_x0   = StationX0(iStationNum,:);
        % + Solve iteration parameters setting
        MaxIter     = 20;
        Termination = 10^-4;
        RobK1 = 3;
        RobK2 = 4;

        % [Observation data index] 
        DelayIdx     = [4];         % Acoustic ray travel time (round trip)
        STimeIdx     = [9];         % Acoustic ray emission time
        RTimeIdx     = [16];        % Acoustic ray receive time
        SControlIdx  = [10 11 12];  % Acoustic ray emission accordinate
        RControlIdx  = [17 18 19];  % Acoustic ray receive accordinate
        SAttitudeIdx = [13 14 15];  % Acoustic ray emission attitude
        RAttitudeIdx = [20 21 22];  % Acoustic ray receive attitude

        % [Observation data extraction]
        Idxs       = MatchIdx(TotalObsData(:,1:3),IdxExtra);  
        ObsData    = TotalObsData(Idxs,:);
        DelayTime  = ObsData(:,DelayIdx);%传播时间
        SEpochTime = ObsData(:,STimeIdx);%时刻 
        REpochTime = ObsData(:,RTimeIdx);
        SPoints    = ObsData(:,SControlIdx);%控制点坐标 
        RPoints    = ObsData(:,RControlIdx); 
        SAttitude  = ObsData(:,SAttitudeIdx);%姿态
        RAttitude  = ObsData(:,RAttitudeIdx);

        % [Observation information processing]
        % + Sound velocity profile data processing
        WindowNum = 2;          
        Order     = 1;         
        PF        = PFGrad(PF,WindowNum,Order); 
        c0        = MeanVel(PF);
        % + Acoustic delay time observations
        L         = DelayTime * c0;
        ObsNum    = size(DelayTime,1);
        P         = ones(ObsNum,1);
        x0        = [Stn_x0(2),Stn_x0(1),Stn_x0(3)];

        % [Acoustic ray tracing positioning algorithm]%定位算法
        for Loop = 1:MaxIter
            for i = 1:ObsNum%单历元
                % + Arm length conversion
                [STraLoc(i,:),SRs(:,:,i)] = ArmCalibration_Jap(ArmLength(1:3)',SAttitude(i,:),SPoints(i,:));
                [RTraLoc(i,:),RRs(:,:,i)] = ArmCalibration_Jap(ArmLength(1:3)',RAttitude(i,:),RPoints(i,:));
                % + Fish information matrix
                [e1(i,:),t1(i,:)] = RayJac_Num(STraLoc(i,:),x0,PF);%发射
                dis1(i,:)         = t1(i,:) * c0;
                [e2(i,:),t2(i,:)] = RayJac_Num(RTraLoc(i,:),x0(1:3),PF);%接收
                dis2(i,:)         = t2(i,:) * c0;
            end
            A  = e1 + e2;
            dL = L - (dis1 + dis2);
            %传播时间残差
            dt = DelayTime - (t1 + t2);
            % + IGG3 weighted function
            sig = VarEst(dL,1,'Med');
            for sk = 1:ObsNum
                P(sk,1)  = P(sk) * IGG3_w(RobK1,RobK2,dL(sk)/sig);
            end
            % + Least square solution
            [dx,sigma,L_est,v,N,Qx,J] = WLS(A,dL,P);
            x0 = x0 - dx';
            if norm(dx) < Termination
                break
            end
        end

        SElevation = e1(:,3);
        RElevation = e2(:,3);
        for k = 1:ObsNum
            PFSplit1 = SplitPF(PF,abs(STraLoc(k,3)),PF(end,1));
            PFSplit2 = SplitPF(PF,abs(RTraLoc(k,3)),PF(end,1));
            IncAngle1(k,:) = pi/2 - asin(SElevation(k,:));
            IncAngle2(k,:) = pi/2 - asin(RElevation(k,:));
            [dL1(k,:),c1_Zenith1] = DelayError(PFSplit1,c0,abs(x0(3))-abs(STraLoc(k,3)),IncAngle1(k,:));
            [dL2(k,:),c1_Zenith2] = DelayError(PFSplit2,c0,abs(x0(3))-abs(RTraLoc(k,3)),IncAngle2(k,:));
        end
        ddddl = [dL1,dL2];

        SElevation = SElevation * (180/pi);
        RElevation = RElevation * (180/pi);

        %% 输出量
        positX0 = x0;
    end
end