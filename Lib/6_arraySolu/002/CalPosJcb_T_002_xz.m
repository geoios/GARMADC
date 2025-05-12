function [OBSData] = CalPosJcb_T_002_xz(OBSData,INIData,SVP,MP,MPNum,knots,spdeg)
N_shot=str2double(INIData.Data_file.N_shot);
% SVPDataCri.PF= PFGrad(SVP,2,1);
PF= PFGrad(SVP,2,1);
[EachPos,dCenPos] = deal(MP(1:MPNum(1)-3),MP(MPNum(1)-2:MPNum(1)));
EachPos = EachPos + repmat(dCenPos,1,MPNum(1)/3-1);
%% 计算传波时间
for ShotNum = 1:N_shot
    index = OBSData.MTPSign(ShotNum);
    
    Transducer_ENU_ST = [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)];
    Transducer_ENU_RT = [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)];
    
    alpha0_Ray = GetAzimuth(Transducer_ENU_ST(1:2), EachPos(index:index+1));
    alpha1_Ray = GetAzimuth(Transducer_ENU_RT(1:2), EachPos(index:index+1));
    OBSData.alpha0_Ray(ShotNum) = alpha0_Ray;
    OBSData.alpha1_Ray(ShotNum) = alpha1_Ray;
    

    Z0_Ray = norm(Transducer_ENU_ST(1:2) - EachPos(index:index+1))/-(EachPos(index+2)-Transducer_ENU_ST(3));
    Z1_Ray = norm(Transducer_ENU_RT(1:2) - EachPos(index:index+1))/-(EachPos(index+2)-Transducer_ENU_RT(3));
    OBSData.Z0_Ray(ShotNum) = Z0_Ray;
    OBSData.Z1_Ray(ShotNum) = Z1_Ray;


    alpha0 = [OBSData.alpha0_Vessel(ShotNum),alpha0_Ray];
    alpha1 = [OBSData.alpha1_Vessel(ShotNum),alpha1_Ray];
    
    Z0 = [OBSData.Z0_Vessel(ShotNum),Z0_Ray];
    Z1 = [OBSData.Z1_Vessel(ShotNum),Z1_Ray];


    [~,t0,gammar0,alfae0,cos_AvgBeta0] = RayJac_Num(Transducer_ENU_ST,EachPos(index:index+2),PF);
    [~,t1,gammar1,alfae1,cos_AvgBeta1] = RayJac_Num(Transducer_ENU_RT,EachPos(index:index+2),PF);  
    
    OBSData.gammar0(ShotNum,:) = gammar0;
    OBSData.gammar1(ShotNum,:) = gammar1;
    OBSData.alfae0(ShotNum,:) = alfae0;
    OBSData.alfae1(ShotNum,:) = alfae1;
    
    OBSData.Lambda0(ShotNum) = cos(atan(Z0_Ray))^-1 * cos_AvgBeta0;
    OBSData.Lambda1(ShotNum) = cos(atan(Z0_Ray))^-1 * cos_AvgBeta1;
    
    [detalT1] = CalT_ZTD_002(OBSData.ST(ShotNum),MP,MPNum,spdeg,knots,alpha0,Z0,INIData,OBSData.transducer_u0(ShotNum),gammar0,index,OBSData.Lambda0(ShotNum));
    [detalT2] = CalT_ZTD_002(OBSData.RT(ShotNum),MP,MPNum,spdeg,knots,alpha1,Z1,INIData,OBSData.transducer_u1(ShotNum),gammar1,index,OBSData.Lambda1(ShotNum));

    SinPhi0 = (Transducer_ENU_ST(3)-MP(index+2))/norm(MP(index:index+2)-Transducer_ENU_ST);
    SinPhi1 = (Transducer_ENU_RT(3)-MP(index+2))/norm(MP(index:index+2)-Transducer_ENU_RT);
    OBSData.Phi(ShotNum) = (SinPhi0 + SinPhi1)/2;
    
    
    OBSData.CompensateT(ShotNum) = detalT1 + detalT2;
    OBSData.ModelT(ShotNum) = (t0 + t1) + OBSData.CompensateT(ShotNum);
end 
OBSData.detalT = OBSData.TT - OBSData.ModelT';
%% 残差剔除
FalseIndex = find(strcmp(OBSData.flag,'False')==1);
dTmean = mean(OBSData.detalT(FalseIndex));
dTstd = std(OBSData.detalT(FalseIndex));
Uplimit = dTmean + 3.5 * dTstd;
DownLimit = dTmean - 3.5 * dTstd;
for j=1:N_shot
    if OBSData.detalT(j) < DownLimit
        OBSData.flag{j} = 'True';
    elseif OBSData.detalT(j) > Uplimit
        OBSData.flag{j} = 'True';
    else 
        OBSData.flag{j} = 'False';
    end
end
end

