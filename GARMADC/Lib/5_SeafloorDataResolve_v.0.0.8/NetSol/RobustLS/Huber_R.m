function r = Huber_R(J,q)
%% Huber Ȩ����
for i=1:length(r0)
    r(i) = (1 - J(i,i))^q;
end
