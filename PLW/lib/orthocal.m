function [coef1, coef2]=orthocal(theta, x1,y1,z1,framenum,jointsnum)
%%   Ortho projection
theta = theta*pi/180;
% theta= -pi/6;%(90+120)*pi/180;                   %theta is called the azimuth angle.
phi= pi/2;%-20*pi/180;                 %phi is the complement of the angle of elevation.

a=cos(theta)*sin(phi);
b=sin(theta)*sin(phi);
c=cos(phi);                     %(a,b,c) gives the direction from the origin to the eye.
for index=1:framenum
        for i=1:jointsnum
                %Orthographic projection routine starts here.
                distance(index,i)= x1(index,i)*a+y1(index,i)*b+z1(index,i)*c;  %This scalar projection plays the role of a distance.
                coef1(index,i)=(-sin(theta)*x1(index,i)+cos(theta)*y1(index,i));
                coef2(index,i)=(-cos(theta)*cos(phi)*x1(index,i)-sin(theta)*cos(phi)*y1(index,i)+sin(phi)*z1(index,i));
        end;
end;

