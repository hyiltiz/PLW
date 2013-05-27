function [vTrack tTrack] = genTrack(Trialsequence, Track, lefttouch, righttouch, flpi, ntdurflp, nvterrflp, doubleTactileDiff )
  % Generate visual stimuli track 'vTrack' and tactile stimuli track 'tTrack'

  isSkip = 0;
  if ~isSkip
    doubleTactileDiff = 10;
    ntdurflp = 2;
    nvterrflp = 15;
  end
  vterr = flpi * nvterrflp; % visual-tactile incongruence error (s)
  tdur = flpi * ntdurflp; % tactile stimuli duration time

  vTrack = Track;  %visual track
  tTrack = zeros(1, length(Track));  % no stimuli

  sideinfo.side = 1;
  sideinfo.sidename = {'lefttouch'};
  sideinfo.side(2)=2;
  sideinfo.sidename(2) = {'righttouch'};

  WhichsideinfoSide=1;%this is left
  WhichShiftSide=2;
  % the first stimuli is shifted, and the latter is sideinfo
  if righttouch(1) > lefttouch(1) WhichShiftSide=1;WhichsideinfoSide=2; end; %and this is right

  switch Trialsequence
    case 1  % tactile before visual
      nvterrflpcoeff=-1;

    case 2  % tactile and visual, congruent
      nvterrflpcoeff=0;

    case 3  % tactile after visual
      nvterrflpcoeff=1;

    case 4  % baseline: no tactile
      nvterrflpcoeff=2; %this is NO tactile
      % no stimuli
    end

    if nvterrflpcoeff==2
      % no stinuli
    else
      % 3 types of stimuli corresponding to 3 different flagged nvterrflpcoeff
      %sideinfo side has no tactile stimuli shift
      tTrack = adjustTrack(eval(sideinfo.sidename{WhichsideinfoSide}), tTrack, sideinfo.side(WhichsideinfoSide), 0*nvterrflp, ntdurflp);
      %the other side with corresponding shifts
      tTrack = adjustTrack(eval(sideinfo.sidename{WhichShiftSide}), tTrack, sideinfo.side(WhichShiftSide), nvterrflpcoeff*nvterrflp, ntdurflp);
    end

    % tactile stimuli should be double rather than single
    % resembling back then front of foot touching ground
    if doubleTactileDiff == 0
      % do nothing, no double tactile
    else
      tTrack(find(tTrack==1) + doubleTactileDiff) = 3; % left front
      tTrack(find(tTrack==2) + doubleTactileDiff) = 4; % right front
      tTrack(length(Track)+1:end) = [];
    end


    % random beginning of tactile stimuli
    flpi = 0.02;
    ini_mean = 3; % mean ini_time is 3s
    ini_std = 0.5; % ini_time std is .5s
    after_n_ini = ini_mean / flpi + Randi(2 * ini_std / flpi) - ini_std / flpi;
    tTrack(1:after_n_ini) = 0;  % erease the useless beginning


  function xTrack = adjustTrack(xtouch, theTrack, type, thenvterrflp, thentdurflp)
    tmp = xtouch + thenvterrflp;  %the stimuli instances, move the touchground baseline
    xTrack = theTrack;
    %         for i = 1:thentdurflp  % tmp is changing in every loop

    if isempty(find(tmp <= 0))
      %good
    else
      tmp = [tmp; tmp(tmp <= 0 ) + length(theTrack)];
      tmp(tmp <= 0 ) = []; % does not begins before beginnig
      %             tmp(tmp < 0) = 1; % does not begins before beginnig
    end
    if isempty(find(tmp > length(theTrack) ))
      %good
    else
      tmp = [tmp(tmp > length(theTrack)) - length(theTrack); tmp];  % and must end when it should
      tmp(tmp > length(theTrack)) = [];
      %             tmp(tmp > length(theTrack)) = length(theTrack);  % and must end when it should
    end
    xTrack(tmp) = type;  % left touch stimuli
    tmp = tmp + thentdurflp/abs(thentdurflp);
    %         end
  end
end
