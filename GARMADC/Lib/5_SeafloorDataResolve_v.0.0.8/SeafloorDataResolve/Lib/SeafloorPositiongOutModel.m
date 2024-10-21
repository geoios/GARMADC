function [REF,RSS,dX] = SeafloorPositiongOutModel(Cal_X,Real_X)
%% 各点观测残差平方和
RSS=zeros(1,3);num=length(Real_X);
dX=Cal_X(1:num)-Real_X;
for i=1:num/3
    detalX=dX(1+(i-1)*3:i*3);
    RSS(1)=RSS(1)+norm(detalX(1:2))^2/4;
    RSS(2)=RSS(2)+abs(detalX(3))^2/4;
    RSS(3)=RSS(3)+norm(detalX(1:3))^2/4;
end
RSS(1)=sqrt(RSS(1));RSS(2)=sqrt(RSS(2));RSS(3)=sqrt(RSS(3));
%% 虚拟中心点误差
err=[mean(dX(1:3:end-2)),mean(dX(2:3:end-1)),mean(dX(3:3:end))];
REF(1)=norm(err(1:2));
REF(2)=err(3);
REF(3)=norm(err);
end


