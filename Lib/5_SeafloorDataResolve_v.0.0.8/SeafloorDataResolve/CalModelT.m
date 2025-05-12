function [MP,MAXLoop2,OBSData] = CalModelT(OBSData,INIData,SVP,MP,detalp)
for MAXLoop2=1:20
    [OBSData]=CalPosJcb(OBSData,INIData,SVP,MP);
    [dX]=CalMPJcb_MTJcb_ModelT(OBSData,INIData,SVP,MP,detalp);
    MP=MP+dX';
    dposmax=max(abs(dX))
    if dposmax<5*10^-5
        break;
    end
end
[OBSData]=CalPosJcb(OBSData,INIData,SVP,MP);
end

