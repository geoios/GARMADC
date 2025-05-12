function [knots,MPNUM] = Make_Bspline_knots(M,spdeg,BSpan)
BSpanModel  = 1;

%% 判断接是否空
if isempty(BSpan)
    knots=[];MPNUM=[];
    return;
end
%% 时间B样条节点确定
% 计算每个section的时间相关信息
sets=unique(M.SET);
for i=1:length(sets)
    j=1;st0ss=[];stfss=[];
    for h=1:length(M.SET)
        if strfind(M.SET{h},sets{i})
            st0ss(j)=M.ST(h);
            stfss(j)=M.RT(h);
            j=j+1;
        end

    end
    st0s(i)=min(st0ss);
    stfs(i)=max(stfss);
end

% 确定每个周期节点参数个数
% 1.计算平均周期时长
setdurs = stfs-st0s;
setdur = mean(setdurs);
% 2. 两种方法确定B样条参数个数
switch BSpanModel
    case 1   % (1)指定大致分段时间对B样条进行分割(以分钟为单位)
        nestsum = fix(setdur./(BSpan*60));
    case 2  % (2)直接指定参数化个数
        nestsum = BSpan;
end
% 3.观测总时长可以分为多少个周期
st0=min(M.ST);stf=max(M.RT);
obsdur=stf-st0;
nestdur=fix(obsdur/setdur);         % 总观测时间/周期观测平均时长


for i=1:length(BSpan)
    nknots(i)=nestsum(i)*nestdur;
end

for i=1:length(nknots)
    knots{i}=linspace(st0,stf,nknots(i)+1);
end
MPNUM =zeros(1,length(BSpan));
for i=1:length(knots)
    if nknots(i)==0
        knots{i}=[];
        continue;
    end

    rmknot=[];

    % 判断观测数据中是否存在长时间观测间断
    for k = 1:length(sets)-1
        index = find(knots{i}>stfs(k) & knots{i}<st0s(k+1));
        if length(index) > 2*(spdeg+2)
            rmknot = [rmknot,index(spdeg+2:end-spdeg-1)];
        end
    end
    if ~isempty(rmknot)
        knots{i} (rmknot)=[];
    end

    dkn=(stf-st0)/nknots(i);
    k=1;
    for j=-spdeg:1:-1
        addkn0(k)=st0+dkn*j;
        k=k+1;
    end
    for j=1:1:spdeg
        addknf(j)=stf+dkn*j;
    end
    knots{i}=[addkn0,knots{i},addknf];
    MPNUM(i) = length(knots{i})-spdeg-1;
end



%% 高程B样条节点确定
% 根据SVPSpan分层间隔
% knots_First =zeros(1,spdeg);knots_End = zeros(1,spdeg);
% if ~isempty(SVPSeg) && ~isempty(SVPSpan)
%     Tnknots = length(knots);
%     NUM=length(SVPSeg);
%     for j=1:NUM-1
%         Hnknots = fix((SVPSeg(j+1)-SVPSeg(j))/SVPSpan(j));
%         knots0=linspace(SVPSeg(j),SVPSeg(j+1),Hnknots+1);
%         if isempty(knots0)
%             return
%         end
%         dknots=(SVPSeg(j+1)-SVPSeg(j))/Hnknots;
%         for i=1:1:spdeg
%             knots_First(i) = SVPSeg(j) - (spdeg-i+1)*dknots;
%             knots_End(i) = SVPSeg(j+1) + i*dknots;
%         end
%         knots{j + Tnknots}=[knots_First,knots0,knots_End];
%         MPNUM= [MPNUM,length(knots{j + Tnknots})-spdeg-1];
%     end
%
% end
end

