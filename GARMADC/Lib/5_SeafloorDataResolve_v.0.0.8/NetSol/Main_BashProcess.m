% ����������.mat�ļ�
clc
clear all
% ��ȡ��ǰ�ű���λ��
ScriptPath      = mfilename('fullpath');      % �ű�λ��
[FilePath]      = fileparts(ScriptPath);      % �ļ���λ��
cd(FilePath);
% ָ����������Ŀ¼
DataPath =  'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_Obs';
% ��ȡ�����б�
Tag1 = '-obs.csv';
Tag = ['\*' Tag1];  %% ��ȡ�ļ�ͨ���
FileStruct = FileExtract(DataPath,Tag);
DataPath =  'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_Obs';
Tag2 = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,Tag1,DataPath,Tag2);
DataPath =  'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_Config';
Tag3 = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,Tag1,DataPath,Tag3);

% �����ļ���۲��ļ��ϲ�����Ѳ���Ӧ��������ƥ��Obs��ini������
for i = 1:FileStruct.FileNum
    iObsFilePath = FileStruct.SubFileList{1,i};
    iConfigFile = FileStruct.SubFileList{3,i};
    WriteFilePath = GNSSABashPro(iObsFilePath,iConfigFile);
end
