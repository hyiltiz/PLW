%% this code to generate pointlight display using 3D coordinates file
%   Written by Lihan Chen, Ph.D, Department of Psychology, Peking University
%   Merged in onePLW, PLWtransform, PLWsound modification to optimaze code
%   by Hormetjan, Department of Psychology, Peking University
addpath('./data', './lib', './resources');

Trials =[];% for recording results
% key definitions
KbName('UnifyKeyNames')
escapeKey = kbName('escape');
leftArrow = KbName('LeftArrow'); % modify for Windows?
rightArrow = KbName('RightArrow');
upArrow = KbName('UpArrow');
downArrow = KbName('DownArrow');

% sample exp. conditions and trial sequences randomized.
rhythmtype= [1 2 3];
repetitions=2;
trialno=repmat(rhythmtype,1, repetitions);
Trialsequence=trialno(randperm(length(trialno)));

% psychoaudio hardware setting.
freq = 48000;
latbias = (64 / freq); %hardware delay
InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [],[],2,freq);
% Tell driver about hardwares inherent latency
prelat = PsychPortAudio('LatencyBias', pahandle, latbias);
postlat = PsychPortAudio('LatencyBias', pahandle);

%% Get Subject information
promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)'};
defaultParameters = {'ClockPLW_default', '25','F', 'R'};
Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
if isempty(Subinfo) error('Subject information not entered!');end;
%% initialization
try
        HideCursor;
        ListenChar(2);
        InitializeMatlabOpenGL;
        % reading in bvh files
        filename = '07_01.data3d.txt';% input data file
        readData = PLWread(filename);
        imagex=250;  % image size
        scale1 = 20;
        
        WaitSecs(0.5+rand*0.2);
        
        [w,wsize]=Screen('OpenWindow',0,0);
        cx = wsize(3)/2; %center x
        cy = wsize(4)/2; %center y
        Priority(MaxPriority(w));
        % Enable alpha blending for smoothed points:
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        %% Instructions
        Screen('Preference', 'TextRenderer', 1);
        Screen('Preference', 'TextAntiAliasing', 1);
        % Select specific text font, style and size:
        Screen('TextFont',w, 'Sans');
        Screen('TextSize',w, 18);
        Screen('TextStyle', w, 1+2);
        DrawFormattedText(w, sprintf(['This is a Point Light Walker demo.\n' ...
                'use arrow key for most Walker''s walking direction\n' ...
                'Press any key to go on or ESCAPE to quit!']), 'center', 'center', [255, 255, 255]);
        Screen('Flip', w);
        KbStrokeWait;
        %% Here begins our trial
        for k=1:length(Trialsequence*3)
                WaitSecs(.8+rand*0.2);
                %'+'
                Screen('DrawLine', w, 255, cx-10,cy,cx+10,cy,2);
                Screen('DrawLine', w, 255, cx,cy+10,cx,cy-10,2);
                Screen('Flip', w);
                
                WaitSecs(.8+rand*0.2);
                Screen('FillRect',w,0);
                Screen('Flip', w);
                
                %% PLW that you can see on the screen
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
                
                %Here comes the sound
                [y, Fs, nbits] = wavread('footsteps.wav');
                y = PLWsound(y,1,1);  %make transformation for sound
                PsychPortAudio('FillBuffer', pahandle, y);
                PsychPortAudio('Start', pahandle, 1, 0, 0);
                
                %begin it, at last!
                isquit = 0;     % to capture ESCAPE for quitting
                isresponse = 0;
                iniTimer=GetSecs;
                for f=1:length(dotx)  % 2 for accuracy
                        addNoise_old(w, 100, wsize);
                        for i = 1 : n
                                ClockonePLW(w,dot{i}.pace*f, cx, cy, dot{i}.x , dot{i}.y ,dot{i}.pos, [0 1]);
                        end
                        
                        % acquire responce
                        [ keyIsDown, seconds, keyCode ] = KbCheck;
                        if keyIsDown && keyCode(leftArrow) || (keyCode(rightArrow)|| keyCode(upArrow) || keyCode(downArrow))
                                Trials(k,3) = GetSecs-iniTimer;
                                Trials(k,1) = Trialsequence(k);
                                Trials(k,2) = keyCode(leftArrow) + keyCode(rightArrow)*2 + keyCode(upArrow)*3 + keyCode(downArrow)*4;
                                PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
                                isresponse = 1;
                                break;
                        end
                        if keyIsDown && keyCode(escapeKey) %quit program
                                isquit = 1;
                                error('quit!');
                        end
                        if keyIsDown; while KbCheck; end; end; %clear buffer
                        
                        Screen('Flip', w);
                        WaitSecs(0.02);
                end
                if isquit, break, end
                while ~isresponse  %well get response then, better late than never
                        [~, keyCode] = KbWait; %wait for the response
                        if keyCode(leftArrow) || keyCode(rightArrow)
                                Trials(k,3) = GetSecs-iniTimer;
                                Trials(k,1) = Trialsequence(k);
                                Trials(k,2) = keyCode(leftArrow) + keyCode(rightArrow)*2 + keyCode(upArrow)*3 + keyCode(downArrow)*4;
                                PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
                                isresponse = 1;
                        end
                end
                
                Screen('FillRect',w,0);
                Screen('Flip', w);
                
        end;
        save(['data/' Subinfo{1} '.mat'],'Trials', 'theta');
        DrawFormatted Text(w, sprintf(['Experiment was successful!\n' ...
                'Thanks for your participating.\n\n' ...
                'Press any key to ESCAPE ']), 'center', 'center', [255, 255, 255]);
        Screen('Flip', w);
        KbStrokeWait;
catch ME
        Screen('CloseAll');
        PsychPortAudio('Close');
        Priority(0);
        ShowCursor;
        ListenChar(0);
        disp(ME);
        disp('');
        for k=1:length(ME.stack)
                ME.stack(k)
        end
        disp(getReport(ME));
        
        %         whatswrong = lasterror;
        %         disp('');
        %         whatswrong.message
        %         whatswrong.stack.line
        %         whatswrong.stack.file
end
Screen('CloseAll');
PsychPortAudio('Close');
Priority(0);
ShowCursor;
ListenChar(0);