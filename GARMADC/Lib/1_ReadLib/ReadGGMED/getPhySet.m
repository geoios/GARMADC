function [Prof] = getPhySet(impoPhyPath)
%% ����˵��
%���ܣ���ȡ��������ݼ�
%% ���ܴ���
%��ȡ����
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

%% ��������
    function Prof = getPhyNcFile(impoDetaPhyPath)
        %info = ncinfo(impoDetaPhyPath);
        %��ȡ����
        lon = double(ncread(impoDetaPhyPath,'longitude'));%����
        lat = double(ncread(impoDetaPhyPath,'latitude'));%γ��
        depth = double(ncread(impoDetaPhyPath,'depth'));%���
        time = double(ncread(impoDetaPhyPath,'time'));%ʱ��
        Temp4D = ncread(impoDetaPhyPath,'thetao');%����
        Sal4D = ncread(impoDetaPhyPath,'so');%����

        %����SstList
        [n]=size(lon,1);%����
        [m]=size(lat,1);%γ��
        [q]=size(depth,1);%���
        [p]=size(time,1);%ʱ��
        %��ȡ
        count = 0;
        Prof.depth(:,1) = depth;
        for i = 1:n%����
            for j = 1:m%γ��
                if(isnan(double(Temp4D(i,j,1,1))))
                    continue%����½��
                end
                for g=1:p%ʱ��
                    count = count + 1;
                    Prof.pos(:,count) = [lon(i) lat(j) (1+(time(g)-438288-12)/24)]';%2000����������
                    for k=1:q%���
                        Prof.temp(k,count) = double(Temp4D(i,j,k,g));%�¶�
                        Prof.sal(k,count) = double(Sal4D(i,j,k,g));%�ζ�
                    end
                end
            end
        end
    end
end