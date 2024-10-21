% close all; clear; clc;close("all");
%% 获取当前脚本的位置
% ScriptPath      = mfilename('fullpath');      % 脚本位置
% [FilePath] = fileparts(ScriptPath);      % 文件夹位置
% cd(FilePath);
% clear FilePath;

FigSet.FontSize = 15;
plot(atan(ModelT_MP_T_OBSData.Z0_Ray)*180/pi,ModelT_MP_T_OBSData.Lambda0,'.r');

xlabel('\fontname{宋体}{\it天顶角}\fontname{Times new roman}{\it(°)}','FontSize',FigSet.FontSize);
ylabel('\fontname{Times new roman}{\itγ(t)}','FontSize',FigSet.FontSize);
