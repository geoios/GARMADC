
% % 声速场拟合
% FunctionStyle(1).Calmode1=@Generation_model_error_partion;
% FunctionStyle(1).Calmode2=@Generate_correction_number_addLambda_partion;
% FunctionStyle(1).Calmode3=@Generation_model_error;
% FunctionStyle(1).Calmode4=@Generate_correction_number_addLambda;
% % 传播时间拟合
% FunctionStyle(2).Calmode1=@Generation_model_error2_partion;
% FunctionStyle(2).Calmode2=@Generate_correction_number2_addLambda_partion;
% FunctionStyle(2).Calmode3=@Generation_model_error2;
% FunctionStyle(2).Calmode4=@Generation_correction_number_addLambda_odd;
% 
% LaunchRT=NeedData.LaunchRT;
% RrferTD=datetime(LaunchRT(1),LaunchRT(2),LaunchRT(3));
% RrferT=day(RrferTD,'dayofyear');
% RT=RrferT*24*3600+LaunchRT(4)*3600+LaunchRT(5)*60+LaunchRT(6);
% % 提取观测初始时间和截止时间用于构造时变参数的节点
% KnotSTData=OutData(1).ST_TIME(1,:,1);KnotRTData=OutData(end).RT_TIME(end,:,end);
% KnotST=day(datetime(NeedData.Year,KnotSTData(1),KnotSTData(2)),'dayofyear')*24*3600+KnotSTData(3)*3600+KnotSTData(4)*60+KnotSTData(5);
% KnotRT=day(datetime(NeedData.Year,KnotRTData(1),KnotRTData(2)),'dayofyear')*24*3600+KnotRTData(3)*3600+KnotRTData(4)*60+KnotRTData(5);
% KnotTT=[KnotST,KnotRT];
% %
% mp=[x1(1,:),x1(2,:),x1(3,:),x1(4,:),zeros(1,20)];
% %% 总数据解算
% detalp=[10^-3,10^-6];
% MP=mp;iconv=0;
% nn=1;
% while 1
%     [detalT,ModelT] = Generation_model_error(SurData,OutData,Data,MP,RT,KnotTT);
%     [dX1] = Generate_correction_number(Data,SurData,OutData,MP,detalp,detalT,ModelT,RT,KnotTT);
%     MP=MP+dX1';
%     nn=nn+1;
%     dxmax=max(abs(dX1));dposmax=max(abs(dX1(1:size(Data(1).xx,1)*3)));
%     if dxmax<5*10^-4||dposmax<5*10^-5
%         CC(Cum)=nn;
%         break;
%     elseif dxmax<0.005
%         iconv=iconv+1;
%         if iconv==2
%             CC(Cum)=nn;
%             break;
%         end
%     elseif nn>20
%         CC(Cum)=nn;
%         break;
%     else
%         iconv=0;
%     end
% end
% mp_SVP(Cum,:)=MP;
% 
% MP=mp;
% detalp=[10^-3,1];
% nn=1;iconv=0;
% while 1
%     [detalT,ModelT] = Generation_model_error2(SurData,OutData,Data,MP,RT,KnotTT);
%     [dX] = Generate_correction_number2(Data,SurData,OutData,MP,detalp,detalT,ModelT,RT,KnotTT);
%     MP=MP+dX';
%     nn=nn+1;
%     dxmax=max(abs(dX));dposmax=max(abs(dX(1:size(Data(1).xx,1)*3)));
%     if dxmax<5*10^-4||dposmax<5*10^-5
%         DD(Cum)=nn;
%         break;
%     elseif dxmax<0.005
%         iconv=iconv+1;
%         if iconv==2
%             DD(Cum)=nn;
%             break;
%         end
%     elseif nn>20
%         DD(Cum)=nn;
%         break;
%     else
%         iconv=0;
%     end
% end
% mp_T(Cum,:)=MP;
% save(['Results\Parameter20_3000_3000_45_100_10-6_TWOSquare3.mat'],'mp_SVP','mp_T','mp_SVP_F','mp_T_F','mp_SVP_L','mp_T_L','CC','DD','EE','FF','GG','HH');
% % 时延正态时变周期估计坐标及声速变化\,'Lambda1'
%% 拟合声速场
%              for LUM=1:length(Lambda)
%                 iconv=0;nn=1;
%                 MP=mp;
%
%                 while 1
%                     [detalT,ModelT] = Generation_model_error(SurData,OutData,Data,MP,RT,KnotTT);
%                     [dX] = Generate_correction_number_addLambda(Data,SurData,OutData,MP,detalp,detalT,ModelT,RT,KnotTT,Lambda(LUM),1:60);
%                     MP=MP+dX';
%                     nn=nn+1;
%                     dxmax=max(abs(dX));dposmax=max(abs(dX(1:size(Data,1)*3)));
%                     if dxmax<5*10^-4||dposmax<5*10^-5
%                         GG(Cum,LUM)=nn;
%                         break;
%                     elseif dxmax<0.005
%                         iconv=iconv+1;
%                         if iconv==2
%                             GG(Cum,LUM)=nn;
%                             break;
%                         end
%                     elseif nn>30
%                         GG(Cum,LUM)=nn;
%                         break;
%                     else
%                         iconv=0;
%                     end
%                 end
%                 mp2(Cum,:,LUM)=MP;
%              end
%
%             MP=mp;
%             xk=[5];
%             [NewRules,lambda1] = Hooke_Jeeves_NewRules( xk,Data,SurData,OutData,NeedData,MP,detalp,FunctionStyle(1));
%

%% 拟合观测时间


%             for LUM=1:length(Lambda)
%                 iconv=0;nn=1;
%                 MP=mp;
%
%                 while 1
%                     [detalT,ModelT] = Generation_model_error2(SurData,OutData,Data,MP,RT,KnotTT);
%                     [dX] = Generate_correction_number2_addLambda(Data,SurData,OutData,MP,detalp,detalT,ModelT,RT,KnotTT,Lambda(LUM));
%                     MP=MP+dX';
%                     nn=nn+1;
%                     dxmax=max(abs(dX));dposmax=max(abs(dX(1:size(Data,1)*3)));
%                     if dxmax<5*10^-4||dposmax<5*10^-5
%                         GG(Cum,LUM)=nn;
%                         break;
%                     elseif dxmax<0.005
%                         iconv=iconv+1;
%                         if iconv==2
%                             GG(Cum,LUM)=nn;
%                             break;
%                         end
%                     elseif nn>20
%                         GG(Cum,LUM)=nn;
%                         break;
%                     else
%                         iconv=0;
%                     end
%                 end
%                 mp4(Cum,:,LUM)=MP;
%             end
% 超参数拟合声速场
%             MP=mp;
%             xk=[5];
%             [NewRules,lambda2] = Hooke_Jeeves_NewRules( xk,Data,SurData,OutData,NeedData,MP,detalp,FunctionStyle(2));
%
%             iconv=0;nn=1;
%             while 1
%                 [detalT,ModelT] = Generation_model_error2(SurData,OutData,Data,MP,RT,KnotTT);
%                 [dX] = Generate_correction_number2_addLambda(Data,SurData,OutData,MP,detalp,detalT,ModelT,RT,KnotTT,lambda2);
%                 MP=MP+dX';
%                 nn=nn+1;
%                 dxmax=max(abs(dX));dposmax=max(abs(dX(1:size(Data,1)*3)));
%                 if dxmax<5*10^-4||dposmax<5*10^-5
%                     EE(Cum)=nn;
%                     break;
%                 elseif dxmax<0.005
%                     iconv=iconv+1;
%                     if iconv==2
%                         EE(Cum)=nn;
%                         break;
%                     end
%                 elseif nn>20
%                     EE(Cum)=nn;
%                     break;
%                 else
%                     iconv=0;
%                 end
%             end
%             mp4(Cum,:)=MP;
%
%
%             while 1
%                 [detalT,ModelT] = Generation_model_error(SurData,OutData,Data,MP,RT,KnotTT);
%                 [dX] = Generate_correction_number_addLambda(Data,SurData,OutData,MP,detalp,detalT,ModelT,RT,KnotTT,lambda1,1:60);
%                 MP=MP+dX';
%                 nn=nn+1;
%                 dxmax=max(abs(dX));dposmax=max(abs(dX(1:size(Data,1)*3)));
%                 if dxmax<5*10^-4||dposmax<5*10^-5
%                     DD(Cum,:)=nn;
%                     break;
%                 elseif dxmax<0.005
%                     iconv=iconv+1;
%                     if iconv==2
%                         DD(Cum,:)=nn;
%                         break;
%                     end
%                 elseif nn>20
%                     DD(Cum,:)=nn;
%                     break;
%                 else
%                     iconv=0;
%                 end
%             end
%             mp2(Cum,:)=MP;

%%  拟合观测时间