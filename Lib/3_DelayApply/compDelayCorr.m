function [delayOut_inte,kc_inte] = compDelayCorr(intePos,souH,aimH,zeniAng_tan,ParGrid)
%% 函数说明
%功能：计算延迟改正
%% 功能代码
count = 0;
for jProf = 1:size(ParGrid,1)
    count = count + 1;
    ParGrid_sing = ParGrid{jProf,1};
    [gridPos(count,:),delayOut(count,:),kc(count,:)] = compDelayCorr_ggmed(souH,aimH,zeniAng_tan,ParGrid_sing);%单程
end
%线性插值
delayOut_inte = [polyInte_prod(intePos,[gridPos delayOut(:,1)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,2)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,3)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,4)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,5)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,6)])];
kc_inte = polyInte_prod(intePos,[gridPos kc]);

%% 辅助函数
function [gridPos,delayOut,kc] = compDelayCorr_ggmed(souH,aimH,zeniAng_tan,ParGrid)
%%函数说明
%功能：计算换能器到应答器的距离延迟改正量_GGMED剖面
%%功能代码
gridPos = (ParGrid(1).pos)';
%延迟格网
for iFloor = 1:size(ParGrid,1)
    [distDelay,kc] = compDistDelay(zeniAng_tan,ParGrid(iFloor,1));
    delayGrid(iFloor,:) = [ParGrid(iFloor,1).depthRange distDelay];%延迟格网产品
end
%换能器以上延迟
depthList = [delayGrid(1,1);delayGrid(:,2)];
findPos = find(depthList <= souH);
floorNum = findPos(end);
p = (depthList(floorNum+1)-souH)/(depthList(floorNum+1)-depthList(floorNum));
if(floorNum == 1)
    headDelay = delayGrid(floorNum,3:8) - (delayGrid(floorNum,3:8)-0)*p;
else
    headDelay = delayGrid(floorNum,3:8) - (delayGrid(floorNum,3:8)-delayGrid(floorNum-1,3:8))*p;
end
%应答器以下延迟
findPos = find(depthList <= aimH);
floorNum = findPos(end); 
p = (depthList(floorNum+1)-aimH)/(depthList(floorNum+1)-depthList(floorNum));
if(floorNum >= size(delayGrid,1))%考虑最后一层
    tailDelay = 0+(delayGrid(end,3:8)-delayGrid(end-1,3:8))*p;
else
    tailDelay = (delayGrid(end,3:8)-delayGrid(floorNum,3:8)) + (delayGrid(floorNum,3:8)-delayGrid(floorNum-1,3:8))*p;
end
%总延迟
delayOut = delayGrid(end,3:8) - headDelay - tailDelay;
delayOut = [-delayOut(1:3) +delayOut(4:6)];

%% 辅助函数
function [distDelay,kc] = compDistDelay(zeniAng_tan,ParGrid)
%%函数说明
%功能：获取距离延迟
%%功能代码
%插值对应kj
A = [1 zeniAng_tan zeniAng_tan^2 zeniAng_tan^3 zeniAng_tan^4 zeniAng_tan^5];
kc = A*ParGrid.Coef.kc;

Dt = A*ParGrid.Coef.dt;
Ds = A*ParGrid.Coef.ds;
Dp = A*ParGrid.Coef.dp;
Dtt = A*ParGrid.Coef.dtt;
Dtp = A*ParGrid.Coef.dtp;
Dpp = A*ParGrid.Coef.dpp;
%延迟量
distDelay = [Dt Ds Dp Dtt Dtp Dpp];