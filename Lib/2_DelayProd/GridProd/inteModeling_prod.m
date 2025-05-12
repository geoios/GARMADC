function [ParGrid] = inteModeling_prod(ParGrid)
%% ����˵����������
%���ܣ�(tanz,Dj)��ֵ��ģ
%% ���ܴ���
    for iFloor = 1:size(ParGrid,1)
        %kc��ģ
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).KjGrid.kc];
        [ParGrid(iFloor).Coef.kc] = getCoef(xy);
        
        %Dt��ģ
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.dt];
        [ParGrid(iFloor).Coef.dt] = getCoef(xy);
        %Ds��ģ
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.ds];
        [ParGrid(iFloor).Coef.ds] = getCoef(xy);
        %Dp��ģ
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.dp];
        [ParGrid(iFloor).Coef.dp] = getCoef(xy);
        %Dtt��ģ
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.tt];
        [ParGrid(iFloor).Coef.dtt] = getCoef(xy);
        %Dtp��ģ
        xy = [ParGrid(iFloor).inciAngAndZeniAng_tan(:,2) ParGrid(iFloor).DjGrid.tp];
        [ParGrid(iFloor).Coef.dtp] = getCoef(xy);
        %Dpp��ģ
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