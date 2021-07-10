% Goal through the race: maximizing Acceleration

%%bicycle parameters

M=70; %[kg]
It= 0.2; %[kgm^2]
Rt=0.4;%[m]

GR= [32/53, 20/53, 11/53]; %defining as R2/R1

thetap_dot_RPM = linspace(0,250,501)';%[RPM]
thetap_dot = thetap_dot_RPM*2*pi/60; %[rad/sec]

xdot_gear1= (Rt/GR(1))*thetap_dot; %bike speed[m/s]
xdot_gear2= (Rt/GR(2))*thetap_dot; %bike speed[m/s]
xdot_gear3= (Rt/GR(3))*thetap_dot; %bike speed[m/s]

xddot_gear1 = ((GR(1)/Rt)*(150-5.73*thetap_dot))/(M+2*It/Rt^2);
xddot_gear2 = ((GR(2)/Rt)*(150-5.73*thetap_dot))/(M+2*It/Rt^2);
xddot_gear3 = ((GR(3)/Rt)*(150-5.73*thetap_dot))/(M+2*It/Rt^2);

figure(1)
plot(thetap_dot_RPM,xddot_gear1,'r-',...
    thetap_dot_RPM,xddot_gear2,'b-',...
    thetap_dot_RPM,xddot_gear3,'g-','linewidth',2);grid on;
xlabel('pedaling rate[RPM]'),ylabel('bike acceleration[m/s^2]')
title('acceleration as a function of pedaling rate(all gears)')
legend('GR=32/53','GR=20/53','GR=11/53')

figure(2)
plot(xdot_gear1,xddot_gear1,'r-',...
    xdot_gear2,xddot_gear2,'b-',...
    xdot_gear3,xddot_gear3,'g-','linewidth',2);grid on;
xlabel('bike speed[m/s]'),ylabel('bike acceleration[m/s^2]')
title('acceleration as a function of bike speed(all gears)')
legend('GR=32/53','GR=20/53','GR=11/53')

%%simulating the race, using Euler Forward

dt=0.5; %sampling interval [s]
N=501;
t=(0:dt:(N-1)*dt);
x(1)=0;
xdot(1)=0; 
for k = 1:N-1 %[steps]
    
    if xdot(k)<10.66
        thetap_dot(k)= (1/Rt)*GR(1)*xdot(k);
        xddot(k)= ((GR(1)/Rt)*(150-5.73*thetap_dot(k)))/(M+2*It/Rt^2);
    elseif xdot(k)<17.76
        thetap_dot(k)= (1/Rt)*GR(2)*xdot(k);
        xddot(k)= ((GR(2)/Rt)*(150-5.73*thetap_dot(k)))/(M+2*It/Rt^2);
    else 
        thetap_dot(k)= (1/Rt)*GR(3)*xdot(k);
        xddot(k)= ((GR(3)/Rt)*(150-5.73*thetap_dot(k)))/(M+2*It/Rt^2);
    end
    
    xdot(k+1)=xdot(k)+xddot(k)*dt; %[step k+1 velocity=k velocity+(k accn*time step)]      
    x(k+1)=x(k)+xdot(k)*dt; %[step k+1 pos= k position+(k velocity*time step)]
end

figure(3)
plot(t,xdot,'linewidth',2), grid on 
xlabel('time[s]'), ylabel('velocity[m/s]')
