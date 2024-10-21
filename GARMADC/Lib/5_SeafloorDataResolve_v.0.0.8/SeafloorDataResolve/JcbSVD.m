close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

%% 
x=1:0.01:2*pi;
y=sin(x);
 
cftool


%% 提取雅可比矩阵时变列进行SVD分解看列向量是否相关
% 初始迭代
load('JcbSVP1.mat')
Jcb_B_row=Jcb(:,13:end);
load('JcbT1.mat')
Jcb_B_row=[Jcb_B_row,Jcb(:,13:end)];
[N,V,U]=svd(Jcb_B_row);
V1=diag(V);



figure(1)
for i=1:size(Jcb_B_row,2)
    plot(1:size(Jcb_B_row,1),Jcb_B_row(:,i),'-')
    hold on
end


% 终止迭代
load('JcbSVPend.mat')
Jcb_B_row=Jcb(:,13:end);
load('JcbTend.mat')
Jcb_B_row=[Jcb_B_row,Jcb(:,13:end)];
[N,V,U]=svd(Jcb_B_row);
V2=diag(V);
figure(2)
for i=1:size(Jcb_B_row,2)
    plot(1:size(Jcb_B_row,1),Jcb_B_row(:,i),'-')
    hold on
end