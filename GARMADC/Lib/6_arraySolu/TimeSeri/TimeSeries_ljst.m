function [t,Result,dCenter,Y] = TimeSeries(ObsPath,FixFilePath,SingleEpochData,OffsetType)
%% 获取文件路径
Wildcard    = '\*';
ObsTag      = '-obs.csv';
IndexTag    = [Wildcard,ObsTag];
FileStruct  = FileExtract_ljst(ObsPath,IndexTag);
SvpTag      = '-svp.csv';
FileStruct  = nTypeFileLink_ljst(FileStruct,ObsTag,ObsPath,SvpTag);
% Model1 阵列基准坐标的路径
FixTag   = '-fix.ini';
FileStruct  = nTypeFileLink_ljst(FileStruct,ObsTag,FixFilePath,FixTag);

%% 获取时间信息
[time] = ReadJapTime_ljst(0,FileStruct);  % 获取日本观测时间，即年月日
for i = 1:length(time)
    t(i,1) = datenum(time(i,1),time(i,2),time(i,3));  % 将年月日转换为系统时间
end
MidDay = mean(t);
delt   = (t - MidDay)/365;

%% 选择偏移量类型
switch OffsetType
    case 0
        % 单历元中心点坐标
        for j = 1:FileStruct.FileNum
            SingleEpochCenter(j,:) = mean(SingleEpochData{j});
        end
        
        % 阵列基准中心点坐标 (E,N,U)
        for j = 1:FileStruct.FileNum
            ArrayPath   = FileStruct.SubFileList{3,j};
            ArrayData   = ReadNSinex_ljst(ArrayPath);
            ArraySingle = Extraction_x0_ljst(ArrayData,1);
            ArrayCenter(j,:) = mean(ArraySingle);
        end
        % 中心偏移量
        dCenter = SingleEpochCenter - ArrayCenter;
    case 1
        dCenter = SingleEpochData;
end

%% 拟合计算 (E,N,U)
RobPar = RobustControlPar_ljst();
P      = ones(length(delt),1);
A      = [P delt];
V      = [];
Sig    = [];
for i = 1:3
    % 拟合直线所需的参数
    [x,sigma,L_est,v,P,Qx] = RobLS_ljst(A,dCenter(:,i),P,RobPar);
    X{i} = x;sig{i} = sigma;
    % 拟合直线
    y = x(1) + x(2) * delt;
    Y(:,i) = y;
    % 拟合站速度、拟合标准差
    V   = [V,X{i}(2)];
    Sig = [Sig,sig{i}];
end
Result = [V,Sig];

