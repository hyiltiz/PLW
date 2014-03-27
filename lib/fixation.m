function fixation(w, cx, cy, color)
% display '+', as fixaton point

Screen('DrawLine', w, color, cx-10,cy,cx+10,cy,2);
Screen('DrawLine', w, color, cx,cy+10,cx,cy-10,2);
%   Screen('Flip', w);
end