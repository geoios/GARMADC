% 批处理生成.mat文件
clc
clear all
% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath]      = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
% 指定数据所在目录
DataPath =  'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_Obs';
% 获取数据列表
Tag1 = '-obs.csv';
Tag = ['\*' Tag1];  %% 获取文件通配符
FileStruct = FileExtract(DataPath,Tag);
DataPath =  'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_Obs';
Tag2 = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,Tag1,DataPath,Tag2);
DataPath =  'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_Config';
Tag3 = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,Tag1,DataPath,Tag3);

% 配置文件与观测文件合并，最佳策略应该是首先匹配Obs和ini的链表
for i = 1:FileStruct.FileNum
    iObsFilePath = FileStruct.SubFileList{1,i};
    iConfigFile = FileStruct.SubFileList{3,i};
    WriteFilePath = GNSSABashPro(iObsFilePath,iConfigFile);
end
