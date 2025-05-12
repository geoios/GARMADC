function [Lambda] = Hooke_Jeeves_FindLambda(InitialLambda,OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H)
Data.OBSData=OBSData;Data.INIData=INIData;Data.SVP=SVP;Data.MP=MP;Data.MPNum=MPNum;Data.knots=knots;Data.spdeg=spdeg;Data.deltap=deltap;Data.H=H;
%% 0.指定解算策略（目前有两种策略：1.将数据分为前后两部分数据集；2.将数据分奇偶数据集）
% 1.前后数据集（使用前后数据需注意由于前后数据集，时间上发生变化，
% 因此，在求解时（1）强制指定一般数据集对应的B样条基函数系数为0；（2）要么改变B样条节点区间）
% 尝试（1）
FindLambda_Stratefy{1}=@Stratefy_FormerLatter;
FindLambda_Stratefy{2}=@Stratefy_OddEven;
FindLambda_ComposeFunction=FindLambda_Stratefy{2};
%% 1.Hooke_Jeeve算法配置
% 输入初始探测搜索步长 delta;
% 加速因子 alpha(alpha>=1),
% 缩减率 beta(0<beta<1),
% 允许误差 epsilon(epsilon>0)，
% 初始点xk
delta=5;alpha=2;beta=0.25;epsilon=0.01;LOOP=30;
% 初始化迭代次数
k=1;j=1;
xk=InitialLambda;
yk(j)=InitialLambda;

%% 2.Hooke_Jeeve算法
for L=1:LOOP
    e=1;
    t1=FindLambda_ComposeFunction(yk(j)+delta*e,Data);
    t2=FindLambda_ComposeFunction(yk(j),Data);
    if t1<t2
        yk(j+1)=yk(j)+delta*e;
    else
        t1=FindLambda_ComposeFunction(yk(j)-delta*e,Data);
        if t1<t2
            yk(j+1) = yk(j) - delta * e;
        else
            yk(j+1) = yk(j);
        end
    end
    t1=FindLambda_ComposeFunction(yk(2),Data);
    t2=FindLambda_ComposeFunction(xk(k),Data);
    if t1<t2
        xk(k+1)=yk(2);
        yk(1)=xk(k+1)+alpha*(xk(k+1)-xk(k));
    else
        delta=delta*beta;
        xk(k+1)=xk(k);
        yk(1)=xk(k);
    end
    k=k+1;j=1;
    if delta<=epsilon
        % 在局部最优附近进行探索检验是否有更小值
        T2=FindLambda_ComposeFunction(yk(1),Data);
        for i=1:3
            dL=10^i*rand;
            if yk(1)-dL>=0
                dL1(i)=yk(1)-dL;
            else
                dL1(i)=yk(1)-unifrnd (0,yk(1));
            end
            T1(i)=FindLambda_ComposeFunction(yk(1)-dL1(i),Data);
            dL3(i)=yk(1)+dL;
            T3(i)=FindLambda_ComposeFunction(yk(1)+dL3(i),Data);
        end
        dTL(1,:)=[dL1,dL3];dTL(2,:)=[T1,T3];
        [Tmin,Tidx]=min(dTL(2,:));
        if Tmin<T2
            [yk(1)] = Hooke_Jeeves_FindLambda(dTL(1,Tidx),OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H);
        else
            break;
        end
    end
end
Lambda=yk(1);
end
