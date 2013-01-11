function xTrack = adjustTrack(xtouch, theTrack, type, thenvterrflp, thentdurflp)
tmp = xtouch + thenvterrflp;
for i = 1:thentdurflp
    tmp(tmp <= 0) = 1; % does not begins before beginnig
    tmp(tmp > length(theTrack)) = length(theTrack);  % and must end when it should
    xTrack(tmp) = type;  % left touch stimuli
    tmp = tmp + thentdurflp/abs(thentdurflp);
end
end