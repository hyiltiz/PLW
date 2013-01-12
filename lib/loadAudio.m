function [pahandle] = loadAudio(freq)
  % psychoaudio hardware setting.

  % freq = 48000;
  latbias = (64 / freq); %hardware delay
  InitializePsychSound(1);

  % load two paths
  pahandle = PsychPortAudio('Open', [],[],2,freq);

  % Tell driver about hardwares inherent latency
  PsychPortAudio('LatencyBias', pahandle, latbias);
  PsychPortAudio('LatencyBias', pahandle);

end
