function [svpCutHandTail] = cutSsp(souH,aimH,svp)
%% ����˵��
%���ܣ����²ü�ssp
%���룺+souPos Դ���꣨������
%      +aimPos Ŀ�����꣨������
%      +ssp �۲���������
%�����+output �ü�ssp
%% ���ܴ���
% ����������ʼλ��
if (souH >= svp(1,1)) 
    depthMark = find(svp(:,1) <= souH);
    extRange = [svp(depthMark(end),:);svp(depthMark(end)+1,:)];
    %���Բ�ֵ
    k = (extRange(2,2)-extRange(1,2))/(extRange(2,1)-extRange(1,1));
	souV = extRange(1,2) + k*(souH - extRange(1,1));
    svpCutHand = [souH souV;svp(depthMark(end)+1:end,:)];
else
    error('������λ�ô���');
end
% �ü�������ֹλ��
if (aimH == svpCutHand(end,1))%����
    svpCutHandTail = svpCutHand;
elseif (aimH < svpCutHand(end,1))%���� 
    depthMark2 = find(svpCutHand(:,1) >= aimH);
    extRange = [svpCutHand(depthMark2(1)-1,:);svpCutHand(depthMark2(1),:)];
    k = (extRange(2,2)-extRange(1,2))/(extRange(2,1)-extRange(1,1));
    aimV = extRange(1,2) + k*(aimH - extRange(1,1));
    svpCutHandTail = [svpCutHand(1:depthMark2(1)-1,:);aimH aimV];
else%����չ
	extRange = [svpCutHand(end-1,:);svpCutHand(end,:)];
	k = (extRange(2,2)-extRange(1,2))/(extRange(2,1)-extRange(1,1));
    aimV = extRange(1,2) + k*(aimH - extRange(1,1));
    svpCutHandTail = [svpCutHand;aimH aimV];
end

