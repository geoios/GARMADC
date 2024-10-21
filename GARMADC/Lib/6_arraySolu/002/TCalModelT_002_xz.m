function [MP,MAXLoop2,OBSData] = TCalModelT_002_xz(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,H)
for MAXLoop2=1:20
    OBSData         =   CalPosJcb_T_002_xz(OBSData,INIData,SVP,MP,MPNum,knots,spdeg);
    [dX,JCB]              =   CalMPJcb_MTJcb_T_ModelT_002_xz(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,H);
    MP              =	MP  + dX';
    
    [dposmax(MAXLoop2),index]  =  max(abs(dX(1:MPNum(1))))
    if dposmax(MAXLoop2)<5*10^-4
        break;
    end
    
end
% figure(MAXLoop2)
% OBSData         =   CalPosJcb_T(OBSData,INIData,SVP,MP,MPNum,knots,spdeg);
% FigSet.FontSize=18;FigSet.Size=[0,0,20,15];FigSet.PaperPosition=[0,0,20,10];
% FigSet.LineType = 'b-';FigSet.lineWidth = 1;FigSet.linewidth = 1;
% FigSet.TitleName=['MYGI.1104(涓夎浜斿弬鏁?)-',num2str(MAXLoop2)];
% FigSet.xlabelName = ['\fontname{瀹嬩綋}{\it瑙傛祴鍘嗗厓}\fontname{瀹嬩綋}{\it(涓?)}'];
% FigSet.ylabelName = ['\fontname{瀹嬩綋}{\it璺濈娈嬪樊}\fontname{Times new roman}{\it(m)}'];
% FigSet.legendName = ['璺濈娈嬪樊搴忓垪'];
% FigSet.StorgePath = ['FigResults\',FigSet.TitleName,'_Span',num2str(INIData.BSpan),'_Mu',num2str(INIData.Mu),'.png'];
% [RMS,RSS,STD] = dLPlot(OBSData,SVP,FigSet);%
close all
% save(['FigResults\JCB_',num2str(MAXLoop2),'.mat'],'JCB');
end

