function [OBSDataStruct,INIDataStruct,MP] = ReadData2Struct_xz(FilePath1,FilePath3)
%% 棰勫彂鏃堕棿Matlab 2019 涓? matlab 2021 鐗堟湰宸紓瀵艰嚧闇?瑕佸垹闄?*-obs.csv绗竴琛?
try
    OBSDataTable=readtable(FilePath1);
    OBSMT=OBSDataTable.MT;
catch
    OldFile=fopen(FilePath1,'r');
    NewFilePath=[FilePath1(1:end-8),'_new',FilePath1(end-8:end)];
    NewFile=fopen(NewFilePath,'w+');
    while ~feof(OldFile)
        tline=fgetl(OldFile);
        if contains(tline,'#')
            continue;
        end
        fprintf(NewFile,'%s\n',tline);
    end
    fclose(OldFile);
    fclose(NewFile);
    OBSDataTable=readtable(NewFilePath);
    OBSMT=OBSDataTable.MT;
end
%%
% 1.璇诲彇.csv 涓殑鏁版嵁浠atlab 涓〃锛坱able锛夊舰寮忓睍绀?
 % SVPDataTable=readtable(FilePath2);
% 2.璇诲彇.ini 涓殑鏁版嵁浠ョ粨鏋勪綋鐨勫舰寮忚緭鍑?
INIDataStruct=ReadNSinex(FilePath3);


%% 鏁版嵁缁撴瀯浣撳寲
% 鏍囪鍙傛暟璧峰浣嶇疆
% for i=1:length(INIDataStruct.Site_parameter.Stations)
% [index]=find(strcmp(OBSDataTable.MT,INIDataStruct.Site_parameter.Stations(i))==1);
% OBSDataTable.MTPSign(index)=(i-1)*3*ones(length(index),1)+1;
% end

% 鏇夸唬绋嬪簭鍚庣画淇敼

Stations=Read_Ini_File(FilePath3,'Stations');
for i=1:length(Stations)
    [index]=find(strcmp(OBSMT,{Stations{i}})==1);
    OBSDataTable.MTPSign(index)=(i-1)*3*ones(length(index),1)+1;
end

[OBSDataStruct] = DataTable2DataStruct(OBSDataTable);
% [SVPDataStruct] = DataTable2DataStruct(SVPDataTable);
% SVP(:,1) = SVPDataStruct.depth;
% SVP(:,2) = SVPDataStruct.speed;

%% 鎻愬彇浠ｆ眰鍙傛暟
PosNameTips = fieldnames(INIDataStruct.Model_parameter.MT_Pos);
EachPos = [];CovXX = [];
PosNum = length(PosNameTips);
for i=1:PosNum
    if ~isempty(strfind(PosNameTips{i},'_dPos'))
        mp = getfield(INIDataStruct.Model_parameter.MT_Pos,PosNameTips{i});
        EachPos = [EachPos,mp(1:3)];
        CovXX  = [CovXX,mp(4:6)];
    end
end
% 2.确定坐标参数
dCentPos = str2num(INIDataStruct.Model_parameter.MT_Pos.dCentPos);
dCenPosCovXX = dCentPos(4:6);CovXX = [CovXX,dCenPosCovXX];
ATD = INIDataStruct.Model_parameter.ANT_to_TD.ATDoffset;
INIDataStruct.FixModel = contains(FilePath3,'fix');
MP = [EachPos,dCentPos(1:3)];INIDataStruct.MP = MP;
[INIDataStruct.PriorMP,INIDataStruct.PosteriMP]= deal([EachPos,dCentPos(1:3),ATD(1:3)]);
INIDataStruct.ProCov = diag(CovXX.^2);
end

