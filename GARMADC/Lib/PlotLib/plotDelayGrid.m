function plotDelayGrid(ParGrid)
%% 函数说明
%功能：绘制剖面
%% 功能代码
for iFloor = 1:size(ParGrid,1)
    gridX(iFloor,:) = ParGrid(iFloor).inciAngAndZeniAng_tan(:,1)';
    gridY(iFloor,:) = repmat(ParGrid(iFloor).depthRange(2),1,size(gridX,2));
    gridZ(iFloor,:) = (ParGrid(iFloor).DjGrid.dt + ParGrid(iFloor).DjGrid.ds + ParGrid(iFloor).DjGrid.dp + ParGrid(iFloor).DjGrid.tt + ParGrid(iFloor).DjGrid.tp + ParGrid(iFloor).DjGrid.pp)';
end

pcolor(gridX,gridY,gridZ);
xlabel('Incidence angle (\circ)');  
ylabel('Depth (m)');
ylim([0 2000]);

h = colorbar;
shading interp; 
set(get(h,'title'),'string','Delay distance (m)','FontSize',8);
%格式设置
set(gca,'ydir','reverse','FontSize',8,'Fontname','Arial','linewidth',0.75,'tickdir','in');%,'FontWeight','bold'
set(gcf,'Units','centimeter','Position',[5 5 10 8]);
set(0,'defaultfigurecolor','w');


