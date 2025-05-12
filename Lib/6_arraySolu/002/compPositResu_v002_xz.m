function [ModelT_MP_T,ModelT_MP_T_OBSData] = compPositResu_v002(OBSFilePath,SVPFilePath,INIFilePath)
%% 函数说明
%功能：002版本模型定位
%% 功能代码
Model = [1,0,1,1,1,1];BList=[35]; % 鍒嗘澶ц嚧闂撮殧
[OBSData,SVP,INIData,MP1] = ReadData2Struct_002_xz(OBSFilePath,SVPFilePath,INIFilePath);
INIData.Data_file.N_shot = num2str(length(OBSData.ant_e0));
% 鏁版嵁瑙ｇ畻B鏍锋潯鍙傛暟鍖洪棿璁剧疆鍙婁釜鏁拌缃?
INIData.BSpan =[15,BList,BList,BList,BList]; % *ones(1,length(MP1)/3)
%鍩烘湰鍙傛暟纭畾
INIData.JcbMoodel = Model(1);INIData.Mu = Model(2);INIData.TModel = Model(3);INIData.Mu3 = 100000;
INIData.Ray_ENModel=Model(4);INIData.Vessel_ENModel=Model(5);INIData.cosZ = Model(6);
spdeg=3;
%1.B鏍锋潯鑺傜偣鏋勯??
[knots,MPNum]=Make_Bspline_knots(OBSData,spdeg,INIData.BSpan);%
%2.鑷傞暱杞寲
[OBSData,INIData,MP,MPNum] = Ant_ATD_Transducer_002(OBSData,INIData,SVP,MP1,MPNum,spdeg);
%3. 瑙ｇ畻
[ModelT_MP_T,ModelT_MAXLoop2,ModelT_MP_T_OBSData] = TCalModelT_002_xz(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,0);
end
