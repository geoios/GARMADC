% 绘制残差及标准差图像
% function Sigma = plot_dL(time,BSpanModel,Path)
close all;clear;clc;
load("time.mat")
BSpanModel = [15];
SSigma = [];
for BList = 1:length(BSpanModel)
    for i = 1:35
        try
%             close all;
            BNUM = BSpanModel(BList);
%             load([Path,num2str(i),'_',num2str(BNUM),'.mat'])
            load(['G:\sdlgxz_github\Dev\Apps\SeafloorDataResolve_v.0.0.2\SeafloorDataResolve\Results\',num2str(i),'_',num2str(BNUM),'.mat'])
            BigErr = find(strcmp(ModelT_MP_T_OBSData.flag,'True'));
            ModelT_MP_T_OBSData.detalT(BigErr) = [];
            c0 = MeanVel(SVP);
            dL = ModelT_MP_T_OBSData.detalT * c0;
            sigma(i,1) = std(dL);
            
%             Sigma = zeros(1,length(dL));
%             Sigma(1,:) = std(dL);
%     
%             biaoti1 = ['MYGI','.',num2str(time(i))];
%             biaoti2 = ['标准差',' = ',num2str(Sigma(1))];
%            
%             plot(dL,'b')
%             hold on;
%             plot(Sigma,'r','LineWidth',2)
%             xlabel('观测历元（个）')
%             ylabel('残差（m）')
%             title({biaoti1,biaoti2},'FontWeight','bold')
%             set(gca,'FontSize',12,'FontWeight','bold');
%             set(get(gca,'XLabel'),'FontSize',12,'FontWeight','bold');
%             set(get(gca,'YLabel'),'FontSize',12,'FontWeight','bold');
%             
%             str1='{\fontsize{11}\fontname{宋体}残差}';
%             str2='{\fontsize{11}\fontname{宋体}标准差}';
%             legend(str1,str2)
        catch
            continue
        end
%         StorgePath = ['D:\研究生\Self\数据处理_双指数模型\Figure\',num2str(BNUM),'_',num2str(time(i)),'.png'];
%         print(gcf,StorgePath,'-r600','-dtiff');
    end
    SSigma = [SSigma,sigma];
end
Sigma = [time,SSigma];