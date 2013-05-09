function [tex, dstRect] = addNoise(w, wsize, Track, noisescale, T)
% create the noise, using buffer

isSkip = 1;
if ~isSkip
    screens=Screen('Screens');
    screenNumber=max(screens);
    [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    % [w,wsize]=Screen('OpenWindow',screenNumber,0);
    noisescale = .15;
    Track = 1:261;
end

% rectSize = 4;
% objRect = SetRect(0,0, rectSize, rectSize);

t = .2;
r = .8;
% objRect = SetRect(t * wsize(3), t *  wsize(4), r * wsize(3), r * wsize(4));
objRect = SetRect(t * wsize(4), t *  wsize(4), r * wsize(4), r * wsize(4));
rectSize = round((objRect(3) - objRect(1))*noisescale);

dstRect = ArrangeRects(1, objRect, wsize);

[xc, yc] = RectCenter(dstRect);
% Create a new rectange, centered at the same position, but 'scale'
% times the size of our pixel noise matrix 'objRect':
% dstRect=CenterRectOnPoint(objRect * noisescale, xc, yc);
dstRect=CenterRectOnPoint(objRect, xc, yc);

% Enable alpha blending for smoothed points:
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

tex = zeros(1, length(Track));
for f = 1:T;
    %     tex(f)=Screen('MakeTexture',w, 127*randn(rectSize, rectSize) + 128);
    tex(f)=Screen('MakeTexture',w, 80*randn(rectSize, rectSize) + 128);
end

if ~isSkip
    for i=1:T  %loop leghth
        Screen('DrawTexture', w, tex(i), [], dstRect, [], 0);
        Screen('Flip', w);
    end
    sca;
end

end