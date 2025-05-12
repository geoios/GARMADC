function [MP,MAXLoop1,OBSData] = CalModelP(OBSData,INIData,SVP,MP,deltap)
for MAXLoop1=1:20
    [OBSData]=CalPosJcb(OBSData,INIData,SVP,MP);
    [dX]=CalMPJcb_MTJcb_ModelP(OBSData,INIData,SVP,MP,deltap);
    MP=MP+dX';
    dxmax=max(abs(dX));
    if dxmax<5*10^-5
        break;
%     elseif dxmax<0.005
%         iconv=iconv+1;
%         if iconv==2
%             break;
%         end
%     else
%         iconv=0;
    end
end
    [OBSData]=CalPosJcb(OBSData,INIData,SVP,MP);
end

