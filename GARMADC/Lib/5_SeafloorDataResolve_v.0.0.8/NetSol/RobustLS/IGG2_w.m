function p = IGG2_w(k1,v)
%% IGG1��Ȩ����
V = abs(v);
if V > k1
   p = 0;
else
   p = 1;
end