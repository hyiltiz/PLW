%% Copyright (C) 2012 Multisensory Lab of Peking University
%%
%% This program is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program; see the file COPYING.  If not, see
%% <http://www.gnu.org/licenses/>.

%% RL_PLW(scale1, english_on)

%% Author: Hormetjan Yiltiz  hyiltiz@gmail.com
%% Created: 2012-10-17

function RL_PLW()
%% this code to generate pointlight display using 3D coordinates file
%   Written by Lihan Chen, Ph.D, Department of Psychology, Peking University
%   Merged in onePLW, PLWtransform, PLWsound modification to optimaze code
%   by Hormetjan, Department of Psychology, Peking University,March 2012
%   Wrote all the functions in directory ./lib, Hormetjan, June 2012
%   Added multi-platform support for Windows and GNU/Linux, June 2012
%   Added compatibility compatibility between MATLAB and Octave, June 2012
%   Help on tactile support by Lihan Chen, June 2012
%   Added tactile support by Hormetjan, June 2012
%   Documented by Hormetjan, July 2012
%   Added accurate timing suppost by Hormetjan, Oct 2012
%   For the latest source code, please contact hyiltiz@gmail.com
%   For Documentation of the program, please read README.txt file that
%   comdes with the program, to have a better understanding of the way the
%   program was written.

addpath('./data', './lib', './resources');
data.visualfilename = '07_01.data3d.txt'; % visaul data resource file
data.instruct_filename = 'RL_instruction_en.txt'; % instructions text file

% time setting vatiables
conf.flpi               =  0.02;      % each frame is set to 20ms (the monitor's flip interval is 16.7ms)
conf.ntdurflp           =  2;         % tactile duration time: n * conf.flpi
conf.nvterrflp          =  15;        % visual-tactile error time: n * conf.flpi
conf.waitBetweenTrials  =  .8+rand*0.2;% wait black screen between Trials, random
conf.waitFixationScreen =  .8+rand*0.2;% '+' time randomized
conf.repetitions        =  20;          % repetition time of a condition
conf.scale1             =  20;         % PLW's visual scale, more the bigger

% state control variables
mode.regenerate_on = 1;  % mode.regenerate_on data for experiment, rather than using the saved one
mode.debug_on      = 1;  % do ont use full screen, and skip the synch test
mode.audio_on      = 0;  % set audio stimuli on
mode.english_on    = 1;  % use English for Instructions etc., 0 for Chinese

% randomized sample exp. conditions and trial sequences variables
% condition type:4; recording results in 5 culumns
if mode.debug_on
    conf.repetitions = 2;
end
[flow.Trialsequence Trials] = genTrial(conf.repetitions, 5);

% unified key definitions
render.kb = keyDefinition();

try
    % psychoaudio hardware setting.
    if mode.audio_on
        freq = 48000;
        pahandle = loadAutio(freq);
    end
    
    % tactile hardware setting
    try
        [render.dioIn, render.dioOut] = loadDigitalIO();
        mode.tacktile_on = 1;
    catch
        mode.tacktile_on = 0;  % 0 is no tactile device
    end
    
    %% Get Subject information
    Subinfo = getSubInfo();
    %% initialization
    HideCursor;
    ListenChar(2);
    if mode.debug_on
        Screen('Preference','SkipSyncTests', 3);
    else
        Screen('Preference','SkipSyncTests', 0);
    end
    Screen('Preference', 'ConserveVRAM', 8);
    InitializeMatlabOpenGL;
    
    if mode.regenerate_on
        % reading in bvh text files for raw data
        data.readData = PLWread(data.visualfilename);
        data.loopPeriod = 130;
        conf.imagex=250;  % image size
        
        % create the PLW data
        n = 8;
        theta(k, :) = 360 * rand(n, 1);       %walkers face direction
        readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default
        positionPLW = [cos(0: pi/4: 2*pi); sin(0: pi/4: 2*pi)];
        positionPLW = positionPLW(:, 1:n);
        
        readData.thet = 0;  %to rotate along the first axis
        [dotx  doty ] = PLWtransform(readData, scale1, imagex);
        
        dot = cell(n,1);
        for i = 1 : n
            readData.thet = theta(k, i);  %to rotate along the first axis
            [dot{i}.x dot{i}.y] = PLWtransform(readData, scale1, imagex);
            dot{i}.pace = Randi(3);
            dot{i}.pos = positionPLW(:, i)'/3;
        end
        
    end
    
    render.screens=Screen('screens');
    render.screenNumber=max(render.screens);
    
    if mode.debug_on
        [w,render.wsize]=Screen('OpenWindow',render.screenNumber,0,[1,1,801,601],[]);
    else
        [w,render.wsize]=Screen('OpenWindow',render.screenNumber,0,[],32);
    end
    
    render.ifi=Screen('GetFlipInterval', w);
    if render.ifi > conf.flpi
        error('Monitor Flip Interval is too large. Please use another computer.')
    end
    
    render.cx = render.wsize(3)/2; %center x
    render.cy = render.wsize(4)/2; %center y
    
    % Variables used across trials
    data.Track = 1:round(2 * length(data.dotx));        % 2 for less longer stimuli
    flow.flow.prestate = 0;
    flow.response = 0;
    Priority(MaxPriority(w));
    
    %% create the noise, using buffer, thus better than addNoise
    [tex, render.dstRect] = addNoise(w, render.wsize, data.Track);
    
    %% Instructions
    %     RL_Instruction(w, mode.debug_on, mode.english_on, render.kb);
    if ~mode.english_on
        data.instruct_filename = 'RL_instruction_zh.txt';
    end
    Instruction(data.instruct_filename, w, render.wsize, mode.debug_on, mode.english_on, render.kb)
    
    %% Here begins our trial
    for k = 1:length(flow.Trialsequence)
        flow.Trial = k;
        WaitSecs(conf.waitBetweenTrials);  % wait black screen between Trials, random
        
        if mode.regenerate_on
            data.initPosition = Randi(round(data.loopPeriod/4),[2 1]);
            data.paceRate = Randi(3,[2 1]);
            %   data.Track = 1:round(length(data.dotx));% 2 for accuracy, and data.loopPeriod for period
            [data.lefttouch data.righttouch] = touchground(data.dotx, data.initPosition(1), data.paceRate(1), data.Track);     %for the index when PLW touches ground
        else
            % do not generate, use the previously saved data(not enabled by default)
            load RL_PLW_data;
            %where we have two PLWs, and quicker pace than 3 maybe too quick
            data.paceRate = Randi(3,[2 1]);
            data.initPosition = Randi(round(data.loopPeriod/4),[2 1]);
        end
        data.moveDirection = round(rand([length(flow.Trialsequence), 2])); %walkers walking direction is random
        
        % Generate the mu ltisensory data.Track to synch on time
        [data.vTrack data.tTrack] = genTrack(flow.Trialsequence(flow.Trial), data.Track, data.lefttouch, data.righttouch, conf.flpi, conf.ntdurflp, conf.nvterrflp);
        
        % display:  +
        fixation(w, render.cx, render.cy);
        WaitSecs(conf.waitFixationScreen);  % '+' time randomized
        Screen('FillRect',w,0);
        render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control
        
        %Here comes the sound
        if mode.audio_on
            playSound(pahandle, freq, data.paceRate, data.moveDirection(flow.Trial, 1));
        end
        
        %% PLW that you can see on the screen
        flow.flow.isquit = 0;     % to capture ESCAPE for quitting
        flow.isresponse = 0;
        render.iniTimer=GetSecs;
        for i=data.Track  %loop leghth
            flow.Flip = i;
            % here comes the noise background
            % addNoise(w, 256, render.wsize);%Do not use this, since buffer tex is used
            Screen('DrawTexture', w, tex(flow.Flip), [], render.dstRect, [], 0);
            % and here comes the walkers
            for i = 1 : n
                ClockonePLW(w,dot{i}.pace*f, cx, cy, dot{i}.x , dot{i}.y ,dot{i}.pos, [0 1]);
            end
            % here comes their footsteps
            if mode.tacktile_on
                % save data/postbuggy;
                % disp('postbuggy');
                tactileStimuli(data.tTrack(flow.Flip), render.dioOut);
            end
            %% catch the response
            if ~mode.tacktile_on
                render.dioIn = false;
            end
            
            % get the response
            [Trials, flow.flow.prestate, flow.response, render.iniTimer, flow.flow.isquit, flow.isresponse ] = getResponse(mode.tacktile_on, render.iniTimer, render.dioIn, flow.flow.prestate, flow.response, flow.Trialsequence, flow.Trial, data.moveDirection, render.kb, flow.isresponse, flow.flow.isquit, Trials);
            if flow.isresponse; break; end
            
            % Flip the visual stimuli on the screen, along with timing
            render.vlb = Screen('Flip', w, render.vlb + conf.flpi);
            
        end
        % quit if the participant pressed ESC
        if flow.flow.isquit, break, end
        
        % end of per trial
        Screen('FillRect',w ,0);
        Screen('Flip', w);
        
        % Get the remaining last response
        [Trials, flow.flow.prestate, flow.response, render.iniTimer, flow.flow.isquit, flow.isresponse ]  = getlastResponse(mode.tacktile_on, render.iniTimer, render.dioIn, flow.flow.prestate, flow.response, flow.Trialsequence, flow.Trial, data.moveDirection, render.kb, flow.isresponse, flow.flow.isquit, Trials);
        
    end;
    
    % End of experiment
    save(['data/' Subinfo{1} '.mat'],'Trials');
    % Display 'Thanks' Screen
    RL_Regards(w, mode.english_on);
    
catch
    % save the buggy data for debugging
    save data/buggy;
    Screen('CloseAll');
    if mode.audio_on; PsychPortAudio('Close'); end
    Priority(0);
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
    
end

Screen('CloseAll');
if mode.audio_on; PsychPortAudio('Close'); end
Priority(0);
ShowCursor;
ListenChar(0);

% save data for testing for the last experiment
save data/test
disp('Experiment was successful!');
end
