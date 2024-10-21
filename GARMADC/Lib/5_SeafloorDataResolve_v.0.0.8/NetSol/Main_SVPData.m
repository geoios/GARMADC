clc
clear all

%% ����ԭʼת��
% XlsFilePath = 'D:\Github\Dev\Apps\SeafloorDataPro\Tools\StandardDataExchange\FUKU\FUKU_Obs\FUKU.1212.kaiyo_k4-svp.csv';
XlsFilePath = 'D:\Github\Dev\APP-PFP\WorkSpace\CHOS\Obs\CHOS.1808.kaiyo_k4-svp.csv';
RowIdx  = 1;
ColIdx  = 1;
HeadCol = 1;
FileTemFun = @SVPFileTemplate;
Suffix = '.SVP';
WriteFilePath = XlsFile2Rinex(XlsFilePath,RowIdx,ColIdx,HeadCol,Suffix,FileTemFun);


%% ��ȡ�۲�����
FileData = ReadNSinex(WriteFilePath);
Data = FileData.Data.depth;

[HeadItem HeadContent IdxText formats] = SVPFileTemplate();
RinexFileWrite(WriteFilePath,HeadItem,HeadContent,IdxText,Data,formats);