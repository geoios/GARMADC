clc
clear all
%% 提取数据
% 行索引
% FilePath = 'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_ObsFUKU.1212.kaiyo_k4-obs\FUKU.1212.kaiyo_k4-obs.GNSSA';

FilePath = 'D:\Github\Dev\APP-PFP\WorkSpace\CHOS\ObsCHOS.1808.kaiyo_k4-obs\CHOS.1808.kaiyo_k4-obs.GNSSA';


%% 需求数据提取
Data = ReadNSinex(FilePath);
ObsData = Data.Data.SET_LN_MT;

% idxExtra = [2 inf inf]; 

idxExtra = [1 inf 14
            2 inf 14
            3 inf 14]; 

            
Suffix = ['_S_' num2str(idxExtra(:,1)') '_L_' num2str(idxExtra(:,2)') '_M_' num2str(idxExtra(:,3)') '.GNSSA'];
Suffix = strrep(Suffix,' ','');
idxs = MatchIdx(ObsData(:,1:3),idxExtra);
SubData = ObsData(idxs,:);

%% 需求数据标准格式生成
[NewFileName, StorageFilePath,OldFileName] = FileSuffixChange(FilePath,Suffix);
FilePath = [StorageFilePath,'\',NewFileName];

[~ ,~ ,IdxText ,formats] = GNSSAFileTemplate();
[HeadItem,HeadContent] = Header2Cells(Data.Header);
RinexFileWrite(FilePath,HeadItem,HeadContent,IdxText,SubData,formats);
