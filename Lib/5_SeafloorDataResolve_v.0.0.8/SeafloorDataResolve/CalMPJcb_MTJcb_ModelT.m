function [dX,Jcb] = CalMPJcb_MTJcb_ModelT(OBSData,INIData,SVP,MP,detalp)
N_shot=str2double(INIData.Data_file.N_shot);
Jcb=zeros(N_shot,length(MP));
%% 按照历元顺序进行构建雅可比矩阵
for MPIndex=1:length(MP)
    MP(MPIndex)=MP(MPIndex)+detalp;
    for ShotNum=1:N_shot
        index=OBSData.MTPSign(ShotNum);
        SVPDataFix.PF= PFGrad(SVP,2,1);
        ModelTT1=P2PInvRayTrace([OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)],MP(index:index+2),SVPDataFix);
        ModelTT2=P2PInvRayTrace([OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)],MP(index:index+2),SVPDataFix);
        ModelT(ShotNum)=ModelTT1+ModelTT2;
    end
    Jcb(:,MPIndex)=(ModelT'-OBSData.ModelT')/detalp;
    MP(MPIndex)=MP(MPIndex)-detalp;
end
dX=inv(Jcb'*Jcb)*Jcb'*OBSData.detalT';
end

