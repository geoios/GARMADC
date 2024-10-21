function [dX] = CalMPJcb_MTJcb_T_ModelP(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,detalp,H)
N_shot=str2double(INIData.Data_file.N_shot);
MTs=unique(OBSData.MT);
Jcb=zeros(N_shot,MPNum(end));
SVPDataCri.PF= PFGrad(SVP,2,1);
nu=[0];detalTT=[];
%% 按照海底点坐标进行构建雅可比矩阵
for MTNum=1:length(MTs)
    index=find(strcmp(OBSData.MT,{MTs{MTNum}})==1);
    nu=[nu,length(index)];
    num=cumsum(nu);
    for XYZNum=1:3
        MP((MTNum-1)*3+XYZNum)=MP((MTNum-1)*3+XYZNum)+detalp(1);
        for IndexNum=1:length(index)
            i=index(IndexNum);
            ModelTT1=P2PInvRayTrace([OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)],MP(1+(MTNum-1)*3:3+(MTNum-1)*3),SVPDataCri);
            ModelTT2=P2PInvRayTrace([OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)],MP(1+(MTNum-1)*3:3+(MTNum-1)*3),SVPDataCri);
            [gammer1]=CalGammer(OBSData.ST(i),MP(MPNum(1)+1:MPNum(end)),spdeg,knots);
%             [gammer2]=CalGammer(OBSData.RT(i),MP(MPNum(1)+1:MPNum(end)),spdeg,knots);
            ModelT(IndexNum)=log(ModelTT1+ModelTT2)-gammer1;% (gammer1+gammer2)/2;
        end
        Jcb(num(MTNum)+1:num(MTNum+1),(MTNum-1)*3+XYZNum)=(ModelT'-OBSData.LogModelT(index)')/detalp(1);
        MP((MTNum-1)*3+XYZNum)=MP((MTNum-1)*3+XYZNum)-detalp(1);
    end

    GamTmp=zeros(1,MPNum(end)-MPNum(1));
    for GamNum=1:length(GamTmp)
        GamTmp(GamNum)=GamTmp(GamNum)+1;
        for IndexNum=1:length(index)
            i=index(IndexNum);
            [gammer1]=CalGammer(OBSData.ST(i),GamTmp,spdeg,knots);
%             [gammer2]=CalGammer(OBSData.RT(i),GamTmp,spdeg,knots);
            Gammer(i)=gammer1;% (gammer1+gammer2)/2;
        end
        Jcb(num(MTNum)+1:num(MTNum+1),length(MTs)*3+GamNum)=-Gammer(index);
        GamTmp(GamNum)=GamTmp(GamNum)-1;
    end
    detalTT=[detalTT;OBSData.LogdetalT(:,index)'];
end
dX=inv(Jcb'*Jcb+H)*Jcb'*detalTT;
end

