function [inteY] = polyInte_prod(intePos,dataMatr)
%% 函数说明
%功能：三元一次多项式插值
%% 功能代码
xyt = dataMatr(:,1:3);
y = dataMatr(:,4);

B = [ones(size(xyt,1),1) xyt];
coef = pinv(B'*B)*B'*y;
inteY = [1 intePos]*coef;

