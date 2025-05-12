function [Prof] = getPhySet(impoPhyPath)
%% 函数说明
%功能：获取哥白尼数据集
%% 功能代码
%读取格网
FileInfo = dir(fullfile(impoPhyPath,'*.nc'));
for iFile = 1:size(FileInfo,1)
    impDataPath = [FileInfo(iFile).folder '\' FileInfo(iFile).name];
    [ProfTempo] = getPhyNcFile(impDataPath);
    if(iFile == 1)
        Prof = ProfTempo;
    else
        Prof.depth = Prof.depth;
        Prof.pos = [Prof.pos ProfTempo.pos];
        Prof.temp = [Prof.temp ProfTempo.temp];
        Prof.sal = [Prof.sal ProfTempo.sal];
    end
end

%% 辅助函数
    function Prof = getPhyNcFile(impoDetaPhyPath)
        %info = ncinfo(impoDetaPhyPath);
        %读取变量
        lon = double(ncread(impoDetaPhyPath,'longitude'));%经度
        lat = double(ncread(impoDetaPhyPath,'latitude'));%纬度
        depth = double(ncread(impoDetaPhyPath,'depth'));%深度
        time = double(ncread(impoDetaPhyPath,'time'));%时间
        Temp4D = ncread(impoDetaPhyPath,'thetao');%温盐
        Sal4D = ncread(impoDetaPhyPath,'so');%温盐

        %计算SstList
        [n]=size(lon,1);%经度
        [m]=size(lat,1);%纬度
        [q]=size(depth,1);%深度
        [p]=size(time,1);%时间
        %获取
        count = 0;
        Prof.depth(:,1) = depth;
        for i = 1:n%经度
            for j = 1:m%纬度
                if(isnan(double(Temp4D(i,j,1,1))))
                    continue%跳过陆地
                end
                for g=1:p%时间
                    count = count + 1;
                    Prof.pos(:,count) = [lon(i) lat(j) (1+(time(g)-438288-12)/24)]';%2000年起儒略天
                    for k=1:q%深度
                        Prof.temp(k,count) = double(Temp4D(i,j,k,g));%温度
                        Prof.sal(k,count) = double(Sal4D(i,j,k,g));%盐度
                    end
                end
            end
        end
    end
end