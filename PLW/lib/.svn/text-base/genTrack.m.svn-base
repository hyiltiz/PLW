function [vTrack tTrack] = genTrack(Trialsequence, Track, lefttouch, righttouch, flpi, ntdurflp, nvterrflp )
% Generate visual stimuli track 'vTrack' and tactile stimuli track 'tTrack'

isSkip = 1;
if ~isSkip
ntdurflp = 2;
nvterrflp = 15;
end
vterr = flpi * nvterrflp; % visual-tactile incongruence error (s)
tdur = flpi * ntdurflp; % tactile stimuli duration time

vTrack = Track;  %visual track
tTrack = zeros(1, length(Track));  % no stimuli

switch Trialsequence
        case 1  % tactile before visual
                tTrack = adjustTrack(lefttouch, tTrack, 1, -nvterrflp, ntdurflp);  % left touch stimuli, 1
                tTrack = adjustTrack(righttouch, tTrack, 2, -nvterrflp, ntdurflp); % right touch stimuli, 2
                
        case 2  % tactile and visual, congruent
                tTrack = adjustTrack(lefttouch, tTrack, 1, 0, ntdurflp);  % left touch stimuli, 1
                tTrack = adjustTrack(righttouch, tTrack, 2, 0, ntdurflp); % right touch stimuli, 2
                
        case 3  % tactile after visual
                tTrack = adjustTrack(lefttouch, tTrack, 1, nvterrflp, ntdurflp);  % left touch stimuli, 1
                tTrack = adjustTrack(righttouch, tTrack, 2, nvterrflp, ntdurflp); % right touch stimuli, 2
                
        case 4  % baseline: no tactile
                % no stimuli
end

% random beginning of tactile stimuli
flpi = 0.02;
ini_mean = 3; % mean ini_time is 3s
ini_std = 0.5; % ini_time std is .5s
after_n_ini = ini_mean / flpi + Randi(2 * ini_std / flpi) - ini_std / flpi;
tTrack(1:after_n_ini) = 0;


        function xTrack = adjustTrack(xtouch, theTrack, type, thenvterrflp, thentdurflp)
                tmp = xtouch + thenvterrflp;
                xTrack = theTrack;
                for i = 1:thentdurflp
                        tmp(tmp <= 0) = 1; % does not begins before beginnig
                        tmp(tmp > length(theTrack)) = length(theTrack);  % and must end when it should
                        xTrack(tmp) = type;  % left touch stimuli
                        tmp = tmp + thentdurflp/abs(thentdurflp);
                end
        end
end
