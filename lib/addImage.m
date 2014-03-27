function [imtex, dstRect] = addImage(w, wsize, cx, cy, xy0, imagePath, raster, alpha)
% load image, and convert to texture using buffer, then display
% this function is based on addNoise
%
% [cx cy] is the center coordinate of this image file on w
% xy0 is the x y end of the image
% alpha is [0,1]

isSkip = 1;
if ~isSkip
    imagePath='resources/facestimuli/6neutral/female/NEF1.BMP';
    screens=Screen('Screens');
    screenNumber=max(screens);
    [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    % [w,wsize]=Screen('OpenWindow',screenNumber,0);
    cx=wsize(3)/2 - 100;
    cy=wsize(4)/2 - 100;
    xy0 = [wsize(3)/4 wsize(4)/4];
    raster = [1, 8];
    alpha = 0.1;
end

imraw = imread(imagePath);
immasked = imageMask(imraw, raster(1), raster(2));% default is 1, 8

% alpha transparency: [0-1] -> [0,255]
alpha = round(255*alpha);
Aplane = ones(size(immasked,1),size(immasked,2)).*alpha;
immasked = cat(3, immasked, Aplane);

% Enable alpha blending for smoothed points:
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

imtex = Screen('MakeTexture', w, immasked);
%  Display(imtex);

dstRect = [cx - round(xy0(1)/2), cy - round(xy0(2)/2), cx + round(xy0(1)/2), cy + round(xy0(2)/2)];

if ~isSkip
    Screen('DrawTexture', w, imtex, [], dstRect, [], 0);
    Screen('Flip', w);
    pause
    sca;
end
end
