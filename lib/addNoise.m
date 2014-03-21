function [tex, dstRect] = addNoise(w, wsize, Track, noisescale, T, isGreyMask, lagFlip, kill_dot)
  % create the noise, using buffer

  %isGreyMask = 0;
  %lagFlip = 3
  isSkip = 1;
  if ~isSkip
    screens=Screen('Screens');
    screenNumber=max(screens);
    [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    % [w,wsize]=Screen('OpenWindow',screenNumber,0);
    noisescale = .15;
    Track = 1:261;
    T=50;
    isGreyMask=0;
  end

  % rectSize = 4;
  % objRect = SetRect(0,0, rectSize, rectSize);

  % kill_dot=.1;
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



  colorCell={[255 0 0],[0 255 255]};

  coloredNoiseCell{1} = coloredNoiseMatrix(rectSize, rectSize,colorCell, .01);
  for f = 2:round(T/lagFlip);
      %recreate kill_dot percent of the dots per frame
      new_dots=rand(size(coloredNoiseCell{f-1},1),size(coloredNoiseCell{f-1},2))<kill_dot;
      tmp_colorspace=coloredNoiseMatrix(rectSize, rectSize,colorCell, .01);
      coloredNoiseCell{f} = coloredNoiseCell{f-1};
      coloredNoiseCell{f}(repmat(new_dots,[1 1 3]))=tmp_colorspace(repmat(new_dots,[1 1 3]));
  end

  colorLoop=lagloop(1:round(T/lagFlip), lagFlip);

  tex = zeros(1, length(Track));
  for f = 1:T;
    %     tex(f)=Screen('MakeTexture',w, 127*randn(rectSize, rectSize) + 128);
    if isGreyMask
      tex(f)=Screen('MakeTexture',w, 80*randn(rectSize, rectSize) + 128);
    else
      tex(f)=Screen('MakeTexture',w, coloredNoiseCell{colorLoop(f)});
    end
  end

  if ~isSkip
    for i=1:T  %loop leghth
      Screen('DrawTexture', w, tex(i), [], dstRect, [], 0);
      Screen('Flip', w);
    end
    sca;
  end

end
