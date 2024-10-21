function [OBSData_Segmnet1,OBSData_Segmnet2,INIData,knots_Segmnet1,knots_Segmnet2,MP_Segmnet1,MP_Segmnet2,MPNum_Segment] = SegmentData(OBSData,INIData,knots,MP,MPNum,spdeg,style)
%% 更改数据总量
N_shot=str2double(INIData.Data_file.N_shot);
INIData.Data_file.N_shot=num2str(N_shot/2);
if style==1
%% 分割数据
fields=fieldnames(OBSData);
for i=1:length(fields)
eval(['OBSData_Former.',fields{i},'=','OBSData.',fields{i},'(1:N_shot/2);']);
eval(['OBSData_Latter.',fields{i},'=','OBSData.',fields{i},'(N_shot/2+1:N_shot);']);
end
OBSData_Segmnet1=OBSData_Former;OBSData_Segmnet2=OBSData_Latter;
%% 节点分割节点个数需要奇数个
knots_Former=knots(1:ceil((length(knots)+1))/2+spdeg);
knots_Latter=knots(floor((length(knots)+1)/2)-spdeg:end);
knots_Segmnet1=knots_Former;knots_Segmnet2=knots_Latter;
%% 更改参数个数
MP_Former = [MP(1:MPNum(1)),zeros(1,length(knots_Former)-spdeg-1)];
MP_Latter = [MP(1:MPNum(1)),zeros(1,length(knots_Latter)-spdeg-1)];
MP_Segmnet1=MP_Former;MP_Segmnet2=MP_Latter;
MPNum_Segment=[MPNum(1),length(MP_Former)];

elseif style ==2
%% 分割数据
OddNum=[1:8:N_shot,2:8:N_shot,3:8:N_shot,4:8:N_shot];OddNum=sort(OddNum);
EvenNum=[5:8:N_shot,6:8:N_shot,7:8:N_shot,8:8:N_shot];EvenNum=sort(EvenNum);
fields=fieldnames(OBSData);
for i=1:length(fields)
eval(['OBSData_Odd.',fields{i},'=','OBSData.',fields{i},'(OddNum);']);
eval(['OBSData_Even.',fields{i},'=','OBSData.',fields{i},'(EvenNum);']);
end
OBSData_Segmnet1=OBSData_Odd;OBSData_Segmnet2=OBSData_Even;
%% 节点分割节点个数不变
knots_Segmnet1=knots;knots_Segmnet2=knots;
%% 更改参数个数
MP_Segmnet1=MP;MP_Segmnet2=MP;
MPNum_Segment=MPNum;
end
end