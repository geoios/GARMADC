function [ParGrid] = inteModeling_prod(ParGrid)
%% 函数说明（修正）
%功能：(tanz,Dj)插值建模
%% 功能代码
    for iFloor = 1:size(ParGrid,1)
        %kc建模
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).KjGrid.kc];
        [ParGrid(iFloor).Coef.kc] = getCoef(xy);
        
        %Dt建模
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.dt];
        [ParGrid(iFloor).Coef.dt] = getCoef(xy);
        %Ds建模
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.ds];
        [ParGrid(iFloor).Coef.ds] = getCoef(xy);
        %Dp建模
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.dp];
        [ParGrid(iFloor).Coef.dp] = getCoef(xy);
        %Dtt建模
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.tt];
        [ParGrid(iFloor).Coef.dtt] = getCoef(xy);
        %Dtp建模
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.tp];
        [ParGrid(iFloor).Coef.dtp] = getCoef(xy);
        %Dpp建模
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.pp];
        [ParGrid(iFloor).Coef.dpp] = getCoef(xy);
    end
    function [coef,B] = getCoef(xy)
        x = xy(:,1);
        y = xy(:,2);
        B = [ones(size(x,1),1) x x.^2 x.^3 x.^4 x.^5];
        coef = (B'*B)^(-1)*(B'*y); 
    end
end