function [ParGrid] = makeParGrid_prod(SvpInfo)
%% ����˵��
%���ܣ�������������
%���룺+svpInfo
%�����+ParGrid
%% ���ܴ���
ParGrid(1,1).pos = SvpInfo.pos;
dtslInfo = SvpInfo.dtslInfo;
count = 1;
for iFloor = 1:size(dtslInfo,1)-1%������
    count = count + 1;
    ParGrid(iFloor,1).depthRange = [dtslInfo(1,1) dtslInfo(count,1)];
    [ParGrid(iFloor,1).ZjPar,ParGrid(iFloor,1).inciAngAndZeniAng_tan,ParGrid(iFloor,1).KjGrid,ParGrid(iFloor,1).DjGrid] = compParGrid_prod(dtslInfo,ParGrid(iFloor,1).depthRange);
end

%% ��������
function [ZjPar,inciAngAndZeniAng_tan,KjGrid,DjGrid] = compParGrid_prod(svpInfo,depthRange)
%%����˵��
%���ܣ������������
%%���ܴ���
count = 0;
for inciAng = 0:1:70
    count = count + 1;
    %һ����kj����
        % �������
        souH = depthRange(1);
        aimH = depthRange(2);
        sspTemp = cutSsp(souH,aimH,[svpInfo(:,1) svpInfo(:,2)]);%����
        sspSal = cutSsp(souH,aimH,[svpInfo(:,1) svpInfo(:,3)]);%����
        cutSvpInfo = [sspTemp sspSal(:,2) repmat(svpInfo(1,4),size(sspTemp,1),1)];
        % ����Cj
        [svp,Ct,Cs,Cp,Cc] = newDelGrosso(cutSvpInfo);%�ڲ�ת��Ϊdelta
        % ����Zj
        Sc = 1/Cc(1,2);
        ZjPar.Zt = Sc*trapz(Ct(:,1),Ct(:,2));
        ZjPar.Zs = Sc*trapz(Cs(:,1),Cs(:,2));
        ZjPar.Zp = Sc*trapz(Cp(:,1),Cp(:,2));
        ZjPar.Zc = Sc*trapz(Cc(:,1),Cc(:,2));
        % ����kj
        [sin_sita,zeniAng_tan] = getSinAngTraveTime_prod(svp,inciAng);
        cos_bata = sqrt(1-sin_sita(:,1).^2);
        lamuda = cos(atan(zeniAng_tan))*(1./cos_bata);
        inciAngAndZeniAng_tan(count,:) = [inciAng zeniAng_tan];
        KjGrid.kt(count,:) = Sc*trapz(Ct(:,1),lamuda.*Ct(:,2))/ZjPar.Zt;
        KjGrid.ks(count,:) = Sc*trapz(Cs(:,1),lamuda.*Cs(:,2))/ZjPar.Zs;
        KjGrid.kp(count,:) = Sc*trapz(Cp(:,1),lamuda.*Cp(:,2))/ZjPar.Zp;
        KjGrid.kc(count,:) = Sc*trapz(Cc(:,1),lamuda.*Cc(:,2))/ZjPar.Zc;

    %������Kj����
        ZjPar.Ztt = Sc.^2*trapz(Ct(:,1),Ct(:,2).*Ct(:,2));
        ZjPar.Ztp = Sc.^2*trapz(Ct(:,1),2*Ct(:,2).*Cp(:,2));
        ZjPar.Zpp = Sc.^2*trapz(Ct(:,1),Cp(:,2).*Cp(:,2));
        KjGrid.ktt(count,:) = Sc.^2*trapz(Ct(:,1),lamuda.*Ct(:,2).*Ct(:,2))/ZjPar.Ztt;
        KjGrid.ktp(count,:) = Sc.^2*trapz(Cs(:,1),2*lamuda.*Ct(:,2).*Cp(:,2))/ZjPar.Ztp;
        KjGrid.kpp(count,:) = Sc.^2*trapz(Cp(:,1),lamuda.*Cp(:,2).*Cp(:,2))/ZjPar.Zpp;
        
    %�ӳ���
        [distDelay(count,:),kc(count,:)] = compDelayGrid_prod(zeniAng_tan,ZjPar,count,KjGrid);
        DjGrid.dt(count,:) = [distDelay(count,1)];
        DjGrid.ds(count,:) = [distDelay(count,2)];
        DjGrid.dp(count,:) = [distDelay(count,3)];
        DjGrid.tt(count,:) = [distDelay(count,4)];
        DjGrid.tp(count,:) = [distDelay(count,5)];
        DjGrid.pp(count,:) = [distDelay(count,6)];
end

%% ��������
function [distDelay,kc] = compDelayGrid_prod(zeniAng_tan,ZjPar,count,KjGrid)
%%����˵��
%���ܣ���������ӳ�(ͬ��Ȳ㣬��zeniAng_tan�й�)
%%���ܴ���
zeniAng = atan(zeniAng_tan);
%kj
    kt = KjGrid.kt(count,:);
    ks = KjGrid.ks(count,:);
    kp = KjGrid.kp(count,:);
    kc = KjGrid.kc(count,:);
    ktt = KjGrid.ktt(count,:);
    ktp = KjGrid.ktp(count,:);
    kpp = KjGrid.kpp(count,:);
%����һ���ӳ�
    %����mj
    mt = cos(zeniAng)^-1 * kt;
    ms = cos(zeniAng)^-1 * ks;
    mp = cos(zeniAng)^-1 * kp;
    % ����Dj
    Dt = mt*ZjPar.Zt;
    Ds = ms*ZjPar.Zs;
    Dp = mp*ZjPar.Zp;
    %�ӳ�
    %delay1 = Dt + Ds + Dp;
%��������ӳ�
    %����mj
    mtt = cos(zeniAng)^-1 * ktt;
    mtp = cos(zeniAng)^-1 * ktp;
    mpp = cos(zeniAng)^-1 * kpp;
    %����Dj
    Dtt = mtt*ZjPar.Ztt;
    Dtp = mtp*ZjPar.Ztp;
    Dpp = mpp*ZjPar.Zpp;
    %�ӳ�
    %delay2 = Dtt + Dtp +Dpp;
%�ӳ���
distDelay = [Dt Ds Dp Dtt Dtp Dpp];