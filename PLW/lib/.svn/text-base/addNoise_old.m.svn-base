function addNoise(win, rectSize, wsize)

% Compute noiseimg noise image matrix with Matlab:
% Normally distributed noise with mean 128 and stddev. 50, each
% pixel computed independently:
noiseimg=(50*randn(rectSize, rectSize) + 128);

% Convert it to a texture 'tex':
tex=Screen('MakeTexture', win, noiseimg);

% Draw the texture into the screen location defined by the
% destination rectangle 'dstRect(i,:)'. If dstRect is bigger
% than our noise image 'noiseimg', PTB will automatically
% up-scale the noise image. We set the 'filterMode' flag for
% drawing of the noise image to zero: This way the bilinear
% filter gets disabled and replaced by standard nearest
% neighbour filtering. This is important to preserve the
% statistical independence of the noise pixels in the noise
% texture! The default bilinear filtering would introduce local
% correlations when scaling is applied:
Screen('DrawTexture', win, tex, [], wsize, [], 0);

% After drawing, we can discard the noise texture.
Screen('Close', tex);
end