function [MP,MAXLoop2,OBSData] = TCalModelT(soluType,OBSData,INIData,MP,MPNum,knots,spdeg,H)
for MAXLoop2=1:20
    OBSData         =   CalPosJcb_T(soluType,OBSData,INIData,MP,MPNum,knots,spdeg);
    [dX,JCB]              =   CalMPJcb_MTJcb_T_ModelT(OBSData,INIData,MP,MPNum,knots,spdeg,H);
    MP              =	MP  + dX';
    
    [dposmax(MAXLoop2),index]  =  max(abs(dX(1:MPNum(1))))
    if dposmax(MAXLoop2)<5*10^-4
        break;
    end
    
end
%OBSData         =   CalPosJcb_T(OBSData,INIData,SVP,MP,MPNum,knots,spdeg);
% figure(MAXLoop2)
% FigSet.FontSize=18;FigSet.Size=[0,0,20,15];FigSet.PaperPosition=[0,0,20,10];
% FigSet.LineType = 'b-';FigSet.lineWidth = 1;FigSet.linewidth = 1;
% %FigSet.TitleName=['MYGI.1103(AAAA)-',num2str(MAXLoop2)];
% FigSet.TitleName=['ͼ'];
% FigSet.xlabelName = ['\fontname{Times new roman}{AAAA}}'];
% FigSet.ylabelName = ['\fontname{Times new roman}{AAAA}\fontname{Times new roman}{\it(m)}'];
% FigSet.legendName = ['AAAA'];
% FigSet.StorgePath = ['FigResults\',FigSet.TitleName,'_Span',num2str(INIData.BSpan),'_Mu',num2str(INIData.Mu),'.png'];
%[RMS,RSS,STD] = dLPlot(OBSData,SVP,FigSet);%
% close all
% save(['FigResults\JCB_',num2str(MAXLoop2),'.mat'],'JCB');
end

