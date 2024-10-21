function [ModelT_MP_T,ModelT_MP_T_OBSData] = compPositResu_v008(intePos,soluType,ParGrid,OBSFilePath,INIFilePath)
%% ����˵��
%���ܣ�����ʱ���ӳٵĶ�λ���
%% ���ܴ���
Model = [1,0,1,1,1,1];
% [LS 0B����ƽ������]

BList=[35]; % 分段大致间隔
MuList = [0];
for MuListNum =1:length(MuList)
    Mu = MuList(MuListNum);
    for BListNum = 1:length(BList)
        BNUM = BList(BListNum);
        for DataNum = 1%:FileStruct.FileNum
            [OBSData,INIData,MP1] = ReadData2Struct(OBSFilePath,INIFilePath);
            INIData.Data_file.N_shot = num2str(length(OBSData.ant_e0));%load('svpInfo.mat');
            %INIData.souH = 8.243513853;����36��
            INIData.intePos = intePos;
            INIData.ParGrid = ParGrid;
            % 数据解算B样条参数区间设置及个数设�?
            if(soluType == 1 || soluType == 2 ||soluType == 3)%��ʱ���ӳٹ���
                INIData.BSpan =[];
            elseif(soluType == 4)%ʱ���ӳٹ���
                INIData.BSpan =[15,BNUM,BNUM,BNUM,BNUM]; % *ones(1,length(MP1)/3)
            else
                error('soluType ����')
            end
            %基本参数确定
            INIData.JcbMoodel = Model(1);INIData.Mu = Mu;INIData.TModel = Model(3);INIData.Mu3 = 100000;
            INIData.Ray_ENModel=Model(4);INIData.Vessel_ENModel=Model(5);INIData.cosZ = Model(6);
            spdeg=3;
            %1.B样条节点构�??
            [knots,MPNum]=Make_Bspline_knots(OBSData,spdeg,INIData.BSpan);%
            %2.臂长转化
            [OBSData,INIData,MP,MPNum] = Ant_ATD_Transducer(OBSData,INIData,MP1,MPNum,spdeg);
            INIData.souH = -mean([OBSData.transducer_u0';OBSData.transducer_u1']);
            %3. 解算
            [ModelT_MP_T,ModelT_MAXLoop2,ModelT_MP_T_OBSData] = TCalModelT(soluType,OBSData,INIData,MP,MPNum,knots,spdeg,0);
        end
    end
end
