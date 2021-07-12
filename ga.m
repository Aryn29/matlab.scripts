%% Genetic Algorithm
%% 
clear
close all
clc

x=linspace(0,0.6,150);
y=linspace(0,0.6,150);
num_cases=50;

% Creating 2D mesh
[xx, yy]=meshgrid(x,y);

% Evaluating Stalgamite Function
for i=1:length(xx)
    for j= 1:length(yy)
        ip_vector(1)=xx(i,j);
        ip_vector(2)=yy(i,j);
        f(i,j)=stalagmite(ip_vector);
    end
end

surfc(xx,yy,f)

shading interp
[inputs, fval]=ga(@stalagmite,2);
xlabel('x-val')
ylabel('y-val')
zlabel('peak magnitude')

%% Study 1- Statistical Behaviour
tic
for i=1:num_cases
    [inputs,fopt(i)]=ga(@stalagmite,2); 
    xopt(i)=inputs(1);
    yopt(i)=inputs(2);
end
study1_time=toc;
figure(1)
subplot(2,1,1)
hold on
surfc(x,y,f)
shading interp
plot3(xopt,yopt,fopt,'marker','o','markersize',5,'markerfacecolor','r')
title('Study-1: Unbounded Inputs')
subplot(2,1,2)
plot(fopt)
xlabel('Iterations')
ylabel('Function Maximium')

%% Study 2- Statistical Behaviour with upper and lower bounds
tic
for i=1:num_cases
    [inputs,fopt(i)]=ga(@stalagmite,2,[],[],[],[],(0:0),(0.6:0.6));
    xopt(i)=inputs(1);
    yopt(i)=inputs(2);
end
study2_time=toc;
figure(2)
subplot(2,1,1)
hold on
surfc(x,y,f)
shading interp
plot3(xopt,yopt,fopt,'marker','o','markersize',5,'markerfacecolor','g')
title('Study-2: Unbounded Inputs')
subplot(2,1,2)
plot(fopt)
xlabel('Iterations')
ylabel('Function Maximium')

%% Study 3-  Increasing GA Iterations
options=optimoptions('ga');
options=optimoptions(options,'PopulationSize',170);
tic
for i=1:num_cases
    [inputs,fopt(i)]=ga(@stalagmite,2,[],[],[],[],(0:0),...
        (0.6:0.6),[],[],options);
    xopt(i)=inputs(1);
    yopt(i)=inputs(2);
end
study3_time=toc;
figure(3)
subplot(2,1,1)
hold on
surfc(x,y,f)
shading interp
plot3(xopt,yopt,fopt,'marker','o','markersize',5,'markerfacecolor','k')
title('Study-3: Bounded Inputs+ Modified Population size')
subplot(2,1,2)
plot(fopt)
xlabel('Iterations')
ylabel('Function Maximium')

% Visual change in study time
STtime=[study1_time,study2_time,study3_time];
studyserial=[1,2,3];

%% Stalagmite Function

function [P]=stalagmite (ip_vector)
    x=ip_vector(1);
    y=ip_vector(2);
    fx=(sin(5.1*pi*x+0.5))^6;
    fy=(sin(5.1*pi*y+0.5))^6;
    gx=exp((-4*log(2)*((x-0.0677)^2)/0.64));
    gy=exp((-4*log(2)*((y-0.0677)^2)/0.64));
    P=-1*(fx*fy*gx*gy);
end
