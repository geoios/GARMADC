function [value] = Read_Ini_File2(FilePath,key)
%首先判断配置文件是否存在
value = [] ;
if(exist(FilePath,'file') ~= 2)
    return;
end
%检查文件中有无key值，如果有则直接读取并返回，否则返回''
fid = fopen(FilePath);
LOOP=1;loop=0;
while ~feof(fid)
    tline = fgetl(fid);
    if ~ischar(tline) || isempty(tline)
        %跳过无效行
        continue;
    elseif  loop==length(key)
        break;
    end
    tmp=tline;
    tline(find(isspace(tline))) = []; %删除行中的空格
    for U=1:length(key)
        Index = strfind(tline, [key{U} '=']);
        if ~isempty(Index)
            loop=loop+1;
            break;
        end
    end
    j=0;
    if ~isempty(Index)
        %如果找到该配置项，则读取对应的value值
        ParamName = strsplit(tmp, {'=',' '});
        for i=1:size(ParamName,2)
            Index=strfind(ParamName{i}, key{U});
            if ~isempty(Index)
                j=i;
                break;
            end
        end
        for i=j+1:1:j+3
            value(LOOP)=str2num(ParamName{i});
            LOOP=LOOP+1;
        end
    end
end
fclose(fid); %关闭文件
end





