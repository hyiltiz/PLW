function [y] = playSound(pahandle, freq, paceRate, moveDirection)
  %Here comes the sound prepared (it is congruent for now)

  % freq = 48000 * paceRate(1);  %adjusting here is inadequate!
  latbias = (64 / freq); %hardware delay
  % Tell driver about hardwares inherent latency
  PsychPortAudio('LatencyBias', pahandle, latbias);

  % Read the audio data
  y = wavread('footsteps.wav');
  y = PLWsound(y, moveDirection, paceRate(1));  %make transformation for sound
  PsychPortAudio('FillBuffer', pahandle, y);
  PsychPortAudio('Start', pahandle, 1, 0, 0);

end
