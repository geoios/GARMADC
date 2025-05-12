function getNewDelGrosso()
%% 函数说明
%功能：获取新的DelGrosso声速公式
%% 功能代码
syms deltaT deltaS deltaP
C000 = 1402.392;             Ctp = 0.6353509*10^(-2);
Ct1 = 0.5012285*10^1;        Ct2p2 = 0.2656174*10^(-7);
Ct2 = -0.551184*10^(-1);     Ctp2 = -0.1593895*10^(-5);
Ct3 = 0.221649*10^(-3);      Ctp3 = 0.5222483*10^(-9);
Cs1 = 0.1329530*10^1;        Ct3p = -0.4383615*10^(-6);
Cs2 = 0.1288598*10^(-3);     Cs2p2 = -0.1616745*10^(-8);
Cp1 = 0.1560592;             Cst2 = 0.9688441*10^(-4);
Cp2 = 0.2449993*10^(-4);     Cs2tp = 0.4857614*10^(-5);
Cp3 = -0.8833959*10^(-8);    Cstp = -0.3406824*10^(-3);
Cst = -0.1275936*10^(-1);

Vt = Ct1*(deltaT+4) + Ct2*(deltaT+4).^2 + Ct3*(deltaT+4).^3;
Vp = Cp1*deltaP + Cp2*deltaP.^2 + Cp3*deltaP.^3 + Cs2p2*(deltaS+35).^2.*deltaP.^2;
Vs = Cs1*(deltaS+35) + Cs2*(deltaS+35).^2;

Vstp = Ctp*(deltaT+4).*deltaP + Ct3p*(deltaT+4).^3.*deltaP + Ctp2*(deltaT+4).*deltaP.^2 ...
       + Ct2p2*(deltaT+4).^2.*deltaP.^2 + Ctp3*(deltaT+4).*deltaP.^3+Cst*(deltaS+35).*(deltaT+4) ...
       + Cst2*(deltaS+35).*(deltaT+4).^2 + Cstp*(deltaS+35).*(deltaT+4).*deltaP + Cs2tp*(deltaS+35).^2.*(deltaT+4).*deltaP;
format long g;%输出结果为小数
format shortE
% f = C000+Vt+Vs+Vp+Vstp
% expandF = vpa(expand(f),20);
ft = Vt + Vstp;
fp = Vp;
fs = Vs;
expandFt = vpa(expand(ft),20)
expandFp = vpa(expand(fp),20)
expandFs = vpa(expand(fs),20)