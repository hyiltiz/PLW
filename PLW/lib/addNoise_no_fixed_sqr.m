function [tex, dstRect] = addNoise_no_fixed_sqr(w, wsize, Track, noisescale)
% create the noise, using buffer

rectSize = 256;
% noisescale = 9;
objRect = SetRect(0,0, rectSize, rectSize);
dstRect = ArrangeRects(1, objRect, wsize);

[xc, yc] = RectCenter(dstRect);
% Create a new rectange, centered at the same position, but 'scale'
% times the size of our pixel noise matrix 'objRect':
dstRect=CenterRectOnPoint(objRect * noisescale, xc, yc);

% Enable alpha blending for smoothed points:
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

tex = zeros(1, length(Track));
for f = Track;
    tex(f)=Screen(w, 'MakeTexture', 50*randn(rectSize, rectSize) + 128);
end
end