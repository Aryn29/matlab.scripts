%% Vehicle Simulation using bicycle model in a steady state
clear
close all
clc

%% Passenger car parameters
m=1500;             %[kg]
Iz=2873;            %[kg*m^2]
L=2.68;             %[m]
WF=0.59;            %[ratio %]
Lr=WF*L;            %[dist from CG to rear axle]
Lf=L-Lr;            %[dist from CG to front axle]
Cf=80000;           %[N/rad(Combined FRONT)]
Cr=Cf;              %[N/rad(Combined REAR)]
Rt=0.26;            %[m (tyre radius)]

Vkmph=80;           %[constant velocity in kmph]
V=Vkmph*0.277778;   %[constant velocity in m/s]


Ybeta= -(Cr+Cf);    %[damping in sideslip derivative]
Yr=(Cr*Lr-Cf*Lf)/V; %[yaw coupling derivative]
Ydelta=Cf;          %[control force derivative]
Nbeta=Cr*Lr-Cf*Lf;  %[directional stability derivative]
Nr=-(Cf*Lf^2+Cr*Lr^2)/V; %[yaw damping derivative]
Ndelta=Cf*Lr;       %[control moment derivative]

%% State Space form---
A=[Ybeta/(m*V), Yr/(m*V)-1;...
    Nbeta/Iz, Nr/Iz];
B=[Ydelta/(m*V);...
    Ndelta/Iz]; 

beta0=0;            %initial side slip angle
r0=0;               %initial yaw rate

states(:,1)=[beta0,r0];

dt=0.01;
t=(0:dt:10)';
N=length(t);
T=10;
omega=2*(2*pi/T);
delta=10*pi/180*sin(omega*t);
dstates(:,1)=A*states(:,1)+B*delta(1);

for k=1:N-1
    
    dstates(:,k)=A*states(:,k)+B*delta(k);
    states(:,k+1)=states(:,k)+dstates(:,k)*dt;
    
end

beta=states(1,:);
r=states(2,:);

figure(1)
plot(t,beta,'linewidth',2),grid on
xlabel('Time [s]'),ylabel('Beta [rad]')
title('Steering Input-Side Slip angle Vs Time')

%% Predicting heading angle and (x,y) positions given beta and r
psi(1)=0;
x(1)=0;
y(1)=0;
for k=1:N-1
    psi(k+1)= psi(k)+r(k)*dt; 
    
    Vx(k)=V*cos(psi(k)+beta(k));
    Vy(k)=V*sin(psi(k)+beta(k));
    
    x(k+1)=x(k)+Vx(k)*dt;
    y(k+1)=y(k)+Vy(k)*dt;
end

figure(2)
plot(y,x,'linewi',2),grid on
xlabel('Y-Position [m]'),ylabel('X-Position [m]')
title('Charted Path')
axis equal

%% Animating Vehicle as a function of time
xF = x + Lf*cos(psi);
yF = y + Lf*sin(psi);
xR = x - Lr*cos(psi);
yR = y - Lr*sin(psi);

xF_F=xF+Rt*cos(psi+delta');           %x-pos front of front tyre
yF_F=yF+Rt*sin(psi+delta');           %y-pos front of front tyre
xF_R=xF-Rt*cos(psi+delta');           %x-pos rear of front tyre
yF_R=yF-Rt*sin(psi+delta');           %y-pos rear of front tyre

xR_F=xR+Rt*cos(psi);                  %x-pos front of rear tyre
yR_F=yR+Rt*sin(psi);                  %y-pos front of rear tyre
xR_R=xR-Rt*cos(psi);                  %x-pos rear of rear tyre
yR_R=yR-Rt*sin(psi);                  %y-pos rear of rear tyre

skip=2;

for k=1:skip:N
    figure(3)
    plot(y(1:k),x(1:k),'c-','linewi',2);grid on; hold on; 
    plot([yF_R(k) yF_F(k)],[xF_R(k) xF_F(k)],'r-','linewidth',6);
    plot([yR_R(k) yR_F(k)],[xR_R(k) xR_F(k)],'r-','linewidth',6);
    plot(y(k),x(k),'ko','markersize',6,'linewidth',4);
    plot([yR(k) yF(k)],[xR(k) xF(k)],'k-','linewidth',4);hold off;
    axis equal
    title('Vehicle Simulation')
    xlabel('Y-Position')
    ylabel('X-Position')
    %axis limits:([LEFT RIGHT BOTTOM TOP])
    axis([y(k)-Lf*9 y(k)+Lf*9 x(k)-Lf*9 x(k)+Lf*9]) 
    drawnow
    
end
%% Script End
