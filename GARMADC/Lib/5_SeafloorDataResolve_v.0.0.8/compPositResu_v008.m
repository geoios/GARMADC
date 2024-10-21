function [ModelT_MP_T,ModelT_MP_T_OBSData] = compPositResu_v008(intePos,soluType,ParGrid,OBSFilePath,INIFilePath)
%% 函数说明
%功能：附加时变延迟的定位结果
%% 功能代码
Model = [1,0,1,1,1,1];
% [LS 0B样条平滑因子]

BList=[35]; % 鍒嗘澶ц嚧闂撮殧
MuList = [0];
for MuListNum =1:length(MuList)
    Mu = MuList(MuListNum);
    for BListNum = 1:length(BList)
        BNUM = BList(BListNum);
        for DataNum = 1%:FileStruct.FileNum
            [OBSData,INIData,MP1] = ReadData2Struct(OBSFilePath,INIFilePath);
            INIData.Data_file.N_shot = num2str(length(OBSData.ant_e0));%load('svpInfo.mat');
            %INIData.souH = 8.243513853;见第36行
            INIData.intePos = intePos;
            INIData.ParGrid = ParGrid;
            % 鏁版嵁瑙ｇ畻B鏍锋潯鍙傛暟鍖洪棿璁剧疆鍙婁釜鏁拌缃?
            if(soluType == 1 || soluType == 2 ||soluType == 3)%无时变延迟估计
                INIData.BSpan =[];
            elseif(soluType == 4)%时变延迟估计
                INIData.BSpan =[15,BNUM,BNUM,BNUM,BNUM]; % *ones(1,length(MP1)/3)
            else
                error('soluType 错误')
            end
            %鍩烘湰鍙傛暟纭畾
            INIData.JcbMoodel = Model(1);INIData.Mu = Mu;INIData.TModel = Model(3);INIData.Mu3 = 100000;
            INIData.Ray_ENModel=Model(4);INIData.Vessel_ENModel=Model(5);INIData.cosZ = Model(6);
            spdeg=3;
            %1.B鏍锋潯鑺傜偣鏋勯??
            [knots,MPNum]=Make_Bspline_knots(OBSData,spdeg,INIData.BSpan);%
            %2.鑷傞暱杞寲
            [OBSData,INIData,MP,MPNum] = Ant_ATD_Transducer(OBSData,INIData,MP1,MPNum,spdeg);
            INIData.souH = -mean([OBSData.transducer_u0';OBSData.transducer_u1']);
            %3. 瑙ｇ畻
            [ModelT_MP_T,ModelT_MAXLoop2,ModelT_MP_T_OBSData] = TCalModelT(soluType,OBSData,INIData,MP,MPNum,knots,spdeg,0);
        end
    end
end
