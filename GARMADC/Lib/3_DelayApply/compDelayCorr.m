function [delayOut_inte,kc_inte] = compDelayCorr(intePos,souH,aimH,zeniAng_tan,ParGrid)
%% ����˵��
%���ܣ������ӳٸ���
%% ���ܴ���
count = 0;
for jProf = 1:size(ParGrid,1)
    count = count + 1;
    ParGrid_sing = ParGrid{jProf,1};
    [gridPos(count,:),delayOut(count,:),kc(count,:)] = compDelayCorr_ggmed(souH,aimH,zeniAng_tan,ParGrid_sing);%����
end
%���Բ�ֵ
delayOut_inte = [polyInte_prod(intePos,[gridPos delayOut(:,1)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,2)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,3)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,4)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,5)]) ...
                 polyInte_prod(intePos,[gridPos delayOut(:,6)])];
kc_inte = polyInte_prod(intePos,[gridPos kc]);

%% ��������
function [gridPos,delayOut,kc] = compDelayCorr_ggmed(souH,aimH,zeniAng_tan,ParGrid)
%%����˵��
%���ܣ����㻻������Ӧ�����ľ����ӳٸ�����_GGMED����
%%���ܴ���
gridPos = (ParGrid(1).pos)';
%�ӳٸ���
for iFloor = 1:size(ParGrid,1)
    [distDelay,kc] = compDistDelay(zeniAng_tan,ParGrid(iFloor,1));
    delayGrid(iFloor,:) = [ParGrid(iFloor,1).depthRange distDelay];%�ӳٸ�����Ʒ
end
%�����������ӳ�
depthList = [delayGrid(1,1);delayGrid(:,2)];
findPos = find(depthList <= souH);
floorNum = findPos(end);
p = (depthList(floorNum+1)-souH)/(depthList(floorNum+1)-depthList(floorNum));
if(floorNum == 1)
    headDelay = delayGrid(floorNum,3:8) - (delayGrid(floorNum,3:8)-0)*p;
else
    headDelay = delayGrid(floorNum,3:8) - (delayGrid(floorNum,3:8)-delayGrid(floorNum-1,3:8))*p;
end
%Ӧ���������ӳ�
findPos = find(depthList <= aimH);
floorNum = findPos(end); 
p = (depthList(floorNum+1)-aimH)/(depthList(floorNum+1)-depthList(floorNum));
if(floorNum >= size(delayGrid,1))%�������һ��
    tailDelay = 0+(delayGrid(end,3:8)-delayGrid(end-1,3:8))*p;
else
    tailDelay = (delayGrid(end,3:8)-delayGrid(floorNum,3:8)) + (delayGrid(floorNum,3:8)-delayGrid(floorNum-1,3:8))*p;
end
%���ӳ�
delayOut = delayGrid(end,3:8) - headDelay - tailDelay;
delayOut = [-delayOut(1:3) +delayOut(4:6)];

%% ��������
function [distDelay,kc] = compDistDelay(zeniAng_tan,ParGrid)
%%����˵��
%���ܣ���ȡ�����ӳ�
%%���ܴ���
%��ֵ��Ӧkj
A = [1 zeniAng_tan zeniAng_tan^2 zeniAng_tan^3 zeniAng_tan^4 zeniAng_tan^5];
kc = A*ParGrid.Coef.kc;

Dt = A*ParGrid.Coef.dt;
Ds = A*ParGrid.Coef.ds;
Dp = A*ParGrid.Coef.dp;
Dtt = A*ParGrid.Coef.dtt;
Dtp = A*ParGrid.Coef.dtp;
Dpp = A*ParGrid.Coef.dpp;
%�ӳ���
distDelay = [Dt Ds Dp Dtt Dtp Dpp];