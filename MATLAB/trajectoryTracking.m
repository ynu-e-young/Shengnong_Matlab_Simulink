clc;
clear;
close;

global H;
H=10;

t = (0:0.2:20)'; count = length(t);center = [80 0 0];radius = 10;%圆心和半径
theta = t*(2*pi/t(end));
points =(center + radius*[  zeros(size(theta)) cos(theta) sin(theta)])';

% hold on
q=ones(24,1);
bias=linspace(0,20,length(t));
targetPos=forwardKinematics(q,bias(1),1);
for i = 1:length(t)
%     i
    bx = points(1,i);
    by = points(2,i);
    bz =points(3,i);
%     tform = rpy2tr(0,0,0); %欧拉角转姿态齐次矩阵
    targetPos = [bx;by;bz]; %末端位置向量
    eulerAngle = [0;0;0];   %末端欧拉角
%     TR=transl(targetPos)*tform; %位姿齐次矩阵
%     grid on

   
    q=inverseKinematics([targetPos;eulerAngle],q,bias(i));
    plot3(points(1,:),points(2,:),points(3,:),'r')
    hold on
    axis([-25 80 -80 80 -80 80])

%     title("伪逆法实现逆运动学轨迹跟踪");
    xlabel('x/cm','FontSize',12);
    ylabel('y/cm','FontSize',12);
    zlabel('z/cm','FontSize',12);
    plot3(bx,by,bz,'*','LineWidth',1);
    drawRobot(q,bias(i));%动画演示
    axis([-25 80 -80 80 -80 80])

    drawnow;
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);
    if i == 1
        imwrite(I,map,'test.gif','gif', 'Loopcount',inf,'DelayTime',0.1);
    else
        imwrite(I,map,'test.gif','gif','WriteMode','append','DelayTime',0.1);
    end
end

