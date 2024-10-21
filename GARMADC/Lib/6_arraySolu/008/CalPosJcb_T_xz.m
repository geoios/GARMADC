function [OBSData] = CalPosJcb_T_xz(soluType,OBSData,INIData,MP,MPNum,knots,spdeg)
N_shot=str2double(INIData.Data_file.N_shot);
% SVPDataCri.PF= PFGrad(SVP,2,1);
% PF= PFGrad(SVP,2,1);
[EachPos,dCenPos] = deal(MP(1:MPNum(1)-3),MP(MPNum(1)-2:MPNum(1)));
EachPos = EachPos + repmat(dCenPos,1,MPNum(1)/3-1);
MP_U_Avg = abs(mean(EachPos(3:3:end)));
%% 璁＄畻浼犳尝鏃堕棿
for ShotNum = 1:N_shot
    index = OBSData.MTPSign(ShotNum);
    
    Transducer_ENU_ST = [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)];
    Transducer_ENU_RT = [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)];
    
    % 璁＄畻鏂逛綅瑙?
    alpha0_Ray = GetAzimuth(Transducer_ENU_ST(1:2), EachPos(index:index+1));
    alpha1_Ray = GetAzimuth(Transducer_ENU_RT(1:2), EachPos(index:index+1));
    OBSData.alpha0_Ray(ShotNum) = alpha0_Ray;
    OBSData.alpha1_Ray(ShotNum) = alpha1_Ray;
    alpha0 = [OBSData.alpha0_Vessel(ShotNum),alpha0_Ray];
    alpha1 = [OBSData.alpha1_Vessel(ShotNum),alpha1_Ray];
    
    % 璁＄畻tan(澶╅《瑙?)
    Z0_Ray = norm(Transducer_ENU_ST(1:2) - EachPos(index:index+1))/-(EachPos(index+2)-Transducer_ENU_ST(3));
    Z1_Ray = norm(Transducer_ENU_RT(1:2) - EachPos(index:index+1))/-(EachPos(index+2)-Transducer_ENU_RT(3));
    OBSData.Z0_Ray(ShotNum) = Z0_Ray;
    OBSData.Z1_Ray(ShotNum) = Z1_Ray;
    Z0 = [OBSData.Z0_Vessel(ShotNum),Z0_Ray];
    Z1 = [OBSData.Z1_Vessel(ShotNum),Z1_Ray];
    
    % 璁＄畻鍗忚澹伴?熸俯鐩愬帇寤惰繜
    [delayOut0,kc0] = compDelayCorr(INIData.intePos,INIData.souH,MP_U_Avg,Z0_Ray,INIData.ParGrid);
    [delayOut1] = compDelayCorr(INIData.intePos,INIData.souH,MP_U_Avg,Z1_Ray,INIData.ParGrid);
    OBSData.kc0(ShotNum) = kc0;
    % 璁＄畻澹伴?熷満璺濈绯荤粺璇樊
    [detalL1] = CalT_ZTD(OBSData.ST(ShotNum),MP,MPNum,spdeg,knots,Z0,alpha0,INIData);
    [detalL2] = CalT_ZTD(OBSData.RT(ShotNum),MP,MPNum,spdeg,knots,Z1,alpha1,INIData);
    
    % 璁＄畻鍏ュ皠瑙掓潈鍑芥暟
    SinPhi0 = (Transducer_ENU_ST(3)-EachPos(index+2))/norm(EachPos(index:index+2)-Transducer_ENU_ST);
    SinPhi1 = (Transducer_ENU_RT(3)-EachPos(index+2))/norm(EachPos(index:index+2)-Transducer_ENU_RT);
    OBSData.Phi(ShotNum) = (SinPhi0 + SinPhi1)/2;
    
    % 璁＄畻鍑犱綍璺濈
    L0 = norm(Transducer_ENU_ST - EachPos(index:index+2));
    L1 = norm(Transducer_ENU_RT - EachPos(index:index+2));
    
    OBSData.CompensateL(ShotNum) = detalL1 + detalL2;
    if(soluType == 1)%无静延迟
        OBSData.ModelL(ShotNum,:) = (L0+L1)*kc0 + OBSData.CompensateL(ShotNum);
    elseif(soluType == 2)%一阶静延迟
        OBSData.ModelL(ShotNum,:) = (L0+L1)*kc0 + sum(delayOut0(1:3)) + sum(delayOut1(1:3)) + OBSData.CompensateL(ShotNum);
    elseif(soluType == 3 || soluType == 4)%两阶静延迟
        OBSData.ModelL(ShotNum,:) = (L0+L1)*kc0 + sum(delayOut0) + sum(delayOut1) + OBSData.CompensateL(ShotNum);
    else
        error('soluType 错误')
    end
    %OBSData.detalL(ShotNum,:) = (L0+L1) - (OBSData.TT(ShotNum,:)*INIData.Cc + sum(delayOut0) + sum(delayOut1) + OBSData.CompensateL(ShotNum))/kc0;
end
OBSData.detalL = OBSData.TT*INIData.Cc - OBSData.ModelL;
%% 娈嬪樊鍓旈櫎
FalseIndex = find(strcmp(OBSData.flag,'False')==1);
dLmean = mean(OBSData.detalL(FalseIndex));
dTstd = std(OBSData.detalL(FalseIndex));
Uplimit = dLmean + 3.5 * dTstd;
DownLimit = dLmean - 3.5 * dTstd;
for j=1:N_shot
    if OBSData.detalL(j) < DownLimit
        OBSData.flag{j} = 'True';
    elseif OBSData.detalL(j) > Uplimit
        OBSData.flag{j} = 'True';
    else
        OBSData.flag{j} = 'False';
    end
end
end

