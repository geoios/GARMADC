function PF = RayPropertiesGrid(PF,theta,PFcol,MaxAngle)
%% RayTracing(PF,theta,T,Y,H)->Direct tracing problem
%�������ã����߸��ٺ��ĺ�����������ÿ�㴫��ʱ�䡢��ȡ�ˮƽλ��
%����ֵ
%�������桢����ǡ����Ƶ㡢ʵ��ʱ�䡢ˮƽλ�ơ�Ŀ�����ȣ���ֵ��
%���ֵ
%����ʱ��T��ˮƽλ��Y�����Z
SumHorizontal   = 0;
PropagationTime = 0;
H = PF(end,1);
m = size(PF,1);  %�õ�������������ݵ���
%% Ray tracing
cos_alfa0 = sin(theta);     % cos(G_theta);          %�������������
PF(1,PFcol) = cos_alfa0;
V = [inf,inf,inf];
for i = 1 : m-1
    c0 = PF(i,2); 
    z  = PF(i,3);  
    a  = PF(i,4);
    [t1,x1,z1,L1,cos_alfa0]  = SingleLayerTracing(cos_alfa0,c0,a,+inf,+inf,z);
    SumHorizontal            = SumHorizontal + x1;
    PropagationTime          = PropagationTime + t1;
%     PF(i+1,PFcol)            = SumHorizontal;
%     PF(i+1,PFcol+MaxAngle)   = PropagationTime; 
%     PF(i+1,PFcol+2*MaxAngle) = cos_alfa0; 
   
    PF(i+1,PFcol)            = cos_alfa0;
    PF(i+1,PFcol+MaxAngle)   = SumHorizontal;
    PF(i+1,PFcol+2*MaxAngle) = PropagationTime;
    
    
end
