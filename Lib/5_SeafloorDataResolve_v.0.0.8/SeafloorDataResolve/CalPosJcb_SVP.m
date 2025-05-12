function [OBSData] = CalPosJcb_SVP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg)
N_shot=str2double(INIData.Data_file.N_shot);
%% 计算传波时间
for i=1:N_shot
    index=OBSData.MTPSign(i);
    Transducer_ENU_ST=[OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)];
    Transducer_ENU_RT=[OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)];
    [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_ST,MP(index:index+2),[INIData.SurE0Mean,INIData.SurN0Mean],INIData);
    [NewSVPEnd]=CalSVP(OBSData.RT(i),SVP,MP,MPNum,spdeg,knots,Transducer_ENU_RT,MP(index:index+2),[INIData.SurE1Mean,INIData.SurN1Mean],INIData);
    SVPDataStr.PF= PFGrad(NewSVPStr,2,1);
    SVPDataEnd.PF= PFGrad(NewSVPEnd,2,1);
    ModelTT1=P2PInvRayTrace(Transducer_ENU_ST,MP(index:index+2),SVPDataStr);
    ModelTT2=P2PInvRayTrace(Transducer_ENU_RT,MP(index:index+2),SVPDataEnd);
    OBSData.ModelT(i)=ModelTT1+ModelTT2;
    OBSData.detalT(i)=OBSData.TT(i)-OBSData.ModelT(i);
end
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

