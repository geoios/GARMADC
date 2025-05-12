function [OBSData,INIData,MPArray,MPNum] = Ant_ATD_Transducer(OBSData,INIData,MP,MPNum,spdeg)
%%
MPNum = [length(MP),MPNum];
MPNum = cumsum(MPNum);
MPArray = zeros(1,MPNum(end));
MPArray(1:MPNum(1))=MP;

%% 0.臂长参数转换
N_shot=str2double(INIData.Data_file.N_shot);
ATD=INIData.Model_parameter.ANT_to_TD.ATDoffset;%.MT_Pos
for i=1:N_shot
    [ st_de,st_dn,st_du] = Transform(OBSData.head0(i),OBSData.pitch0(i),OBSData.roll0(i),ATD(1),ATD(2),ATD(3));
    [ rt_de,rt_dn,rt_du] = Transform(OBSData.head1(i),OBSData.pitch1(i),OBSData.roll1(i),ATD(1),ATD(2),ATD(3));
    X1=[OBSData.ant_e0(i),OBSData.ant_n0(i),OBSData.ant_u0(i)]+[ st_de,st_dn,st_du];
    X2=[OBSData.ant_e1(i),OBSData.ant_n1(i),OBSData.ant_u1(i)]+[ rt_de,rt_dn,rt_du];
    OBSData.transducer_e0(i)=X1(1);OBSData.transducer_n0(i)=X1(2);OBSData.transducer_u0(i)=X1(3);
    OBSData.transducer_e1(i)=X2(1);OBSData.transducer_n1(i)=X2(2);OBSData.transducer_u1(i)=X2(3);
end

%% 1.海面中心位置
SurE0Mean=mean(OBSData.ant_e0);SurN0Mean=mean(OBSData.ant_n0);
SurE1Mean=mean(OBSData.ant_e1);SurN1Mean=mean(OBSData.ant_n1);
INIData.SurE0Mean=SurE0Mean;INIData.SurN0Mean=SurN0Mean;
INIData.SurE1Mean=SurE1Mean;INIData.SurN1Mean=SurN1Mean;

%% 2.海面点和海面中心点相对E、N距离
for ShotNum=1:N_shot
    index = OBSData.MTPSign(ShotNum);
    
    Transducer_ENU_ST = [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)];
    Transducer_ENU_RT = [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)];
    
    OBSData.alpha0_Vessel(ShotNum)   = GetAzimuth([SurE0Mean,SurN0Mean], [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum)]);
    OBSData.Z0_Vessel(ShotNum) = norm(Transducer_ENU_ST(1:2) - [SurE0Mean,SurN0Mean])/-(MP(index+2)-Transducer_ENU_ST(3));
    
    OBSData.alpha1_Vessel(ShotNum)   = GetAzimuth([SurE1Mean,SurN1Mean], [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum)]);
    OBSData.Z1_Vessel(ShotNum) = norm(Transducer_ENU_RT(1:2) - [SurE1Mean,SurN1Mean])/-(MP(index+2)-Transducer_ENU_RT(3));
end

%% 3.海底与测船相对E、N距离
MTNum=MPNum(1)/3;
for i=1:MTNum
    MPArrray(i,:)=MP((i-1)*3+1:(i-1)*3+3);
end
MPCen = mean(MPArrray,1);
INIData.MPCen = MPCen;

% for i=1:N_shot
%     OBSData.mtde(i) =   MP(OBSData.MTPSign(i))-MPCen(1);
%     OBSData.mtdn(i) =   MP(OBSData.MTPSign(i)+1)-MPCen(2);
%     OBSData.sta0_u(i) = MP(OBSData.MTPSign(i)+2);
% end
%% 解算时是否�?�虑高程变化
INIData.HightModel = 'Double_exp';% Constent
INIData.sigma      = [8000,800;8000,800;8000,800];
INIData.U_Cri      = 250;
%% 时变配置函数编写
WriteSubSVP(INIData,MPNum);
%% 组合排列构建�?
for j = 0:spdeg
    INIData.nchoosekList(j + 1) = nchoosek(spdeg+1,j);
end

%% 单层声�?�场模型情形（忽略声速场水平梯度垂向声�?�变化）
% 积分�?
% SVP = PFGrad(SVP,2,1);
% SVPLayerNum = size(SVP,1);
% syms U
% gammar1 = 0;gammar2 = 0;
% for i = 1: SVPLayerNum -1
%     C = (SVP(i,2) + SVP(i,4) * (U - SVP(i,1)))^-2;
%     gammar1  = gammar1 + double(int(C,SVP(i,1),SVP(i+1,1)));
%     CU = U * (SVP(i,2) + SVP(i,4) * (U - SVP(i,1)))^-2;
%     gammar2  = gammar2 + double(int(CU,SVP(i,1),SVP(i+1,1)));
% end
% INIData.gammar1 = gammar1;INIData.gammar2 = gammar2;


%% 构建产品模型
%[ParGrid] = makeParGrid(INIData.svpInfo); % svpInfo来自Argo
%[INIData.ParGrid] = INIData.ParGrid;%inteModeling(ParGrid);
INIData.Cc = 1402.392 + 46.691403254999995745 + 17.449376005599997548;
end

