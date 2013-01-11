function [dioIn dioOut] = loadDigitalIO()
% load DAQ LPT1 port

dioIn=digitalio('parallel','LPT1'); % DAQ, open the LPT1 port
dioOut=digitalio('parallel','LPT1');
addline(dioOut,0:7,'out'); % Write data
addline(dioIn,10:12,'in'); % for footswitch input.
putvalue(dioOut,0); % clear zero
end