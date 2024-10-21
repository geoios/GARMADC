function [OBSDataStruct,INIDataStruct,MP] = ReadData2Struct(FilePath1,FilePath3)
%% 预发时间Matlab 2019 �? matlab 2021 版本差异导致�?要删�?*-obs.csv第一�?
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
% 1.读取.csv 中的数据以Matlab 中表（table）形式展�?
 % SVPDataTable=readtable(FilePath2);
% 2.读取.ini 中的数据以结构体的形式输�?
INIDataStruct=ReadNSinex(FilePath3);


%% 数据结构体化
% 标记参数起始位置
% for i=1:length(INIDataStruct.Site_parameter.Stations)
% [index]=find(strcmp(OBSDataTable.MT,INIDataStruct.Site_parameter.Stations(i))==1);
% OBSDataTable.MTPSign(index)=(i-1)*3*ones(length(index),1)+1;
% end

% 替代程序后续修改

Stations=Read_Ini_File(FilePath3,'Stations');
for i=1:length(Stations)
    [index]=find(strcmp(OBSMT,{Stations{i}})==1);
    OBSDataTable.MTPSign(index)=(i-1)*3*ones(length(index),1)+1;
end

[OBSDataStruct] = DataTable2DataStruct(OBSDataTable);
% [SVPDataStruct] = DataTable2DataStruct(SVPDataTable);
% SVP(:,1) = SVPDataStruct.depth;
% SVP(:,2) = SVPDataStruct.speed;

%% 提取代求参数
MP=[];
CC=fieldnames(INIDataStruct.Model_parameter.MT_Pos);
for i=1:length(CC)
    if ~isempty(strfind(CC{i},'_dPos'))
        mp=getfield(INIDataStruct.Model_parameter.MT_Pos,CC{i});
        MP=[MP,mp(1:3)];
    end
end
INIDataStruct.MP = MP;
%%
end

