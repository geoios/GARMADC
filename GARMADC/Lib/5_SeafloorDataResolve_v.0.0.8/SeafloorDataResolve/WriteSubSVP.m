function  WriteSubSVP(INIData,MPNum)

if isfield(INIData,'SVPSeg')
    Num = (length(MPNum)-1)/3;
    filename1 = 'SubCalSVP_SVPLayer_T';
    fid = fopen([filename1,'.m'],'w');
    fprintf(fid,['function [SVP_speed] = ',filename1,'(Time,SVP,TMP,MPNum,knots,spdeg,INIData,BSplineModel)\n']);
    for i = 1:Num
        fprintf(fid,['GradT_Layer',num2str(i),' = Bspline_Function(Time,TMP(MPNum(',num2str(i),')+1:MPNum(',num2str(1+i),')),knots{',num2str(i),'},spdeg,INIData.nchoosekList,BSplineModel);\n']);
    end
    fprintf(fid,'SVP_speed = zeros(length(SVP(:,1)),1);\n');
    fprintf(fid,'for i = 1:length(SVP(:,1))\n');
    fprintf(fid,'if SVP(i,1) <= INIData.SVPSeg(1)\n');
    fprintf(fid,'\tSVP_speed(i,1) = SVP(i,2) * (1 + GradT_Layer1);\n');
    for i = 2:Num-1
        fprintf(fid,['elseif SVP(i,1) <= INIData.SVPSeg(',num2str(i),')\n']);
        fprintf(fid,['\tSVP_speed(i,1) = SVP(i,2) * (1 + GradT_Layer',num2str(i),');\n']);
    end
    fprintf(fid,'else\n');
    fprintf(fid,['\tSVP_speed(i,1) = SVP(i,2) * (1 + GradT_Layer',num2str(Num),');\n']);
    fprintf(fid,'end\n');
    fprintf(fid,'end\n');
    fprintf(fid,'end\n');
    fclose(fid);
   
    %% 空间变化
    filename2 = 'SubCalSVP_SVPLayer_EN';
    fid = fopen([filename2,'.m'],'w');
    fprintf(fid,['function [NewSVP] = ',filename2,'(Time,NewSVP,SVP,TMP,MPNum,knots,spdeg,Transducer_ENU,PXP_ENU,Centre,INIData,BSplineModel)\n']);
    for i = 1:Num
        fprintf(fid,['GradE_T_Layer',num2str(i),' = Bspline_Function(Time,TMP(MPNum(',num2str(Num+i),')+1:MPNum(',num2str(1+Num+i),')),knots{',num2str(Num+i),'},spdeg,INIData.nchoosekList,BSplineModel);\n']);
        fprintf(fid,['GradN_T_Layer',num2str(i),' = Bspline_Function(Time,TMP(MPNum(',num2str(2*Num+i),')+1:MPNum(',num2str(1+2*Num+i),')),knots{',num2str(2*Num+i),'},spdeg,INIData.nchoosekList,BSplineModel);\n']);
    end
    fprintf(fid,'for i = 1:length(SVP(:,1))\n');
    fprintf(fid,'R_E = ((PXP_ENU(1)-Centre(1))+(Transducer_ENU(1)-PXP_ENU(1))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));\n');
    fprintf(fid,'R_N = ((PXP_ENU(2)-Centre(2))+(Transducer_ENU(2)-PXP_ENU(2))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));\n');
    fprintf(fid,'R = norm([R_E,R_N]);\n');
    
    fprintf(fid,'if SVP(i,1) <= INIData.SVPSeg(1)\n');
    fprintf(fid,'\tdetalR = GradE_T_Layer1 * R_E / R + GradN_T_Layer1 * R_N / R;\n');
    for i = 2:Num-1
        fprintf(fid,['elseif SVP(i,1) <= INIData.SVPSeg(',num2str(i),')\n']);
        fprintf(fid,['\tdetalR = GradE_T_Layer',num2str(i),' * R_E / R + GradN_T_Layer',num2str(i),' * R_N / R;\n']);
    end
    fprintf(fid,'else\n');
    fprintf(fid,['\tdetalR = GradE_T_Layer',num2str(Num),' * R_E / R + GradN_T_Layer',num2str(Num),' * R_N / R;\n']);
    fprintf(fid,'end\n');
    fprintf(fid,'detalV = detalR * R;\n');
    fprintf(fid,'NewSVP(i,2) = NewSVP(i,2) + detalV;\n');
    fprintf(fid,'end\n');
    fprintf(fid,'end\n');
    fclose(fid);
end
end

