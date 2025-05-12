clc
clear all

% % 获取当前脚本的位置
% ScriptPath      = mfilename('fullpath');      % 脚本位置
% [FilePath]      = fileparts(ScriptPath);      % 文件夹位置

Wildcard = '\*';
StnName  = 'MYGI';
StnPath1  = ['D:\matlab程序\非差网解\非差\Data\',StnName];
StnPath2  = 'D:\matlab程序\非差网解\非差\日本数据\data_Tohoku2011-2020\';
% 观测文件目录
ObsPath  = [StnPath2,'obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 配置文件目录
ConfPath = [StnPath2,'initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);
% 日本解算结果文件目录
JapSolPath = [StnPath1];
JapSolTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,JapSolPath,JapSolTag);

% 提取数据时间
timepath = FileStruct.SubFileList(4,:);
for j = 1:length(timepath)
    time_path = cell2mat(timepath(j));
    timesplit = strsplit(time_path,'.');
    time(j,1) = str2num(cell2mat(timesplit(2)));
end

% 将我们的程序依据保金的SVP处理结果与日本程序依据其自身的SVP处理结果作差得到中心点差值
for i = 1:FileStruct.FileNum
    try
    iJapSolFile  = FileStruct.SubFileList{4,i};
    JapSol        = ReadNSinex(iJapSolFile);
    x0s           = Extraction_x0(JapSol);

    load(['D:\matlab程序\result\40-7\',num2str(i),'.mat'],'ModelT_MP_SVP')
%     X(i,:) = ModelT_MP_SVP(1:length(x0s));
    detalX = ModelT_MP_SVP(1:length(x0s))-x0s;
    detal_E(i,:) = mean(detalX(1:3:end));
    detal_N(i,:) = mean(detalX(2:3:end));
    detal_U(i,:) = mean(detalX(3:3:end));
    catch
        continue
    end
end
detal_ENU = [time,detal_E,detal_N,detal_U];

