function [SVP_speed] = SubCalSVP_SVPLayer_T(Time,SVP,TMP,MPNum,knots,spdeg,INIData,BSplineModel)
GradT_Layer1 = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
SVP_speed = zeros(length(SVP(:,1)),1);
for i = 1:length(SVP(:,1))
if SVP(i,1) <= INIData.SVPSeg(1)
	SVP_speed(i,1) = SVP(i,2) * (1 + GradT_Layer1);
else
	SVP_speed(i,1) = SVP(i,2) * (1 + GradT_Layer1);
end
end
end
