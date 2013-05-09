%% this code to generate pointlight display using 3D coordinates file
%   Written by Lihan Chen, Ph.D, Department of Psychology, Peking University
%   Merged in onePLW, PLWtransform, PLWsound modification to optimaze code
%   by Hormetjan, Department of Psychology, Peking University
addpath('./data', './lib', './resources');

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
repetitions=1;
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
defaultParameters = {'sub99', '25','F', 'R'};
Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);

%% initialization
try
        HideCursor;
        InitializeMatlabOpenGL;
        % reading in bvh files
        filename = '07_01.data3d.txt';% input data file
        readData = PLWread(filename);
        imagex=250;  % image size
        scale1 = 20;
        
        readData.thet = 0;  %to rotate along the first axis
        readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default
        [dotx  doty ] = PLWtransform(readData, scale1, imagex);
        readData.xyzseq = [3 1 2];  %to rotate across xyz
        [dotx1 doty1] = PLWtransform(readData, scale1, imagex);
        readData.xyzseq = [3 2 1];  %to rotate across xyz
        [dotx2 doty2] = PLWtransform(readData, scale1, imagex);
        readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default
        readData.thet = 60;  %to rotate along the first axis
        [dotx3 doty3] = PLWtransform(readData, scale1, imagex);
        
        WaitSecs(0.5+rand*0.2);
        
        [w,wsize]=Screen('OpenWindow',0,0);
        cx = wsize(3)/2; %center x
        cy = wsize(4)/2; %center y
        Priority(MaxPriority(w));
        % Enable alpha blending for smoothed points:
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
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
                y = PLWsound(y,1,1);  %make transformation for sound
                PsychPortAudio('FillBuffer', pahandle, y);
                PsychPortAudio('Start', pahandle, 1, 0, 0);
                
                %% PLW that you can see on the screen
                for f=1:length(dotx)  % 2 for accuracy
                        onePLW(w,    2*f, cx, cy, dotx , doty , [ 0.3  0.6], [0 1]);
                        onePLW(w,    1*f, cx, cy, dotx1, doty1, [-0.3  0.6], [0 1]);
                        onePLW(w,    4*f, cx, cy, dotx2, doty2, [ 0.3 -0.6], [0 1]);
                        onePLW(w,    2*f, cx, cy, dotx3, doty3, [-0.3 -0.6], [0 1]);
                        
                        Screen('Flip', w);
                        WaitSecs(0.02);
                end
                
                Screen('FillRect',w,0);
                Screen('Flip', w);
                %% the following is to acquire responses
                iniTimer=GetSecs;
                while 1
                        [ keyIsDown, seconds, keyCode ] = KbCheck;
                        if keyIsDown && (keyCode(escapeKey) || keyCode(leftArrow) || keyCode(rightArrow)|| keyCode(upArrow) || keyCode(downArrow))
                                break;
                        end
                        if keyIsDown; while KbCheck; end; end; %clear buffer
                end
                if keyCode(escapeKey) %quit program
                        break;
                end
                
                Trials(k,1) = Trialsequence(k);
                Trials(k,2) = keyCode(leftArrow) + keyCode(rightArrow)*2 + keyCode(upArrow)*3 + keyCode(downArrow)*4;
                Trials(k,3) = GetSecs-iniTimer;
        end;
        
        save(['data/' 'PLWviewerScr.mat'],'Trials');
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
