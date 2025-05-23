close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;
% 指定数据所在目录
Wildcard = '\*';
StnName  = 'KAMN';
StnPath  = 'G:\sdlgxz_github\data_Tohoku2011-2020';

% 观测文件目录
ObsPath  = [StnPath,'\obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 解算结果文件目录
ConfPath = [StnPath,'\single-default\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

%%  获取每个观测历元解算坐标
PostionNameList=[];
ncamp = 0;ndata = zeros(1,FileStruct.FileNum);
for DataNum = 1: FileStruct.FileNum
    %% 数据格式转化
    %----------------观测文件绝对路径-----------------
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    %----------------声速剖面绝对路径-----------------
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    %----------------配置参数设置文件-----------------
    INIFilePath = FileStruct.SubFileList{3,DataNum};
%     
%         [OBSData,SVP,INIData,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
%         MPList(DataNum).MP = MP1;
    
    load(['G:\sdlgxz_github\data_Tohoku2011-2020-ChangeSVP\MYGW和KAMN单历元\5参数\KAMN\15_35_',num2str(DataNum),'.mat'],'INIData','ModelT_MP_T','MPNum');
    MPList(DataNum).MP = ModelT_MP_T(1:MPNum(1));
    StationsList{DataNum} = INIData.Site_parameter.Stations;
    PostionName = regexp(StationsList{DataNum},'\s+','split');
    ndata(DataNum)=length(PostionName);
    PostionNameList = unique([PostionNameList,PostionName]);
    
    
    ncamp = ncamp + 1;
    
end
pdata = 1:ncamp;DeletList = [];IteMaxLoop = 20;
%% 矩阵构建
for i = 1:IteMaxLoop
    % 1.判断行数、列数，构建H矩阵
    allMT = length(PostionNameList);
    H  = zeros(sum(ndata(pdata))+1,allMT+length(pdata));
    data = zeros(sum(ndata(pdata))+1,3);
    row = 1;
    
    % 观测历元数循环
    for Num = 1:length(pdata)
        CampNum = pdata(Num);
        % 单历元站点数循环
        for allNum = 1:allMT
            PostionNameLable = PostionNameList{allNum};
            PosNameSegList = regexp(StationsList{CampNum},'\s+','split');
            PosNameSegIndex = find(contains(PosNameSegList,PostionNameLable)==1);
            if ~isempty(PosNameSegIndex)
                H_Sta_Index = find(contains(PostionNameList,PostionNameLable)==1);
                H(row,H_Sta_Index) = 1;H(row,allMT+Num) = 1;
                % 2.data矩阵构建
                data_Sta_Index = find(contains(PosNameSegList,PostionNameLable)==1);
                data(row,:) = MPList(CampNum).MP((data_Sta_Index-1)*3+1:data_Sta_Index*3);
                row = row + 1;
            end
        end
    end
    
    H(end,allMT+1:end) =ones(1,length(pdata));
    
    
    para = inv(H'*H)*H'*data;
    
    calc = H * para;
    calc = calc(1:end-1,:);
    obsd = data(1:end-1,:);
    depth = mean(obsd(:,3));
    base = obsd/abs(depth);
    
    oc = obsd-calc;
    
    erms = sqrt(sum(oc(:,1).^2)/length(oc(:,1)));
    nrms = sqrt(sum(oc(:,2).^2)/length(oc(:,2)));
    urms = sqrt(sum(oc(:,3).^2)/length(oc(:,3)));
    
    rmcri = 4;
    rl = length(DeletList);
    AllNum = 1;LocalNum = 1;
    DelList=[];
    for j = 1:ncamp
        if ismember(j,DeletList)
            continue;
        end
        for k = 1:ndata(pdata(LocalNum))
            if abs(oc(AllNum,1))>rmcri*erms||abs(oc(AllNum,2))>rmcri*nrms||abs(oc(AllNum,3))>rmcri*urms
                DelList = [DelList,LocalNum];
                DeletList =[DeletList,j];
            end
            AllNum = AllNum + 1;
        end
        LocalNum = LocalNum +1;
    end
    DeletList = unique(DeletList);
    pdata(unique(DelList))=[];
    if rl-length(unique(DeletList))==0
        break;
    end
end

% 文件
ConfPath = [StnPath,'\initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

for DataNum = 1: FileStruct.FileNum
    INIReadFilePath = FileStruct.SubFileList{4,DataNum};
    INIWriteFilePath = strrep(INIReadFilePath,'initcfg','fix');
    RWNSinex(INIReadFilePath,INIWriteFilePath,para,PostionNameList);
end





