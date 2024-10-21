function [ModelT_MP_T,ModelT_MP_T_OBSData] = compPositResu_v002(OBSFilePath,SVPFilePath,INIFilePath)
%% ����˵��
%���ܣ�002�汾ģ�Ͷ�λ
%% ���ܴ���
Model = [1,0,1,1,1,1];BList=[35]; % 分段大致间隔
[OBSData,SVP,INIData,MP1] = ReadData2Struct_002_xz(OBSFilePath,SVPFilePath,INIFilePath);
INIData.Data_file.N_shot = num2str(length(OBSData.ant_e0));
% 数据解算B样条参数区间设置及个数设�?
INIData.BSpan =[15,BList,BList,BList,BList]; % *ones(1,length(MP1)/3)
%基本参数确定
INIData.JcbMoodel = Model(1);INIData.Mu = Model(2);INIData.TModel = Model(3);INIData.Mu3 = 100000;
INIData.Ray_ENModel=Model(4);INIData.Vessel_ENModel=Model(5);INIData.cosZ = Model(6);
spdeg=3;
%1.B样条节点构�??
[knots,MPNum]=Make_Bspline_knots(OBSData,spdeg,INIData.BSpan);%
%2.臂长转化
[OBSData,INIData,MP,MPNum] = Ant_ATD_Transducer_002(OBSData,INIData,SVP,MP1,MPNum,spdeg);
%3. 解算
[ModelT_MP_T,ModelT_MAXLoop2,ModelT_MP_T_OBSData] = TCalModelT_002_xz(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,0);
end
