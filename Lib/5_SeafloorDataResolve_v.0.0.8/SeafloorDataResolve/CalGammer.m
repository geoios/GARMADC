function [Gammer] = CalGammer(Time,TMP,MPNum,spdeg,knots,e,n,sta_e,sta_u)
Gammer=0;

for i=1:MPNum(2)-MPNum(1)
    Gammer=Gammer+TMP(MPNum(1)+i)*Bbase(i,spdeg,Time,knots{1});
end
if size(knots,1)>=3
    for i=1:MPNum(3)-MPNum(2)
        Gammer=Gammer+TMP(MPNum(2)+i)*(e/1000)*Bbase(i,spdeg,Time,knots{2});
    end
    for i=1:MPNum(4)-MPNum(3)
        Gammer=Gammer+TMP(MPNum(3)+i)*(n/1000)*Bbase(i,spdeg,Time,knotsP{3});
    end
end
if size(knots,1)>=5
    for i=1:MPNum(5)-MPNum(4)
        Gammer=Gammer+TMP(MPNum(4)+i)*(sta_e/1000)*Bbase(i,spdeg,Time,knots{4});
    end
    for i=1:MPNum(6)-MPNum(5)
        Gammer=Gammer+TMP(MPNum(5)+i)*(sta_u/1000)*Bbase(i,spdeg,Time,knots{5});
    end
end
end

