function RL_PLW(scale1, english_on)
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

addpath('./data', './lib', './resources');
filename = '07_01.data3d.txt';% input data file
if nargin < 2
    scale1 = 20;
    english_on = 1; % instruction language, use 0 for Chinese.
end

% time setting vatiables
flpi               =  0.02;      % each frame is set to 20ms (the monitor's flip interval is 16.7ms)
ntdurflp           =  2;         % tactile duration time: n * flpi
nvterrflp          =  15;        % visual-tactile error time: n * flpi
waitBetweenTrials  = .8+rand*0.2;% wait black screen between Trials, random
waitFixationScreen = .8+rand*0.2;% '+' time randomized

% state control variables
regenerate = 1;  % regenerate data for experiment, rather than using the saved one
debug_mode = 0;  % do ont use full screen, and skip the synch test
audio_on   = 0;  % set audio stimuli on

% randomized sample exp. conditions and trial sequences variables
% condition type:4; recording results in 5 culumns
repetitions = 5;
if debug_mode
    repetitions = 2;
end
[Trialsequence Trials] = genTrial(repetitions, 5);

% unified key definitions
kb = keyDefinition();

try
    % psychoaudio hardware setting.
    if audio_on
        freq = 48000;
        pahandle = loadAutio(freq);
    end
    
    % tactile hardware setting
    try
        [dioIn, dioOut] = loadDigitalIO();
        tactile_on = 1;
    catch
        tactile_on = 0;  % 0 is no tactile device
    end
    
    %% Get Subject information
    Subinfo = getSubInfo();
    %% initialization
    HideCursor;
    ListenChar(2);
    if debug_mode
        Screen('Preference','SkipSyncTests', 3);
    else
        Screen('Preference','SkipSyncTests', 0);
    end
    Screen('Preference', 'ConserveVRAM', 8);
    InitializeMatlabOpenGL;
    
    if regenerate
        % reading in bvh text files for raw data
        readData = PLWread(filename);
        imagex=250;  % image size
        T = 130;
        
        % Generate the data for plotting Point Light Walkers
        readData.thet = 0;  %to rotate along the first axis
        readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default
        [dotx  doty ] = PLWtransform(readData, scale1, imagex);
        
        readData.xyzseq = [1 3 2];  %to rotate across xyz
        readData.thet = 180;  %to rotate along the first axis
        [dotx1 doty1] = PLWtransform(readData, scale1, imagex);
    end
    
    
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    if debug_mode
        [w,wsize]=Screen('OpenWindow',screenNumber,0,[1,1,801,601],[]);
    else
        [w,wsize]=Screen('OpenWindow',screenNumber,0,[],32);
    end
    
    ifi=Screen('GetFlipInterval', w);
    if ifi > flpi
        error('Monitor Flip Interval is too large. Please use another computer.')
    end
    
    cx = wsize(3)/2; %center x
    cy = wsize(4)/2; %center y
    
    % Variables used across trials
    Track = 1:round(2 * length(dotx));        % 2 for less longer stimuli
    prestate = 0;
    response = 0;
    Priority(MaxPriority(w));
    
    %% create the noise, using buffer, thus better than addNoise
    [tex, dstRect] = addNoise(w, wsize, Track);
    
    %% Instructions
    RL_Instruction(w, debug_mode, english_on, kb);
    
    %% Here begins our trial
    for k = 1:length(Trialsequence)
        WaitSecs(waitBetweenTrials);  % wait black screen between Trials, random
        
        if regenerate
            initPosition = Randi(round(T/4),[2 1]);
            paceRate = Randi(3,[2 1]);
            %   Track = 1:round(length(dotx));% 2 for accuracy, and T for period
            [lefttouch righttouch] = touchground(dotx, initPosition(1), paceRate(1), Track);     %for the index when PLW touches ground
        else
            % do not generate, use the previously saved data(not enabled by default)
            load RL_PLW_data;
            %where we have two PLWs, and quicker pace than 3 maybe too quick
            paceRate = Randi(3,[2 1]);
            initPosition = Randi(round(T/4),[2 1]);
        end
        moveDirection = round(rand([length(Trialsequence), 2])); %walkers walking direction is random
        
        % Generate the mu ltisensory track to synch on time
        [vTrack tTrack] = genTrack(Trialsequence(k), Track, lefttouch, righttouch, flpi, ntdurflp, nvterrflp);
        
        % display:  +
        fixation(w, cx, cy);
        WaitSecs(waitFixationScreen);  % '+' time randomized
        Screen('FillRect',w,0);
        vbl = Screen('Flip', w);  % record vbl, used for TIMING control
        
        %Here comes the sound
        if audio_on
            playSound(pahandle, freq, paceRate, moveDirection(k, 1));
        end
        
        %% PLW that you can see on the screen
        isquit = 0;     % to capture ESCAPE for quitting
        isresponse = 0;
        iniTimer=GetSecs;
        for f=Track  %loop leghth
            % here comes the noise background
            % addNoise(w, 256, wsize);%Do not use this, since buffer tex is used
            Screen('DrawTexture', w, tex(f), [], dstRect, [], 0);
            % and here comes the walkers
            RLonePLW(w,initPosition(1) + paceRate(1)*vTrack(f), cx, cy, dotx , doty , moveDirection(k, :), [255 0 0]);
            RLonePLW(w,initPosition(2) + paceRate(2)*vTrack(f), cx, cy, dotx1, doty1, moveDirection(k, :), [0 255 0]);
            
            % here comes their footsteps
            if tactile_on
                %                 save data/postbuggy;
                %                 disp('postbuggy');
                tactileStimuli(tTrack(f), dioOut);
            end
            %% catch the response
            if ~tactile_on
                dioIn = false;
            end
            
            % get the response
            [Trials, prestate, response, iniTimer, isquit, isresponse ] = getResponse(tactile_on, iniTimer, dioIn, prestate, response, Trialsequence, k, moveDirection, kb, isresponse, isquit, Trials);
            if isresponse; break; end
            
            % Flip the visual stimuli on the screen, along with timing
            vbl = Screen('Flip', w, vbl + flpi);
            
        end
        % quit if the participant pressed ESC
        if isquit, break, end
        
        % end of per trial
        Screen('FillRect',w ,0);
        Screen('Flip', w);
        
        % Get the remaining last response
        [Trials, prestate, response, iniTimer, isquit, isresponse ]  = getlastResponse(tactile_on, iniTimer, dioIn, prestate, response, Trialsequence, k, moveDirection, kb, isresponse, isquit, Trials);
        
    end;
    
    % End of experiment
    save(['data/' Subinfo{1} '.mat'],'Trials');
    % Display 'Thanks' Screen
    RL_Regards(w, english_on);
    
catch
    % save the buggy data for debugging
    save data/buggy;
    Screen('CloseAll');
    if audio_on; PsychPortAudio('Close'); end
    Priority(0);
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
    
end

Screen('CloseAll');
if audio_on; PsychPortAudio('Close'); end
Priority(0);
ShowCursor;
ListenChar(0);

% save data for testing for the last experiment
save data/test
disp('Experiment was successful!');
end
