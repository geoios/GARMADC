function [NeedComposeResults]=VCdistance(ALL,Segment1,Segment2,MPNum,style)

%%  计算虚拟质心
ALL=ALL(1:MPNum(1));Segment1=Segment1(1:MPNum(1));Segment2=Segment2(1:MPNum(1));
AvgCen_ALL=[mean(ALL(1:3:end-2)),mean(ALL(2:3:end-1)),mean(ALL(3:3:end))];
AvgCen_Former=[mean(Segment1(1:3:end-2)),mean(Segment1(2:3:end-1)),mean(Segment1(3:3:end))];
AvgCen_Latter=[mean(Segment2(1:3:end-2)),mean(Segment2(2:3:end-1)),mean(Segment2(3:3:end))];

if style==1
    NeedComposeResults=(norm(AvgCen_Former-AvgCen_ALL))^2+(norm(AvgCen_Latter-AvgCen_ALL))^2;
elseif style==2
    NeedComposeResults=(norm(AvgCen_Former-AvgCen_Latter))^2;
end
end

