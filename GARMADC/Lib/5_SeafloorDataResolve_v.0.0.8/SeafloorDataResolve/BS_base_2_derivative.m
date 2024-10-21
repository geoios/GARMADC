function [H2,H1,H3] = BS_base_2_derivative(imp0,p,knots,smoothmodel)
%% 程序缺陷：假若参数给定中含有部分费B样条参数（需解决）(平滑因子的构建似乎出现问题)
% 参考以前的写的程序，平滑因子是当作虚拟观测用，还是当作先验信息用
% 我们将给出两种模式，一种是作为先验信息；一种是作为虚拟观测

%% B样条一阶构建
RR=zeros(imp0(end),imp0(end));
syms r
BB{1}=0.5*(-r^2+2*r-1);
BB{2}=0.5*(3*r^2-4*r);
BB{3}=0.5*(-3*r^2+2*r+1);
BB{4}=0.5*r^2;

for k=1:imp0(end)-imp0(1)
    for l=1:imp0(end)-imp0(1)
        if abs(k-l)<4
            for m=1:4-abs(k-l)
                y=BB{m}*BB{m+abs(k-l)};
                RR(imp0(1)+k,imp0(1)+l)=RR(imp0(1)+k,imp0(1)+l)+int(y,r,0,1);
            end
        else
            RR(imp0(1)+k,imp0(1)+l)=0;
        end
    end
end
switch smoothmodel
    case 1
        H1=RR;
    case 2
        R = chol(RR(imp0(1)+1:imp0(end),imp0(1)+1:imp0(end)));
        H1=R;
end

% 检验矩阵是否正定：1.是否为对称矩阵 2.特征值是否全为正数
% issymmetric(RR(imp0(1)+1:imp0(end),imp0(1)+1:imp0(end)))
% eig(RR(imp0(1)+1:imp0(end),imp0(1)+1:imp0(end)))


%% B样条二阶构建（公式）（似乎存在错误inv()）
H=zeros(imp0(end),imp0(end));
for j=1:length(knots)
    S=imp0(j+1)-imp0(j);
    Q=zeros(S-2,S);
    R=zeros(S-2,S-2);
    for i=1:1:S-2
        % 定义节knots点区间长度，h=t(i+1)-t(i)
        knotslist = knots{j};
        dk0=(knotslist(i+p+1)-knotslist(i+p))/3600;
        dk1=(knotslist(i+p+2)-knotslist(i+p+1))/3600;

        % 构建矩阵Q和R
        Q(i,i)=1/dk0;
        Q(i,i+1)=-1/dk0-1/dk1;
        Q(i,i+1+1)=1/dk1;
        if i>=2
            R(i,i-1)=1/6*dk0;
            R(i-1,i)=1/6*dk0;
        end
        R(i,i)=1/3*(dk0+dk1);
    end
    subR = chol(R);
    K=Q'*(subR')*subR*Q;
    H(imp0(j)+1:imp0(j+1),imp0(j)+1:imp0(j+1)) = K;
end

switch smoothmodel
    case 1
        H2=H;
    case 2
        H2=[];
%         H2= chol(H(imp0(1)+1:imp0(end),imp0(1)+1:imp0(end)));
end
% H 矩阵应为对称矩阵
% 可能存在计算保留小数问题导致的，要强制性指定其为对称矩阵


%% B样条2阶构建（数值）
% 根据参数位置行列确定积分上下限

DD=zeros(imp0(end),imp0(end));
syms q
bb{1}=q;
bb{2}=-3*q+1;
bb{3}=3*q-2;
bb{4}=-q+1;

for k=1:imp0(end)-imp0(1)
    for l=1:imp0(end)-imp0(1)
        if abs(k-l)<4
            for m=1:4-abs(k-l)
                Y=bb{m}*bb{m+abs(k-l)};
                DD(imp0(1)+k,imp0(1)+l) = DD(imp0(1)+k,imp0(1)+l)+int(Y,q,0,1);
            end
        else
            DD(imp0(1)+k,imp0(1)+l) = 0;
        end
    end
end

switch smoothmodel
    case 1
        H3=DD;
    case 2
        H3 = chol(DD(imp0(1)+1:imp0(end),imp0(1)+1:imp0(end)));
end
end

