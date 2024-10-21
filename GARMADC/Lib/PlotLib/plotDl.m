function plotDl(dL1,dL2,sele)
%% 函数说明
%功能：绘制文章中的剖面比较图
%% 功能代码
for iStatiSeri = 1:size(dL1,1)
    subplot(7,5,iStatiSeri);
    plot(1:size(dL1{iStatiSeri,1}),dL1{iStatiSeri,1},'.',...
         'Markers',3,...
         'MarkerEdgeColor',[54 195 201]/255,...
         'MarkerFaceColor',[54 195 201]/255);
         hold on;
    plot(1:size(dL2{iStatiSeri,1}),dL2{iStatiSeri,1},'.',...
         'Markers',3,...
         'MarkerEdgeColor',[0.99 0.57 0.59],...
         'MarkerFaceColor',[0.99 0.57 0.59]);

    epochNum = size(dL1{iStatiSeri,1},1);
	xlim([-ceil(epochNum*0.02),epochNum+ceil(epochNum*0.02)]);
    xticks(0:(epochNum+ceil(epochNum*0.02)):(epochNum+ceil(epochNum*0.02)))
    xtickangle(0)
    
    yMax = max([dL2{iStatiSeri,1};dL1{iStatiSeri,1}]);
    yMin = min([dL2{iStatiSeri,1};dL1{iStatiSeri,1}]);
    ylab = max([abs(ceil(yMin)) abs(ceil(yMax))]);
    yticks(-ylab:ylab:ylab);
    ylim([-ylab,ylab]);
    
    %不同方法绘图差异
    if(sele == 1)
        if(iStatiSeri == 16)
            pos = axis;
            ylabel('Distance residual (m)','position',[-epochNum*0.4 (pos(3)+pos(4))/2]);
        end
        if(iStatiSeri == 33)
            pos = axis;
            xlabel('Epoch number','position',[(pos(1)+pos(2))/2 yMin*1.6]);
        end
    elseif(sele == 2)
        if(iStatiSeri == 16)
            pos = axis;
            ylabel('Distance residual (m)','position',[-epochNum*0.3 (pos(3)+pos(4))/2]);
        end
        if(iStatiSeri == 33)
            pos = axis;
            xlabel('Epoch number','position',[(pos(1)+pos(2))/2 yMin*3]);
        end
    end
    set(gca,'FontSize',8,'Fontname','Arial','FontWeight','bold');%
end
%标注
if(sele == 1)
    legend('Without static delay correction','With static delay correction','FontSize',8,'box','on','position',[0.46 0.9 0.1 0.1],'Orientation','horizon')
elseif(sele == 2)
    legend('Without dynamic delay correction','With dynamic delay correction','FontSize',8,'box','on','position',[0.46 0.9 0.1 0.1],'Orientation','horizon')
end
set(gcf,'Units','centimeter','Position',[0 0 16.6 17.7]);

