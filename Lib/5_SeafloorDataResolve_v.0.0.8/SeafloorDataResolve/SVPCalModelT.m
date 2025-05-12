function [MP,MAXLoop1,OBSData] = SVPCalModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H)
for MAXLoop1=1:30
    [OBSData] = CalPosJcb_SVP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg);
    dX        = CalMPJcb_MTJcb_SVP_ModelT(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H);
    MP        =  MP + dX';
    MPArray(MAXLoop1,:)        =     MP;
    [dposmax(MAXLoop1),index]  =  max(abs(dX(1:MPNum(1))))   % dxmax=max(abs)         =  dX(index);
    MaxdetalT(MAXLoop1)        =  max(OBSData.detalT)
    posnormList(MAXLoop1)      =    norm(dX(1:MPNum(1)));
    if dposmax(MAXLoop1)<1*10^-5
        break; 
    end
    if MAXLoop1>=5
        if var(posnormList(MAXLoop1-4:MAXLoop1))<10^-2
            break;
        end
    end
end
[OBSData]=CalPosJcb_SVP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg);
end 