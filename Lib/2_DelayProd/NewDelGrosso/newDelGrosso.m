function [svp,Ct,Cs,Cp,Cc] = newDelGrosso(svpInfo)
%% 函数说明
%功能：新的DelGrosso公式
%% 功能代码
    D = svpInfo(:,1);
    deltaT = svpInfo(:,2)-4;%摄氏度[0 40]
    deltaS = svpInfo(:,3)-35;%ppt[0 40]
    lat = svpInfo(:,4);
    deltaP = compPress(lat,D);%kg/cm2[0 1000]
    %Vs系数
    Cs2 = 0.0001288597999999999957;
    Cs1 = 1.3385501859999998783;
    %Vp系数
    Cp3 = - 0.0000000088339590000000000583;
    Cp2s2 = - 0.0000000016167450000000000868;
    Cp2s = - 0.00000011317215000000000608;
    Cp2 = 0.000022519417375000000982;
    Cp1 = 0.15605920000000000902;
    %Vt系数
    Cp3t_ = 0.00000000052224830000000000693;
    Cp3_ = 0.0000000020889932000000000277;
    Cp2t2_ = 0.000000026561739999999999723;
    Cp2t_ = - 0.000001381401079999999757;
    Cp2_ = - 0.0000059505921599999990237;
    Cps2t_ = 0.000004857613999999999838;
    Cps2_ = 0.000019430455999999999352;
    Cpst_ = - 0.00000064942000000001418893;
    Cps_ = - 0.0000025976800000000567557;
    Cpt3_ = - 0.00000043836150000000000416;
    Cpt2_ = - 0.0000052603380000000000499;
    Cpt_ = 0.00035916079799999994136;
    Cp_ = 0.001492753463999999766;
    Cst2_ = 0.000096884410000000004354;
    Cst_ = - 0.011984284720000000805;
    Cs_ = - 0.04948728944000000329;
    Ct3_ = 0.00022164900000000000509;
    Ct2_ = - 0.049067657650000004677;
    Ct_ = 4.1625269867999993682;
    
	C000 = 1402.392 + 46.691403254999995745 + 17.449376005599997548;
    %生成
    svp(:,1) = svpInfo(:,1);        
    Vs = Cs1*deltaS + Cs2*deltaS.^2;
    Vp = Cp3*deltaP.^3 + Cp2s2*deltaP.^2.*deltaS.^2 + Cp2s*deltaP.^2.*deltaS + Cp2*deltaP.^2 + Cp1*deltaP; 
    Vt = Cp3t_*deltaP.^3.*deltaT + Cp3_*deltaP.^3 + Cp2t2_*deltaP.^2.*deltaT.^2 + Cp2t_*deltaP.^2.*deltaT + Cp2_*deltaP.^2 + ...
         Cps2t_*deltaP.*deltaS.^2.*deltaT + Cps2_*deltaP.*deltaS.^2 + Cpst_*deltaP.*deltaS.*deltaT + Cps_*deltaP.*deltaS + ...
         Cpt3_*deltaP.*deltaT.^3 + Cpt2_*deltaP.*deltaT.^2 + Cpt_*deltaP.*deltaT + Cp_*deltaP + ...
         Cst2_*deltaS.*deltaT.^2 + Cst_*deltaS.*deltaT + Cs_*deltaS + Ct3_*deltaT.^3 + Ct2_*deltaT.^2 + Ct_*deltaT;
    svp(:,2) = C000 + Vs + Vp + Vt;
    %Ct、Cs、Cp
    Ct = [D Vt];
    Cs = [D Vs];
    Cp = [D Vp];
    Cc = [D repmat(C000,size(D,1),1)];
    %% 辅助函数
    function [press] = compPress(lat,depth)
        %%函数说明
        %功能：Leroy公式计算压力
        %输入：+lat 纬度
        %      +depth 深度
        %输出：+press 压力kg/cm^2
        %%功能代码
        press_dbar = 1.0052405*(1+5.28*10^(-3)*sin(lat).^2).*depth + 2.36*10^(-6)*depth.^2;
        press = press_dbar*0.1*1.02;
    end
end
