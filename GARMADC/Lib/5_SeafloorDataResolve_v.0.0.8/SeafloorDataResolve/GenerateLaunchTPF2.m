function [SurData,NeedData,OutData] = GenerateLaunchTPF2(Data,SurData,NeedData,OutData)

% 老师的方法寻找
[NeedData] = SVPresampling(NeedData);
[NeedData]=SVPFixedInterval(NeedData);


% 3.读取修正矩阵系数阵
EOFA=NeedData.EOFA;[m,n]=size(EOFA);
Date=NeedData.Date;Year=NeedData.Year;
LaunchRT=NeedData.LaunchRT;
RrferTD=datetime(LaunchRT(1),LaunchRT(2),LaunchRT(3));
RrferT=day(RrferTD,'dayofyear');
RT=RrferT*24*3600+LaunchRT(4)*3600+LaunchRT(5)*60+LaunchRT(6);

for k=1:1:m
    A=[];
    for i=1:length(NeedData.SubProfile)
        TDStart=datetime(Year,Date{i}(1,1),Date{i}(1,2));
        DayStart=day(TDStart,'dayofyear');
        TDEnd=datetime(Year,Date{i}(end,1),Date{i}(end,2));
        DayEnd=day(TDEnd,'dayofyear');
        
        TStart=DayStart*24*3600+Date{i}(1,3)*3600+Date{i}(1,4)*60+Date{i}(1,5)-RT;
        TEnd=DayEnd*24*3600+Date{i}(end,3)*3600+Date{i}(end,4)*60+Date{i}(end,5)-RT;
        MT=(TStart+TEnd)/2;
        DayT=MT/3600/24;
        
        for j=1:1:n
            A(i,j)=ErrorFunction(EOFA{k,j},DayT);
        end
        NeedData.A{k}=A;
    end
end

R2SVP=[];MonolayerFun=NeedData.MonolayerFun;
for j=1:size(Data,2)
    T=SurData(j).T;MonolayerSVPAvg=[];
    for k=1:size(Data(j).xx,1)
        TStart=Data(j).TStart(k);
        for i=1:size(Data(j).X,1)
            DayOfRT=(TStart+(i-1)*T-RT)/3600/24;
            [NewSVP,NeedData] = RestructureSVP2(DayOfRT,NeedData);
            if SurData(j).SVPRandom==0
                MonolayerSVPAvg=0;
                NewSVP=NeedData.SurSVPAvg;
            elseif SurData(j).SVPRandom==1
                MonolayerSVPAvg=0;
            elseif SurData(j).SVPRandom==2
                NewSVP=NeedData.MonolayerSVP;
                MonolayerSVPAvg=[MonolayerSVPAvg,ErrorFunction(MonolayerFun,DayOfRT)];
            end
            SVP(:,:,i)= PFGrad(NewSVP,2,1);
        end
        LSVP=[];
        for i=1:size(Data(j).X,1)
            SurData(j).MTSVP(k).SVPData(i).PF=SVP(:,:,i);
            LSVP(:,i)=SVP(:,2,i);
        end
        LSVPavg=mean(LSVP,2);
        if SurData(j).SVPRandom==2
            OutData(j).MTLSVPAvg(k).LSVPAvg=[NeedData.MonolayerSVP(:,1),LSVPavg];
            R2SVP(:,:,k)=[R2SVP(:,:,k),LSVPavg];
        else
            OutData(j).MTSVPAvg(k).SVPAvg=NeedData.SurSVPAvg;
            OutData(j).MTLSVPAvg(k).LSVPAvg=[NeedData.SurSVPAvg(:,1),LSVPavg];
        end
    end
end
for j=1:size(Data,2)
    for k=1:size(Data(j).xx,1)
    if SurData(j).SVPRandom==2
        OutData(j).MTSVPAvg(k).SVPAvg=[NeedData.MonolayerSVP(:,1),mean(R2SVP(:,:,k),2)];
    end
    end
end
c=1;
for j=1:size(Data,2)
    for k=1:size(Data(j).xx,1)
    AllSVP(:,c)= OutData(j).MTSVPAvg(k).SVPAvg(:,2);
    c=c+1;
    end
end

for j=1:size(Data,2)
    OutData(j).SVPAvg=[NeedData.SurSVPAvg(:,1),mean(AllSVP,2)];
end
end

