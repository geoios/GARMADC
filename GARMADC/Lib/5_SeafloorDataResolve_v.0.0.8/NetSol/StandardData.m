function [AllData,ObsData] = StandardData(AllObsPath)
%% 提取数据
% 行索引
FilePath = AllObsPath;
%% 需求数据提取
Data = ReadNSinex(FilePath);
AllData = Data;
AllObsData = Data.Data.SET_LN_MT;
S_Inf = str2num(Data.Header.Sessions);  
L_Inf = str2num(Data.Header.Lines);  
M_Inf = str2num(Data.Header.Site_No);  

SesNum = length(S_Inf);
MNum   = length(M_Inf);

for i = 1:MNum
    idxExtra = [S_Inf',inf*ones(SesNum,1),M_Inf(i)*ones(SesNum,1)];
    Suffix = ['_S_' num2str(idxExtra(:,1)') '_L_' num2str(idxExtra(:,2)') '_M_' num2str(idxExtra(:,3)') '.GNSSA'];
    Suffix = strrep(Suffix,' ','');
    idxs = MatchIdx(AllObsData(:,1:3),idxExtra);
    SubData = AllObsData(idxs,:);
    
    %% 需求数据标准格式生成
    [NewFileName, StorageFilePath,OldFileName] = FileSuffixChange(FilePath,Suffix);
    iFilePath = [StorageFilePath,'\',NewFileName];
    [~ ,~ ,IdxText ,formats] = GNSSAFileTemplate();
    [HeadItem,HeadContent] = Header2Cells(Data.Header);
    RinexFileWrite(iFilePath,HeadItem,HeadContent,IdxText,SubData,formats);
    
    iObsData = ReadNSinex(iFilePath);
    iObsData = iObsData.Data.SET_LN_MT;
    ObsData{i} = iObsData;
    delete(iFilePath)
end

end