function rp = Koch_R(J,p)
%% Huber Ȩ����
n = size(J);
for i=1:n
    r(i) = (1 - J(i,i))^(p/2);
end
rd = mean(r);
rp = r/rd;