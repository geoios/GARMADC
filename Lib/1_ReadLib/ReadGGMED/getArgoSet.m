function [argo] = getArgoSet(filePath)
%% ����˵��
%���ܣ���ȡArgo����
%% ���ܴ���
%��ȡ�ļ���
FileInfo = dir(fullfile(filePath,'*.dat'));% ��ȡ.dat�ļ���Ϣ
FileNames = {FileInfo.name}';% ��ȡ.dat�ļ�����n*1
%��ȡ����
for iFile = 1:size(FileNames,1)
    FullPath{iFile} = [filePath,'\',FileNames{iFile}];%�����ļ�·��
    fid = importdata(FullPath{iFile});%��ȡ
    %��ȡ���ṹ������
    argo(iFile,:).data = fid(:,[1 2 4 5 6 7]);%����γ���ʱ���¡���
    clear fid FullPath
end

