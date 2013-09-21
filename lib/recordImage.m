function  recordImage(nflip,interval,name,windowPtr,rect)

if mod(nflip,interval)
    % do not record
else
    % a picture pls!
    imageArray=Screen('GetImage', windowPtr, [rect]);
    mkdir('tmp');
    filename=['tmp\' name datestr(now,'yyyymmddTHHMMSS') '.jpeg'];
    disp([pwd '\' filename]);
    imwrite(imageArray,filename,'jpeg','Quality',100);
end
%  Screen('GetCapturedImage')

% Video capture functions:
% devices = Screen('VideoCaptureDevices' [, engineId]);
% videoPtr =Screen('OpenVideoCapture', windowPtr [, deviceIndex] [,roirectangle] [, pixeldepth] [, numbuffers] [, allowfallback] [, targetmoviename] [, recordingflags] [, captureEngineType]);
% Screen('CloseVideoCapture', capturePtr);
% [fps starttime] = Screen('StartVideoCapture', capturePtr [, captureRateFPS] [, dropframes=0] [, startAt]);
% droppedframes = Screen('StopVideoCapture', capturePtr [, discardFrames=1]);
% [ texturePtr [capturetimestamp] [droppedcount] [summed_intensityOrRawImageMatrix]]=Screen('GetCapturedImage', windowPtr, capturePtr [, waitForImage=1] [,oldTexture] [,specialmode] [,targetmemptr]);
% oldvalue = Screen('SetVideoCaptureParameter', capturePtr, 'parameterName' [, value]);


end
