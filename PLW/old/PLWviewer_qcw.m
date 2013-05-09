%% Copyright (C) 2012 Multisensory Lab of Peking University
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; see the file COPYING.  If not, see
% <http://www.gnu.org/licenses/>.

% RL_PLW(scale1, english_on)

% Author: Hormetjan Yiltiz  hyiltiz@gmail.com
% Created: 2011-12-17

function PLWviewer_qcw()
%PLWviewer DISPLAYS POITLIGHT WALKER ANIMATION
%   PLWviewer(filename, scale, imagex, mapping) does the trick.
%   filename: input data file
%   scale: animation noise scale
%   imagex: image size
%   mapping: display goup control

%   written by Hormetjan, Department of Psychology, Peking University
%% Make display
audio_on = 0;

if audio_on
    freq = 48000;
    latbias = (64 / freq); %hardware delay
    InitializePsychSound(1);
    
    % load two paths
    pahandle = PsychPortAudio('Open', [],[],2,freq);
    
    % Tell driver about hardwares inherent latency
    PsychPortAudio('LatencyBias', pahandle, latbias);
    PsychPortAudio('LatencyBias', pahandle);
end


load dotxy;
figure;
clear F;
count=0;
xrange = [min(min(dotx))-50, max(max(dotx))+50];
yrange = [min(min(doty))-80, max(max(doty))+80];
mapping = [0 1 1 1 2 2 2 1 1 1 2 2 2];
gcolor = {'black', 'blue', 'red'};


if audio_on
    % Read the audio data
    y = wavread('footsteps.wav');
    PsychPortAudio('FillBuffer', pahandle, y);
    PsychPortAudio('Start', pahandle, 1, 0, 0);
end

for f=1:5:size(dotx,1)% two for accuracy
    count=count+1;
    % signal parts
    for grouping = 0 : 2
        h = plot(dotx(f,mapping == grouping),...
            doty(f,mapping == grouping),'o');
        set(h,'MarkerSize',6);
        set(h,'MarkerFaceColor',gcolor{grouping + 1});
        set(h,'MarkerEdgeColor',gcolor{grouping + 1});
        hold on;
    end
    axis equal;
    axis([xrange(1) xrange(2) yrange(1) yrange(2)]);
    %     pause(0.02);
    F(count)=getframe;
    refresh;
    hold off;
end;
movie2avi(F,sprintf('PLW.avi'),'fps',20,'compression','None');
close;
if audio_on;PsychPortAudio('Close');end
end