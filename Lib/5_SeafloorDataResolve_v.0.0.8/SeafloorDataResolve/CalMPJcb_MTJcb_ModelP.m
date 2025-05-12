function [dX] = CalMPJcb_MTJcb_ModelP(OBSData,INIData,SVP,MP,detalp)
N_shot=str2double(INIData.Data_file.N_shot);
MTs=unique(OBSData.MT);
Jcb=zeros(N_shot,length(MP));
nu=[0];detalTT=[];
SVPDataFix.PF= PFGrad(SVP,2,1);
%% 按照海底点坐标进行构建雅可比矩阵
for MTNum=1:length(MTs)
    index=find(strcmp(OBSData.MT,{MTs{MTNum}})==1);
    nu=[nu,length(index)];
    num=cumsum(nu);
    for XYZNum=1:3
        MP((MTNum-1)*3+XYZNum)=MP((MTNum-1)*3+XYZNum)+detalp;
        for IndexNum=1:length(index)
            i=index(IndexNum);
            ModelTT1=P2PInvRayTrace([OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)],MP(1+(MTNum-1)*3:3+(MTNum-1)*3),SVPDataFix);
            ModelTT2=P2PInvRayTrace([OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)],MP(1+(MTNum-1)*3:3+(MTNum-1)*3),SVPDataFix);
            ModelT(IndexNum)=ModelTT1+ModelTT2;
        end
        Jcb(num(MTNum)+1:num(MTNum+1),(MTNum-1)*3+XYZNum)=(ModelT'-OBSData.ModelT(index)')/detalp;
        MP((MTNum-1)*3+XYZNum)=MP((MTNum-1)*3+XYZNum)-detalp;
    end
    detalTT=[detalTT;OBSData.detalT(:,index)'];
end
dX=inv(Jcb'*Jcb)*Jcb'*detalTT;
end

