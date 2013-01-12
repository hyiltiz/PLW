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

static.side = 1;
static.sidename = {'lefttouch'};
static.side(2)=2;
static.sidename(2) = {'righttouch'};

WhichStaticSide=1;%this is left
WhichShiftSide=2;
% the first stimuli is shifted, and the latter is static
if righttouch(1) > lefttouch(1) WhichShiftSide=1;WhichStaticSide=2; end; %and this is right

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
    % 3 types of stunuli corresponding to 3 different flagged nvterrflpcoeff
    %static side has no tactile stimuli shift
    tTrack = adjustTrack(eval(static.sidename{WhichStaticSide}), tTrack, static.side(WhichStaticSide), 0*nvterrflp, ntdurflp);
    %the other side with corresponding shifts
    tTrack = adjustTrack(eval(static.sidename{WhichShiftSide}), tTrack, static.side(WhichShiftSide), nvterrflpcoeff*nvterrflp, ntdurflp);
end

% switch Trialsequence
%     case 1  % tactile before visual
%         tTrack = adjustTrack(lefttouch, tTrack, 1, -nvterrflp, ntdurflp);  % left touch stimuli, 1
%         tTrack = adjustTrack(righttouch, tTrack, 2, -nvterrflp, ntdurflp); % right touch stimuli, 2
%         
%     case 2  % tactile and visual, congruent
%         tTrack = adjustTrack(lefttouch, tTrack, 1, 0, ntdurflp);  % left touch stimuli, 1
%         tTrack = adjustTrack(righttouch, tTrack, 2, 0, ntdurflp); % right touch stimuli, 2
%         
%     case 3  % tactile after visual
%         tTrack = adjustTrack(lefttouch, tTrack, 1, nvterrflp, ntdurflp);  % left touch stimuli, 1
%         tTrack = adjustTrack(righttouch, tTrack, 2, nvterrflp, ntdurflp); % right touch stimuli, 2
%         
%     case 4  % baseline: no tactile
%         % no stimuli
% end
% disp('+++++++++++++++++++++++++length of tTrack:++++++++++++++++');
% disp(length(vTrack));
% disp(length(tTrack));
% disp(length(Track));
%
% disp('+++++++++++++++++++++++++length of tTrack:++++++++++++++++');

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
        if isempty(find(tmp < 0))
            %good
        else
            tmp = [tmp; tmp(tmp < 0 ) + length(theTrack)];
            tmp(tmp < 0 ) = []; % does not begins before beginnig
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
