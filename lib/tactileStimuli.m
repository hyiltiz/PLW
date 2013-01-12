function tactileStimuli(tTrack, dioOut)
  % the tactile stimuli with LPT1, using tactile device

  % here comes their footsteps
  % first channel-say left tactile, up to 8 channels (tactiles), binary coding
  % [1,2,4,8,16,32,64,128; up to 8 Channels of tactile, we could just used two, such
  % as channel 2 and channel 3, coding 2 and 4]
  switch tTrack
    case 0
      putvalue(dioOut,0); % clear zero
    case 1
      putvalue(dioOut, 2);% the left foot touches the ground.
    case 2
      putvalue(dioOut, 8);% the right foot touches the ground
    end
  end
