function [RESData,NeedData] = RestructureSVP3(T,NeedData)

PF=NeedData.SubProfile;
%% 求解声速场均值、去中心化声速场和特征向量以及修正系数矩阵
% 寻找剖面中最底的
for i=1:length(PF)
    MinValue(i)=max(size(PF{i}));
end
% 选取声速剖面最少的层数为基准构建EOF所需声速剖面矩阵
SoundVMatrix=[];[num,index]=min(MinValue);
for i=1:length(PF)
    SoundVMatrix=[SoundVMatrix,PF{i}(1:num,2)];
end
LaunchPF=PF{1}(:,2);
SVPAvg=mean(SoundVMatrix,2);
NeedData.SurSVPAvg=[PF{index}(1:num,1),SVPAvg];
SoundVMatrix=SoundVMatrix-LaunchPF(:,ones(length(PF),1));
[~,S,V]=svd(SoundVMatrix*SoundVMatrix'./num,0);
PC=V\SoundVMatrix;

%% 根据声速剖面的时间计算系数阵
% 由给定时间的声速剖面观测时间求解
for i=1:length(NeedData.A)
    A=NeedData.A{i};
    CoefficientMatrix(:,i)=pinv(A'*A)*(A'*PC(i,:)');
end
% 指定周期变化
CoefficientMatrix=NeedData.CoefficientMatrix;
%
EOFA=NeedData.EOFA;
for i=1:length(NeedData.A)
NewA=[];
    for j=1:size(NeedData.A{i},2)
        NewA(j)=ErrorFunction(EOFA{i,j},T);
    end
    NewPC(i)=NewA*CoefficientMatrix(:,i);
end
NewPC=NewPC';

NewF=V(:,1:size(EOFA,1));
EOFCheck=NeedData.EOFCheck;
NewSVP=LaunchPF+EOFCheck*NewF*NewPC;
NewSVP=[PF{index}(1:num,1),NewSVP];
NewSVP=PFGrad(NewSVP,2,1);
RESData.PF=NewSVP;
end