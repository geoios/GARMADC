function [OBSData] = CalPosJcb(OBSData,INIData,SVP,MP)
N_shot=str2double(INIData.Data_file.N_shot);
SVPDataFix.PF= PFGrad(SVP,2,1);
%% 计算传波时间
for i=1:N_shot
    index=OBSData.MTPSign(i);
    ModelTT1=P2PInvRayTrace([OBSData.transducer_e0(i),OBSData.transducer_n0(i),OBSData.transducer_u0(i)],MP(index:index+2),SVPDataFix);
    ModelTT2=P2PInvRayTrace([OBSData.transducer_e1(i),OBSData.transducer_n1(i),OBSData.transducer_u1(i)],MP(index:index+2),SVPDataFix);
    OBSData.ModelT(i)=ModelTT1+ModelTT2;
    OBSData.detalT(i)=OBSData.TT(i)-OBSData.ModelT(i);
end

