function [detalT] = CalT_ZTD(Time,TMP,MPNum,spdeg,knots,alpha,Z,INIData,U,gammar,index,Lambda)
if isempty(knots)
    detalT = 0;return;
end
BSplineModel = 2;
%% 校正传播时间：时间部分
% [GradT] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
switch INIData.TModel
    case 0
        detalT = 0;
    case 1
        [GradT] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * 1;
    case 2
        [GradT] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * gammar(1) * (Time - knots{1}(spdeg + 1));
    case 3
        BSNum = (index +2)/3;
        [GradT] = Bspline_Function(Time,TMP(MPNum(BSNum)+1:MPNum(BSNum+1)),knots{BSNum},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * 1;
    case 5
        [GradT] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * INIData.gammar1 * (Time - knots{1}(spdeg + 1));
    case 6
        [GradT] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * Lambda^-1;
        
    case 7
        [GradT_Common] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT_Common * 1;
        BSNum = (index +2)/3;
        [GradT_Local] = Bspline_Function(Time,TMP(MPNum(BSNum+1)+1:MPNum(BSNum+2)),knots{1+BSNum},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  detalT + GradT_Local * 1;
end


%% 校正传播时间：空间部分（声线影响）
switch INIData.Ray_ENModel
    case 0
        detalT_Ray = 0;
    case 1
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradN_T_Ray * Z(2) * cos(alpha(2)) + GradE_T_Ray * Z(2) * sin(alpha(2));
    case 2
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray1 = GradN_T_Ray * (gammar(2) * Z(2) * cos(alpha(2)) + gammar(1) *  U * Z(1) * cos(alpha(1)));
        detalT_Ray2 = GradE_T_Ray * (gammar(2) * Z(2) * sin(alpha(2)) + gammar(1) *  U * Z(1) * sin(alpha(1)));
        detalT_Ray = detalT_Ray1 + detalT_Ray2;
    case 3
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(end-4)+1:MPNum(end-3)),knots{end-3},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(end-3)+1:MPNum(end-2)),knots{end-2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradN_T_Ray * Z(2) * cos(alpha(2)) + GradE_T_Ray * Z(2) * sin(alpha(2));
    case 4
        BSNum = (index +2)/3;
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(1+(BSNum-1)*2+1)+1:MPNum(1+BSNum*2)),knots{1+(BSNum-1)*2+1},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(1+BSNum*2)+1:MPNum(1+BSNum*2+1)),knots{1+BSNum*2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradN_T_Ray * Z(2) * cos(alpha(2)) + GradE_T_Ray * Z(2) * sin(alpha(2));
    case 5
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray1 = GradN_T_Ray * (INIData.gammar2 * Z(2) * cos(alpha(2)) + INIData.gammar1 *  U * Z(1) * cos(alpha(1)));
        detalT_Ray2 = GradE_T_Ray * (INIData.gammar2 * Z(2) * sin(alpha(2)) + INIData.gammar1 *  U * Z(1) * sin(alpha(1)));
        detalT_Ray = detalT_Ray1 + detalT_Ray2;
    case 6
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = (GradN_T_Ray * Z(2) * cos(alpha(2)) + GradE_T_Ray * Z(2) * sin(alpha(2)))*(INIData.gammar2 + U * INIData.gammar1);
    case 7
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = (GradN_T_Ray * Z(2) * cos(alpha(2)) + GradE_T_Ray * Z(2) * sin(alpha(2))) * Lambda^-1;
        
    case 8
        BSNum = (index +2)/3;ENindex = MPNum(1)/3;
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(1+(BSNum-1)*2+ENindex)+1:MPNum(BSNum*2+ENindex)),knots{1+(BSNum-1)*2+ENindex},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(BSNum*2+ENindex)+1:MPNum(BSNum*2+ENindex+1)),knots{ENindex+BSNum*2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradN_T_Ray * Z(2) * cos(alpha(2)) + GradE_T_Ray * Z(2) * sin(alpha(2));
    case 9
        [GradE_T_Ray] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray1 = GradN_T_Ray * (gammar(2) * Z(2) * cos(alpha(2)));
        detalT_Ray2 = GradE_T_Ray * (gammar(2) * Z(2) * sin(alpha(2)));
        detalT_Ray = detalT_Ray1 + detalT_Ray2;
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
    case 2
        BSNum = (index +2)/3;
        [GradE_T_Vessel] = Bspline_Function(Time,TMP(MPNum(3+(BSNum-1)*2+1)+1:MPNum(3+BSNum*2)),knots{3+(BSNum-1)*2+1},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(Time,TMP(MPNum(3+BSNum*2)+1:MPNum(3+BSNum*2+1)),knots{3+BSNum*2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  GradN_T_Vessel * Z(1) * cos(alpha(1)) + GradE_T_Vessel * Z(1) * sin(alpha(1));
    case 3
        [GradE_T_Vessel] = Bspline_Function(Time,TMP(MPNum(end-2)+1:MPNum(end-1)),knots{end-1},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(Time,TMP(MPNum(end-1)+1:MPNum(end)),knots{end},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  GradN_T_Vessel * Z(1) * cos(alpha(1)) + GradE_T_Vessel * Z(1) * sin(alpha(1));
    case 7
        [GradE_T_Vessel] = Bspline_Function(Time,TMP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(Time,TMP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  (GradN_T_Vessel * Z(1) * cos(alpha(1)) + GradE_T_Vessel * Z(1) * sin(alpha(1))) * Lambda^-1;
    case 9
        [GradE_T_Vessel] = Bspline_Function(Time,TMP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(Time,TMP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel1 = GradN_T_Vessel * (gammar(1) *  U * Z(1) * cos(alpha(1)));
        detalT_Vessel2 = GradE_T_Vessel * (gammar(1) *  U * Z(1) * sin(alpha(1)));
        detalT_Vessel = detalT_Vessel1 + detalT_Vessel2;
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

