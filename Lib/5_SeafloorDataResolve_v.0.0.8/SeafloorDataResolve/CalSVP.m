function [NewSVP] = CalSVP(Time,SVP,TMP,MPNum,spdeg,knots,Transducer_ENU,PXP_ENU,Centre,INIData)
TModel = 1;  ENModel = 1;   HightModel = 0;  BSplineModel = 2;
%% 校正声速剖面：高程部分
% 4.将随U方向使用B样条进行描述
switch HightModel
    case 0
        GradU=ones(length(SVP(:,1)),3);
    case 1
        GradU=zeros(length(SVP(:,1)),3);
        if length(knots) >= 4
            for j=1:length(SVP(:,1))
                [GradU_tmp_T] = Bspline_Function(SVP(j,1),TMP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
                if length(knots) >= 5
                    [GradU_tmp_EN] = Bspline_Function(SVP(j,1),TMP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
                    GradU(j,1:3) = [GradU_tmp_T,GradU_tmp_EN,GradU_tmp_EN];
                    %GradU_EN(j,1:2)=GradU_tmp_EN;  % GradU_EN(j,1:2)=cos(2*pi*exp(-exp(GradU_tmp_EN)));
                else
                    GradU(j,1:3) = GradU_tmp_T;
                    % GradU(j,1:3)=1.01*sin(GradU_tmp_T);%  GradU_T(j,1)=cos(2*pi*exp(-exp(GradU_tmp_T)));
                end
            end
        else
            disp('knots<4');
            pause
        end
    case 2
        GradU=zeros(length(SVP(:,1)),3);
        for j=1:length(SVP(:,1))

            if SVP(j,1)< (SVP(end,1)-SVP(1,1))/2
                [Grad_restrain1] = Bspline_Function(SVP(j,1),TMP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
                GradU(j,1:3) = Grad_restrain1;
            else
                [Grad_restrain2] = Bspline_Function(SVP(j,1),TMP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
                GradU(j,1:3) = Grad_restrain2;
            end
        end

    case 3 % 双指数模型和常数1模型
        GradU=zeros(length(SVP(:,1)),3);
        Hyperpara.U_Cri = INIData.U_Cri;
        for k=1:3
            Hyperpara.sigma1 = INIData.sigma(k,1);Hyperpara.sigma2 = INIData.sigma(k,2);
            for j = 1 : length(SVP(:,1))
                GradU(j,k) = ModelFuntion(SVP(j,1),Hyperpara,INIData.HightModel);
            end
        end
    case 4
        GradU=zeros(length(SVP(:,1)),1);
        if length(knots) >= 4
            for j=1:length(SVP(:,1))
                if SVP(j,1)>=knots{4}(spdeg+1) && SVP(j,1)<=knots{4}(end-spdeg)
                    [GradU_tmp_Layer1] = Bspline_Function(SVP(j,1),TMP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
                end

                if length(knots) >= 5
                    GradU_tmp_Layer2 = 0;
                    if SVP(j,1)>knots{5}(spdeg+1) && SVP(j,1)<=knots{5}(end-spdeg)
                        [GradU_tmp_Layer2] = Bspline_Function(SVP(j,1),TMP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
                    end
                    GradU(j,1) = GradU_tmp_Layer1 + GradU_tmp_Layer2;
                else
                    GradU(j,1) = GradU_tmp_Layer1;
                end
            end
        else
            disp('knots<4');
            pause
        end
end
%% 校正声速剖面：时间部分
switch TModel
    case 1
        [GradT] = Bspline_Function(Time,TMP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        for i=1:length(SVP(:,1))
            SVP_speed(i,1)=SVP(i,2)*(1+GradT*GradU(i,1));
        end
    case 2  %
         [SVP_speed] = SubCalSVP_SVPLayer_T(Time,SVP,TMP,MPNum,knots,spdeg,INIData,BSplineModel);

%         for j = 1:n
%             eval(['GradT_Layer',num2str(j),'=','Bspline_Function(Time,TMP(MPNum(',num2str(j),')+1:MPNum(',num2str(1+j),')),knots{',num2str(j),'},spdeg,BSplineModel);']);
%         end
%         for i=1:length(SVP(:,1))
%             Layer = interp1([INIData.SVPSeg realmax],0:length(INIData.SVPSeg),SVP(i,1),'next','extrap');
%             eval(['SVP_speed(i,1) = SVP(i,2) * (1 + GradT_Layer',num2str(Layer+1),');']);
%         end
          
end
NewSVP=[SVP(:,1),SVP_speed];

% 时间函数替补部分,想法：将B样条作为EOF的时间函数，但本算法需要有相对较密集的CTD/XCTD观测
% for i=1:5
%     BValue=[];
%     for j=1:MPNum(2)-MPNum(1) % 基函数个数
%         BValue(j)=Bbase(j,3,Time,knots(1,:));
%     end
%     value(i,1)=TMP(MPNum(1)+1:MPNum(2))*BValue';
% end
%
% NewF=INIData.detalSVP_Array(:,1:5);
% SVP_V=SVP(:,2)+NewF*value;
% NewSVP=[SVP(:,1),SVP_V];
%% 校正声速剖面水平空间部分
switch ENModel
    case 0
        NewSVP = NewSVP;
    case 1  % 老师想法：将声场梯度表示为N、E两方向而不用角度表示，使用深度变化使用指数函数表示。
        if length(knots)>=3
            % 1.北、东方向水平梯度（垂直梯度于2近似为exp()）
            [GradE_T] = Bspline_Function(Time,TMP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
            [GradN_T] = Bspline_Function(Time,TMP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);

            % 2.东、北方向声速变化;exp(-h)垂直变化(理解发生偏差：将所受方向投影中至E、N坐标系)
            %     for i=1:length(SVP(:,1))
            %         detalVE=GradE_T*exp(0*SVP(i,1))*((PXP_ENU(1)-Centre(1))+(Transducer_ENU(1)-PXP_ENU(1))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
            %         detalVN=GradN_T*exp(0*SVP(i,1))*((PXP_ENU(2)-Centre(2))+(Transducer_ENU(2)-PXP_ENU(2))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
            %         detalV(i,1)=norm([detalVE,detalVN]);
            %     end
            %     NewSVP(:,2)=NewSVP(:,2)+detalV;

            % 3.将E、N方向梯度变化投影至观测径向方向。
            % 超参数 sigma_2,U_Cri
            for i=1:length(SVP(:,1))
                R_E = ((PXP_ENU(1)-Centre(1))+(Transducer_ENU(1)-PXP_ENU(1))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
                R_N = ((PXP_ENU(2)-Centre(2))+(Transducer_ENU(2)-PXP_ENU(2))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
                R = norm([R_E,R_N]);
                % GradE_T=0;GradN_T=0;
                detalR = GradE_T * R_E / R + GradN_T * R_N / R; % GradU(i,1) ,GradU(i,1)
                detalV=detalR * R;
                NewSVP(i,2) = NewSVP(i,2) + detalV;
            end
        end
    case 2
            [NewSVP] = SubCalSVP_SVPLayer_EN(Time,NewSVP,SVP,TMP,MPNum,knots,spdeg,Transducer_ENU,PXP_ENU,Centre,INIData,BSplineModel);


%         n = length(knots)/3;

        % 1.北、东方向水平梯度
%         for j = 1:n
%             eval(['GradE_T_Layer',num2str(j),'=','Bspline_Function(Time,TMP(MPNum(',num2str(n+j),')+1:MPNum(',num2str(1+n+j),')),knots{',num2str(n+j),'},spdeg,INIData.nchoosekList,BSplineModel);']);
%             eval(['GradN_T_Layer',num2str(j),'=','Bspline_Function(Time,TMP(MPNum(',num2str(2*n+j),')+1:MPNum(',num2str(2*n+j+1),')),knots{',num2str(2*n+j),'},spdeg,INIData.nchoosekList,BSplineModel);']);
%         end
        % 2.东、北方向声速变化;exp(-h)垂直变化(理解发生偏差：将所受方向投影中至E、N坐标系)
        %     for i=1:length(SVP(:,1))
        %       sa  detalVE=GradE_T*exp(0*SVP(i,1))*((PXP_ENU(1)-Centre(1))+(Transducer_ENU(1)-PXP_ENU(1))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
        %         detalVN=GradN_T*exp(0*SVP(i,1))*((PXP_ENU(2)-Centre(2))+(Transducer_ENU(2)-PXP_ENU(2))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
        %         detalV(i,1)=norm([detalVE,detalVN]);
        %     end
        %     NewSVP(:,2)=NewSVP(:,2)+detalV;

        % 3.将E、N方向梯度变化投影至观测径向方向。
        % 超参数 sigma_2,U_Cri
%         for i=1:length(SVP(:,1))
%             R_E = ((PXP_ENU(1)-Centre(1))+(Transducer_ENU(1)-PXP_ENU(1))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
%             R_N = ((PXP_ENU(2)-Centre(2))+(Transducer_ENU(2)-PXP_ENU(2))/(-PXP_ENU(3))*(-PXP_ENU(3)-SVP(i,1)));
%             R = norm([R_E,R_N]);
%             % GradE_T=0;GradN_T=0;
%             Layer = interp1([INIData.SVPSeg realmax],0:length(INIData.SVPSeg),SVP(i,1),'next','extrap');
%             eval(['detalR = GradE_T_Layer',num2str(Layer+1),' * R_E / R + GradN_T_Layer',num2str(Layer+1),' * R_N / R;']);
% 
%             detalV = detalR * R;
%             NewSVP(i,2) = NewSVP(i,2) + detalV;
%         end
end


% Yokota（2019）提取初级梯度场和次级梯度场
% 个人想法：整合两作者的思路进行声速剖面补偿
% 对需要对梯度赋初值，计算初值先做预估将梯度和角度先做成待估常量(方程仍需确定振幅初值)(角度后续转为方位角)
% detalV_Amp=0;detalV_PH=0;
% if size(knots,1)>=3
%     % 1.声速水平梯度整幅变化
%     for i=1:MPNum(3)-MPNum(2)
%         detalV_Amp=detalV_Amp+TMP(MPNum(2)+i)*Bbase(i,spdeg,Time,knots(2,:));
%     end
%     % 2.测船与图形阵列中心水平位移
%     Tra_Hori=norm(Transducer_ENU(1:2)-Centre);
%     % 3.PXP与图形阵列中心水平距离
%     PXP_Hori=norm(PXP_ENU(1:2)-Centre);
%     % 4.投影函数
%     for i=1:MPNum(4)-MPNum(3)
%         detalV_PH=detalV_PH+TMP(MPNum(3)+i)*Bbase(i,spdeg,Time,knots(3,:));
%     end
%     % 角度方向确定atan2(Y,X)为与坐标N方向的夹角->E方向夹角;
%     Angle_N=atan2(Transducer_ENU(2)-Centre(2),Transducer_ENU(1)-Centre(1));
%     if pi/2-Angle_N<0
%         Angle_E=pi/2-Angle_N+2*pi;
%     else
%         Angle_E=pi/2-Angle_N;
%     end
%
%     ProjectFun=cos(detalV_PH-Angle_E);
%     %
%     detalV_Tra=exp(detalV_Amp)*Tra_Hori*ProjectFun/1000;
%     detalV_PXP=exp(detalV_Amp)*PXP_Hori*ProjectFun/1000;
%
%     % 5.声速变化投影至相应声速层
%     for i=1:length(SVP(:,1))
%         A=PXP_ENU(3)-SVP(i,1);
%         detalV(i,1)=detalV_PXP+A/PXP_ENU(3)*(detalV_Tra-detalV_PXP);
%     end
%     NewSVP(:,2)=NewSVP(:,2)+detalV;
% else
%     % 1.声速水平梯度整幅变化
%     detalV_Amp=TMP(MPNum(3));
%     % 2.测船与图形阵列中心水平位移
%     Tra_Hori=norm(Transducer_ENU(1:2)-Centre);
%     % 3.PXP与图形阵列中心水平距离
%     PXP_Hori=norm(PXP_ENU(1:2)-Centre);
%     % 4.投影函数
%     detalV_PH=TMP(MPNum(4));
%     ProjectFun=cos(detalV_PH-atan((Transducer_ENU(2)-Centre(2))/(Transducer_ENU(1)-Centre(1))));
%     %
%     detalV_Tra=detalV_Amp*Tra_Hori*ProjectFun;
%     detalV_PXP=detalV_Amp*PXP_Hori*ProjectFun;
%
%     % 5.声速变化投影至相应声速层
%     for i=1:length(SVP(:,1))
%         A=PXP_ENU(3)-SVP(i,1);
%         detalV(i,1)=detalV_PXP+A/PXP_ENU(3)*(detalV_Tra-detalV_PXP);
%     end
%     NewSVP(:,2)=NewSVP(:,2)+detalV;
% end

end

