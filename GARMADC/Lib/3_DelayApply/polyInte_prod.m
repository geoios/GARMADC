function [inteY] = polyInte_prod(intePos,dataMatr)
%% ����˵��
%���ܣ���Ԫһ�ζ���ʽ��ֵ
%% ���ܴ���
xyt = dataMatr(:,1:3);
y = dataMatr(:,4);

B = [ones(size(xyt,1),1) xyt];
coef = pinv(B'*B)*B'*y;
inteY = [1 intePos]*coef;

