function [argo] = getArgoSet(filePath)
%% 函数说明
%功能：读取Argo数据
%% 功能代码
%读取文件名
FileInfo = dir(fullfile(filePath,'*.dat'));% 获取.dat文件信息
FileNames = {FileInfo.name}';% 提取.dat文件名，n*1
%获取数据
for iFile = 1:size(FileNames,1)
    FullPath{iFile} = [filePath,'\',FileNames{iFile}];%具体文件路径
    fid = importdata(FullPath{iFile});%读取
    %提取到结构体数组
    argo(iFile,:).data = fid(:,[1 2 4 5 6 7]);%经、纬、深、时、温、盐
    clear fid FullPath
end

