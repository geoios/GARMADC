function [ei] = ConstantV_Jcb(KnownPoint,UnknownPoint)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Y = norm(KnownPoint(1:2)-UnknownPoint(1:2));
H = abs(KnownPoint(3)-UnknownPoint(3));
alfa = atan(Y/H);
cos_beta      = (KnownPoint(1) - UnknownPoint(1))/Y;
sin_beta      = (KnownPoint(2) - UnknownPoint(2))/Y;
cos_alfa      = cos(alfa);
sin_alfa      = sin(alfa);

ei(1) = sin_alfa * cos_beta;
ei(2) = sin_alfa * sin_beta;
ei(3) = cos_alfa;
end

