function x0s = Extraction_x0(GlobalPar)
% ��ȡ�����ֵ
X0Par = GlobalPar.Model_parameter.MT_Pos;


StrName = fieldnames(X0Par);
CellNum = size(StrName,1);
X0Inf = struct2cell(X0Par);

%%
x0s=[];
%%%%
Loop = 0;
for i = 1:CellNum
    iCell = StrName(i);
    if contains(iCell,'M')
        Loop = Loop + 1;
%         x0s(Loop,:) = X0Inf{i}(1:3);
        x0s= [x0s;X0Inf{i}(1:3)];
    end
end

end