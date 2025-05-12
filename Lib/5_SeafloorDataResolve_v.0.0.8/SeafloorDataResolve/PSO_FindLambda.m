function [Lambda] = PSO_FindLambda(OBSData,INIData,SVP,MP,MPNum,knots,spdeg,deltap,H)
%%
Data.OBSData=OBSData;Data.INIData=INIData;Data.SVP=SVP;Data.MP=MP;Data.MPNum=MPNum;Data.knots=knots;Data.spdeg=spdeg;Data.deltap=deltap;Data.H=H;
%% 0.指定解算策略（目前有两种策略：1.将数据分为前后两部分数据集；2.将数据分奇偶数据集）
% 1.前后数据集（使用前后数据需注意由于前后数据集，时间上发生变化，
% 因此，在求解时（1）强制指定一般数据集对应的B样条基函数系数为0；（2）要么改变B样条节点区间）
% 尝试（1）
FindLambda_Stratefy{1}=@Stratefy_FormerLatter;
FindLambda_Stratefy{2}=@Stratefy_OddEven;
FindLambda_ComposeFunction=FindLambda_Stratefy{2};
%% 粒子集群算法
% 设置退出条件
E=0.000001;
% 设定最大迭代次数
maxnum=100;
% 目标函数的自变量个数
narvs=1;
% 粒子群规模
particlesize=10;
% 惯性因子
w=0.2;
% 每个例子的个体学习因子，加速度常数
c1=0.4;
% 每个例子的社会学习因子，加速度常数
c2=0.5;
% 粒子的最大飞行速度
vmax=1000;
% 位置参数限制
limit=[0,5000];
% 粒子飞行速度
v=10*rand(particlesize,narvs);
% 粒子所在范围
T=linspace(0,5000,particlesize);
t=T';
%定义适应度函数
for i=1:particlesize
    f(i)=FindLambda_ComposeFunction(t(i,:),Data);
end
personalbest_t=t;
personalbest_faval=f;
[globalbest_faval,i]=min(personalbest_faval);
globalbest_t=personalbest_t(i,:);
k=1;
while (k<=maxnum)
    for i=1:particlesize
        f(i)=FindLambda_ComposeFunction(t(i,:),Data);
        if f(i)<personalbest_faval(i)
            personalbest_faval(i)=f(i);
            personalbest_t(i,:)=t(i,:);
        end
    end
    if globalbest_faval<min(personalbest_faval)
        [globalbest_faval,i]=min(personalbest_faval);
        globalbest_t=personalbest_t(i,:);
    end
    for i=1:particlesize
        v(i,:)=w*v(i,:)+c1*rand*(personalbest_t(i,:)-t(i,:))...
            +c2*rand*(globalbest_t-t(i,:));
        % 边界速度处理
        for j=1:narvs
            if v(i,j)>vmax
                v(i,j)=vmax;
            elseif v(i,j)<-vmax
                v(i,j)=-vmax;
            end
        end
        t(i,:)=t(i,:)+v(i,:);
        % 边界位置处理
        for j=1:narvs
            if t(i,j)>limit(2)
                t(i,j)=limit(2);
            elseif t(i,j)<limit(1)
                t(i,j)=limit(1);
            end
        end
    end
    ff(k)=globalbest_faval;
    if globalbest_faval<E
        break
    end
    if length(ff)>20
        if ff(k-10:k)==ff(k)
            break
        end
        
    end
    %       figure(1)
    %       for i= 1:particlesize
    %       plot(x(i,1),x(i,2),'*')
    %       end
    k=k+1;
end
Lambda=globalbest_t;
end

