function [MP,MAXLoop2,OBSData] = TCalModelP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H)
%% 2.迭代计算
for MAXLoop2=1:20
    [OBSData]=CalPosJcb_T(OBSData,INIData,SVP,MP,MPNum,knots,spdeg);
    [dX]=CalMPJcb_MTJcb_T_ModelP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H);
    MP=MP+dX';
    dxmax=max(abs(dX));dposmax=max(abs(dX(MPNum(1))));
    if dxmax<5*10^-4|| dposmax<5*10^-5
        break;
    elseif dxmax<0.005
        iconv=iconv+1;
        if iconv==2
            break;
        end
    else
        iconv=0;
    end
end
[OBSData]=CalPosJcb_T(OBSData,INIData,SVP,MP,MPNum,knots,spdeg);
end

