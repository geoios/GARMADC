function [dX] = CalMPJcb_MTJcb_SVP_ModelP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,detalp,H)
N_shot=str2double(INIData.Data_file.N_shot);
MTs=unique(OBSData.MT);
Jcb=zeros(N_shot,MPNum(end));
nu=[0];detalTT=[];
%% 按照海底点坐标进行构建雅可比矩阵
for MTNum=1:length(MTs)
    index=find(strcmp(OBSData.MT,{MTs{MTNum}})==1);
    nu=[nu,length(index)];
    num=cumsum(nu);
    for XYZNum=1:MPNum(end)-(length(MTs)-1)*3
        if XYZNum>3
            MP(length(MTs)*3+(XYZNum-3))=MP(length(MTs)*3+(XYZNum-3))+detalp(2);
        else
            MP((MTNum-1)*3+XYZNum)=MP((MTNum-1)*3+XYZNum)+detalp(1);
        end
        for IndexNum=1:length(index)
            i=index(IndexNum);
            [NewSVPStr]=CalSVP(OBSData.ST(i),SVP,MP(MPNum(1)+1:MPNum(end)),spdeg,knots);
%             [NewSVPEnd]=CalSVP(OBSData.RT(i),SVP,MP(MPNum(1)+1:MPNum(end)),spdeg,knots);
            SVPDataStr.PF= PFGrad(NewSVPStr,2,1);
%             SVPDataEnd.PF= PFGrad(NewSVPEnd,2,1);
            ModelTT1=P2PInvRayTrace([OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)],MP(1+(MTNum-1)*3:3+(MTNum-1)*3),SVPDataStr);
            ModelTT2=P2PInvRayTrace([OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)],MP(1+(MTNum-1)*3:3+(MTNum-1)*3),SVPDataStr);
            ModelT(IndexNum)=ModelTT1+ModelTT2;
        end
        if XYZNum>3
            Jcb(num(MTNum)+1:num(MTNum+1),length(MTs)*3+(XYZNum-3))=(ModelT'-OBSData.ModelT(index)')/detalp(2);
            MP(length(MTs)*3+(XYZNum-3))=MP(length(MTs)*3+(XYZNum-3))-detalp(2);
        else
            Jcb(num(MTNum)+1:num(MTNum+1),(MTNum-1)*3+XYZNum)=(ModelT'-OBSData.ModelT(index)')/detalp(1);
            MP((MTNum-1)*3+XYZNum)=MP((MTNum-1)*3+XYZNum)-detalp(1);
        end
    end
    detalTT=[detalTT;OBSData.detalT(:,index)'];
end
dX=inv(Jcb'*Jcb+H)*Jcb'*detalTT;
end

