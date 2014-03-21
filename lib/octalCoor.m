function clockarm = octalCoor(wsize, r, n)
% return n arm coors of of clock within wsize
% r relate to the hvec of the screen; center:0 highest edge:1


angl=2*pi/n;
R=wsize(4)/2;

clockarm = [wsize(3)/2+r.*R.*cos(angl*[1:n])', wsize(4)/2+r.*R.*sin(angl*[1:n])'];

end
