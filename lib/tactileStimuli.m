function tactileStimuli(tTrack, dioOut, is_mono)
  % the tactile stimuli with LPT1, using tactile device

  % here comes their footsteps
  % first channel-say left tactile, up to 8 channels (tactiles), binary coding
  % [1,2,4,8,16,32,64,128; up to 8 Channels of tactile, we could just used two, such
  % as channel 2 and channel 3, coding 2 and 4]
  %
is_mono = 0;
  if is_mono
    switch tTrack
      case 0
        putvalue(dioOut,0); % clear zero
      case 1
        putvalue(dioOut, 2+8);% the left back foot touches the ground.
%         putvalue(dioOut, 8);% the right back foot touches the ground
      case 2
        putvalue(dioOut, 16+32);% the left front foot touches the ground.
%         putvalue(dioOut, 32);% the left front foot touches the ground.
    end
  else
    switch tTrack
      case 0
        putvalue(dioOut,0); % clear zero
      case 1
        putvalue(dioOut, 2);% the left back foot touches the ground.
      case 2
        putvalue(dioOut, 8);% the right back foot touches the ground
      case 3
        putvalue(dioOut, 16);% the left front foot touches the ground.
      case 4
        putvalue(dioOut, 32);% the right front foot touches the ground.
    end
  end
end
