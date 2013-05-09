%% this code to generate pointlight display using 3D coordinates file
%   Written by Lihan Chen, Ph.D, Department of Psychology, Peking University
%   Merged in onePLW, PLWtransform, PLWsound modification to optimaze code
%   by Hormetjan, Department of Psychology, Peking University

clear all;
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
trialno= repmat(rhythmtype,1, repetitions);
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
defaultParameters = {'PL_PLW_default', '25','F', 'R'};
Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);

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
        
        readData.thet = 0;  %to rotate along the first axis
        readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default
        [dotx  doty ] = PLWtransform(readData, scale1, imagex);
        
        readData.xyzseq = [1 3 2];  %to rotate across xyz
        readData.thet = 180;  %to rotate along the first axis
        [dotx1 doty1] = PLWtransform(readData, scale1, imagex);
        
        WaitSecs(0.5+rand*0.2);
        
        [w,wsize]=Screen('OpenWindow',0,0);
        cx = wsize(3)/2; %center x
        cy = wsize(4)/2; %center y
        T = 130;
        Priority(MaxPriority(w));
        
        % Enable alpha blending for smoothed points:
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        %% Instructions
        Screen('Preference', 'TextRenderer', 1);
        Screen('Preference', 'TextAntiAliasing', 1);
        % Select specific text font, style and size:
        Screen('TextFont',w, 'Sans');
        Screen('TextSize',w, 13);
        Screen('TextStyle', w, 1+2);
        DrawFormattedText(w, sprintf(['This is a Point Light Walker demo.\n' ...
                'use arrow key for red Walker''s walking direction\n' ...
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
                
                %Here comes the sound
                [y, Fs, nbits] = wavread('footsteps.wav');
                y = PLWsound(y);  %make transformation for sound
                PsychPortAudio('FillBuffer', pahandle, y);
                PsychPortAudio('Start', pahandle, 1, 0, 0);
                
                %% PLW that you can see on the screen
                paceRate = Randi(3,[2 1]); %where we have two PLWs, and quicker than 3 maybe too quick
                moveDirection(k, :) = round(rand([2 1]));     %walkers walking direction is random
                initPosition = Randi(T/2, [2 1]);       %initial position is random
                isquit = 0;     % to capture ESCAPE for quitting
                isresponse = 0;
                iniTimer=GetSecs;
                for f=1:round(length(dotx)/4)  % 2 for accuracy, and T for period
                        RLonePLW(w,initPosition(1) + paceRate(1)*f, cx, cy, dotx , doty , moveDirection(k, :), [255 0 0]);
                        RLonePLW(w,initPosition(2) + paceRate(2)*f, cx, cy, dotx1, doty1, moveDirection(k, :), [0 255 0]);
                        
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
                if ~isresponse  %well get response then, better late than never
                        Trials(k,3) = GetSecs-iniTimer;
                        Trials(k,1) = Trialsequence(k);
                        Trials(k,2) = keyCode(leftArrow) + keyCode(rightArrow)*2 + keyCode(upArrow)*3 + keyCode(downArrow)*4;
                        PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
                        isresponse = 1;
                end
                Screen('FillRect',w ,0);
                Screen('Flip', w);
                
        end;
        save([Subinfo{1} '.mat'],'Trials', 'moveDirection');
        DrawFormattedText(w, sprintf(['Experiment was successful!\n' ...
                'Thanks for your participating.\n\n' ...
                'Press any key to ESCAPE ']), 'center', 'center', [255, 255, 255]);
        Screen('Flip', w);
        KbStrokeWait;
catch
        Screen('CloseAll');
        PsychPortAudio('Close');
        Priority(0);
        ShowCursor;
        ListenChar(0);
        whatswrong = lasterror;
        disp('');
        whatswrong.message
        whatswrong.stack.line
        whatswrong.stack.file
end
Screen('CloseAll');
PsychPortAudio('Close');
Priority(0);
ShowCursor;
ListenChar(0);
