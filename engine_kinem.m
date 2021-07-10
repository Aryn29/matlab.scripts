function [V]=engine_kinem(bore,stroke,con_rod,cr,start_crnk,end_crnk)

a=stroke/2;
R=con_rod/a;

v_s=(pi/4)*bore^2*stroke;
v_c=v_s/(cr-1);

tht=linspace(start_crnk,end_crnk,100); %tdc

term1=0.5*(cr-1);
term2=R+1-cosd(tht);
term3=(R^2-sind(tht).^2).^0.5;

V=(1+term1*(term2-term3)).*v_c;
end
