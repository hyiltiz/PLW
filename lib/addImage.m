function [tex, dstRect] = addImage(w, wsize, cx, cy, xy0, imagePath, alpha)
  % load image, and convert to texture using buffer, then display
  % this function is based on addNoise
  %
  % [cx cy] is the center coordinate of this image file on w
  % xy0 is the x y end of the image

  isSkip = 0;
  if ~isSkip
    imagePath='resources/facestimuli/6neutral/female/NEF1.BMP';
    screens=Screen('Screens');
    screenNumber=max(screens);
    [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    % [w,wsize]=Screen('OpenWindow',screenNumber,0);
    cx=wsize(3)/2 - 100;
    cy=wsize(4)/2 - 100;
    xy0 = [wsize(3)/4 wsize(4)/4];
  end

  imraw = imread(imagePath);
  immasked = imageMask(imraw, 1, 0);% default is 1, 8

  % Enable alpha blending for smoothed points:
  Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  imtex = Screen('MakeTexture', w, immasked);

  % rectSize = 4;
  % objRect = SetRect(0,0, rectSize, rectSize);

  dstRect = [cx - round(xy0(1)/2), cy - round(xy0(2)/2), cx + round(xy0(1)/2), cy + round(xy0(2)/2)];



%   t = .2;
%   r = .8;
%   noisescale=0.5;
%   % objRect = SetRect(t * wsize(3), t *  wsize(4), r * wsize(3), r * wsize(4));
%   objRect = SetRect(t * wsize(4), t *  wsize(4), r * wsize(4), r * wsize(4));
%   rectSize = round((objRect(3) - objRect(1))*noisescale);
%
%   dstRect = ArrangeRects(1, objRect, wsize);
%
%   [xc, yc] = RectCenter(dstRect);
  % Create a new rectange, centered at the same position, but 'scale'
  % times the size of our pixel noise matrix 'objRect':
  % dstRect=CenterRectOnPoint(objRect * noisescale, xc, yc);
%  dstRect=CenterRectOnPoint(objRect, xc, yc);




  % colorCell={[255 0 0],[0 255 255]};
  %
  % coloredNoiseCell{1} = coloredNoiseMatrix(rectSize, rectSize,colorCell, .01);
  % for f = 2:round(T/lagFlip);
  %     %recreate kill_dot percent of the dots per frame
  %     new_dots=rand(size(coloredNoiseCell{f-1},1),size(coloredNoiseCell{f-1},2))<kill_dot;
  %     tmp_colorspace=coloredNoiseMatrix(rectSize, rectSize,colorCell, .01);
  %     coloredNoiseCell{f} = coloredNoiseCell{f-1};
  %     coloredNoiseCell{f}(repmat(new_dots,[1 1 3]))=tmp_colorspace(repmat(new_dots,[1 1 3]));
  % end

%  colorLoop=lagloop(1:round(T/lagFlip), lagFlip);
%
%  tex = zeros(1, length(Track));
%  for f = 1:T;
%    %     tex(f)=Screen('MakeTexture',w, 127*randn(rectSize, rectSize) + 128);
%    if isGreyMask
%      tex(f)=Screen('MakeTexture',w, 80*randn(rectSize, rectSize) + 128);
%    else
%      tex(f)=Screen('MakeTexture',w, coloredNoiseCell{colorLoop(f)});
%    end
%  end

  if ~isSkip
      Screen('DrawTexture', w, imtex, [], dstRect, [], 0);
      Screen('Flip', w);
      pause
      sca;
  end

end
