function  test()
%isGreyMask = 0;
lagFlip = 3;
isSkip = 0;
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

[tex, dstRect] = addNoise(w, wsize, Track, noisescale, T, isGreyMask, lagFlip);
sca
end