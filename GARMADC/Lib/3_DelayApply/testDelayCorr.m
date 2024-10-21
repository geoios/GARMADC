function testDelayCorr(JpnSvpInfo,SvpInfo,ParGrid)
%% 函数说明
%功能：延迟改正测试
%% 功能代码
%参考值
angArry = [1 (5:5:60)]';
count = 0;
for iAng = angArry'
    count = count + 1;
    aimH = 1727.8;
    [travelTimeArray(count,1),~,zeniAng_tan(count,1),ro(count,1)] = getTravelTimePosi(0,-aimH,delGrosso(SvpInfo{1}(1).dtslInfo),iAng);
    %静态延迟
    souH = 0;
    zeniAng_tan = zeniAng_tan(count,1);
    intePos = SvpInfo{1}(1).pos';
    [delayOut_inte(count,:),kc_inte(count,1)] = compDelayCorr(intePos,souH,aimH,zeniAng_tan,ParGrid{1});
end
%距离改正效果
L_obs = travelTimeArray * (1402.392 + 46.691403254999995745 + 17.449376005599997548);%常数
ro_cc = L_obs./kc_inte;
ro_1level = (L_obs - sum(delayOut_inte(:,1:3),2))./kc_inte;
ro_1Add2level = (L_obs - sum(delayOut_inte,2))./kc_inte;

diff_cc = ro - ro_cc;
diff_1level = ro - ro_1level;
diff_1Add2level = ro - ro_1Add2level;
%绘图
    %剖面
    figure
    plotProf(JpnSvpInfo{1},'k-','A');hold on;
    for i = 1:12
        glorys12Ssp = delGrosso(SvpInfo{1}(i).dtslInfo);
        plotProf(glorys12Ssp,'r-','A');hold on;
    end
    %改正
    figure
    plotDistCorr([angArry diff_cc],'g.-');hold on;
    plotDistCorr([angArry diff_1level],'b.-');hold on;
    plotDistCorr([angArry diff_1Add2level],'r.-');
    legend('Cc','Cc + first correct','Cc + two correct');
    ylim([-1 16]);
