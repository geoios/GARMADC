close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;
%% 目录
% 1.元素区间查找
%%
%% 区间搭建[E,-E,0,0,0,0;0,0,E-E,0,0;0,0,0,0,E,-E]
% MPNum = [12,15*ones(1,3*7)];mp=[1,2,3,4,5,6];
% MPNum = cumsum(MPNum);num = 1;
% nnm = fix(length(MPNum)/(length(mp)+1))+1;
% VirObs     = zeros(MPNum(end)-MPNum(nnm),MPNum(end));
% for  i = 1:length(MPNum)-1
%     if mod(i,(length(mp)+1))==0
%         continue;
%     end
%     Row = MPNum(num)+1-MPNum(1):MPNum(num+1)-MPNum(1);
%     Column1 = MPNum(i)+1:MPNum(i+1);
%     Column2 = MPNum(i+1) + 1:MPNum(i+2);
% 
%     E = diag(ones((MPNum(num+1)-MPNum(num)),1));
% 
%     VirObs(Row , Column1) = E;
%     VirObs(Row , Column2) = -E;
%     num=num + 1;
% end






%% 1.元素区间查找
a = [100,200,300,500,800,1100];b=[0:10:200,250:50:550,600:100:900,1000:400:3000,3070];
t = interp1([a realmax],0:length(a),b','next','extrap');
[b', t+1]
