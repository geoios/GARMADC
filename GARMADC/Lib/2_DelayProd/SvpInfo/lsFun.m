function [newData] = lsFun(data,aimH,window,statsInfo)
%% ����˵��
%���ܣ���С��������
%% ���ܴ���
%��С��������
lsData = data(end-window+1:end,:);%��С������������Χ
lsData = [lsData;statsInfo];
P = eye(window+1);%blkdiag(1./1^2*eye(window),1./StatsInfo.Vb(2)^2);%%

B = [ones(size(lsData,1),1) lsData(:,1)];%������С����X����
coff = inv(B'*P*B)*B'*P*lsData(:,2);
aimY = coff(1) + coff(2)*aimH;
newData = [aimH aimY];

