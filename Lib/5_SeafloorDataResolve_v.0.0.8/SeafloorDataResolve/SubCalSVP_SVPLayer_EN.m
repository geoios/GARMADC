function [NewSVP] = SubCalSVP_SVPLayer_EN(Time,NewSVP,SVP,TMP,MPNum,knots,spdeg,Transducer_ENU,PXP_ENU,Centre,INIData,BSplineModel)
GradE_T_Layer1 = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
GradN_T_Layer1 = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
for i = 1:length(SVP(:,1))
R_E = ((PXP_ENU(1)-Centre(1))+(Transducer_ENU(1)-PXP_ENU(1))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
R_N = ((PXP_ENU(2)-Centre(2))+(Transducer_ENU(2)-PXP_ENU(2))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
R = norm([R_E,R_N]);
if SVP(i,1) <= INIData.SVPSeg(1)
	detalR = GradE_T_Layer1 * R_E / R + GradN_T_Layer1 * R_N / R;
else
	detalR = GradE_T_Layer1 * R_E / R + GradN_T_Layer1 * R_N / R;
end
detalV = detalR * R;
NewSVP(i,2) = NewSVP(i,2) + detalV;
end
end
