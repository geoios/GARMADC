function [detalT] = CalT_ZTD(Time,TMP,MPNum,spdeg,knots,Z,alpha,INIData)
if isempty(knots)
    detalT = 0;return;
end
BSplineModel = 2;
%% 校正传播时间：时间部分
switch INIData.TModel
    case 0
        detalT = 0;
    case 1
        [GradT] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * 1;
end


%% 校正传播时间：空间部分（声线影响）
switch INIData.Ray_ENModel
    case 0
        detalT_Ray = 0;
    case 1
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradN_T_Ray * Z(2) * cos(alpha(2)) + GradE_T_Ray * Z(2) * sin(alpha(2));
end

detalT = detalT  + detalT_Ray;
%% 校正传播时间：空间部分（海面位置影响）
switch INIData.Vessel_ENModel
    case 0
        detalT_Vessel = 0;
    case 1
        [GradE_T_Vessel] = Bspline_Function(Time,TMP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(Time,TMP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  GradN_T_Vessel * Z(1) * cos(alpha(1)) + GradE_T_Vessel * Z(1) * sin(alpha(1));
end

detalT = detalT + detalT_Vessel;

%% 
switch INIData.cosZ
    case 0
        detalT = - detalT;
    case 1
        detalT = - detalT * cos(atan(Z(2)))^-1;
end
end

