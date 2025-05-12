%% Script description
%Founction：Static delay positioning

%% Script configuration
clc;clear;
fullPath = mfilename('fullpath');
scriPath = fileparts(fullPath);
% Import path
    % Marine environmental product path
    load([scriPath '\Data_import\PhySet.mat']);
    load([scriPath '\Data_import\ArgoSet.mat']);
    % Japan observation file path
    impoObsPath = [scriPath '\Data_import\obsdata(11-20)\MYGI\'];
    impoIniPath = [scriPath '\Data_import\initcfg(11-20)\MYGI\'];
% Export path
    expoIniPath_array = [scriPath '\Data_export\test\实测(2011-2020)-fix\MYGI\'];
% Parameter setting
    parSet = [3 1];

%% Code Lib
[centCoor,TranCoor,centCoorFix_array,TranCoorFix_array,arrayOffsetFix_array] = garmadc(parSet,impoObsPath,impoIniPath,expoIniPath_array,PhySet,ArgoSet);