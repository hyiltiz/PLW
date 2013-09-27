dioIn=digitalio('parallel','LPT1'); % DAQ, open the LPT1 port
addline(dioIn,10:12,'in'); % for footswitch input.

dioOut=digitalio('parallel','LPT1');
addline(dioOut,0:7,'out'); % Write data
putvalue(dioOut,2); % clear zero:0; left foot:2; right foot:4

getvalue(dioIn);
switch  sum(getvalue(dioIn))
    case 1
        response=1; % right response
    case 2
        response=0;
    case 3
        response=2; % left response
end
disp(' ');
disp(' ');
disp(response);

for i=1:30
    if 0
pause(1);

putvalue(dioOut, 2);% the left back foot touches the ground.putvalue(dioOut,0); % clear zero
pause(0.3);
putvalue(dioOut,0); % clear zero

putvalue(dioOut, 8);% the right back foot touches the ground
pause(0.3);
putvalue(dioOut,0); % clear zero

putvalue(dioOut, 16);% the left front foot touches the ground.
pause(0.3);
putvalue(dioOut,0); % clear zero

putvalue(dioOut, 32);% the left front foot touches the ground.
pause(0.3);
putvalue(dioOut,0); % clear zero
    else
        pause(1);

putvalue(dioOut, 10);% the left back foot touches the ground.putvalue(dioOut,0); % clear zero
% putvalue(dioOut, 8);% the right back foot touches the ground
pause(0.3);
putvalue(dioOut,0); % clear zero

putvalue(dioOut, 48);% the left front foot touches the ground.
% putvalue(dioOut, 32);% the left front foot touches the ground.
pause(0.3);
putvalue(dioOut,0); % clear zero
    end
end

while true; pause(.1); sum(getvalue(dioIn)),end