close all
clc

%Inputs
l1=1;
l2=0.5;

tht1=linspace(0,90,15);
tht2=linspace(0,90,15);
ct=1;
for i=1:length(tht1)
    THT1=tht1(i);
    for j=1:length(tht2)
        THT2=tht2(j);
        x0=0;
        y0=0;

        x1=l1*cosd(THT1);
        y1=l1*sind(THT1);

        x2=x1+l2*cosd(THT2);
        y2=y1+l2*sind(THT2);

        %Plotting
        
        plot([x0 x1],[y0 y1],[x1 x2],[y1 y2],'Linewi',3)
        pause(0.01)
        axis([0 2 0 2])
        axis equal
        M(ct)=getframe(gcf);
        ct=ct+1;
        
    end
end
movie(M)
videofile=VideoWriter('forward_kinem.avi','uncompressed AVI');
open(videofile)
writeVideo(videofile,M)
close(videofile)
