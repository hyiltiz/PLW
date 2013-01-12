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
