clear
close all
clc

% inputs
t3=2300;
gamma=1.4;

% State variables
p1=101325;
t1=500;

% Engine geomertic parameters
bore=0.1;
stroke=0.1;
con_rod=0.15;
cr=5;

%swept vol and clearaance vol
v_swp=(pi/4)*bore^2*stroke;
v_clr=v_swp/(cr-1);

v1=v_swp+v_clr;
v2=v_clr;

%state variables at state point 2
%p2v2^gamma=p1v1^gamma
p2=p1*cr^gamma;
% p1v1/t1=p2v2/t2 | 
t2=p2*v2*t1/(p1*v1);
constant_c=p1*v1^gamma;
V_comp=engine_kinem(bore,stroke,con_rod,cr,180,0); % function call
P_comp=constant_c./V_comp.^gamma;


% state variables at state point 3
v3=v2;
% p3v3/t3=p2v2/t2 | p3=p2*t3/t2
p3=p2*t3/t2;
constant_c=p3*v3^gamma;
V_exp=engine_kinem(bore,stroke,con_rod,cr,0,180);
P_exp=constant_c./V_exp.^gamma;


% state variables at state point 4
v4=v1;
% p3v3^gamma=p4v4^gamma| p4=p3(v3/v4)^gamma
p4=p3* (v3/v4)^gamma;

% calculating Thermal Efficiency 
eta=(1-(cr^(gamma-1))^-1)*100; % [Percentage]

figure(1)
hold on
plot(V_comp,P_comp,'b')
plot(v1,p1,'r*')
plot(v2,p2,'r*')
plot(v3,p3,'r*')
plot(V_exp,P_exp,'b')
plot(v4,p4,'r*')
plot([v2 v3],[p2 p3],'b')
plot([v1 v4],[p1 p4],'b')
xlabel('Volume [m^3]')
ylabel('Pressure [KPa]')
title('Basic PV-Diagram for Otto Cycle')




