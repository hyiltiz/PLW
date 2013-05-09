function RL_PLW2(tactile_on, repetitions, filename, scale1)
%% this code to generate pointlight display using 3D coordinates file
%   Written by Lihan Chen, Ph.D, Department of Psychology, Peking University
%   Merged in onePLW, PLWtransform, PLWsound modification .etc in ./lib to optimaze code
%   by Hormetjan, Department of Psychology, Peking University
addpath('./data', './lib', './resources');

global iCounter  prestate response k Trials
Trials=[];
response=0;
iCounter=1;
prestate=0;
if nargin < 4
    tactile_on = 1;  % 0 is no tactile device
    repetitions=2;
    filename = '07_01.data3d.txt';% input data file
    scale1 = 20;
end
regenerate = 1;
% key definitions
KbName('UnifyKeyNames')
escapeKey = KbName('escape');
leftArrow = KbName('LeftArrow'); % modify for Windows?
rightArrow = KbName('RightArrow');
% sample exp. conditions and trial sequences randomized.
rhythmtype= [1 2 3];
trialno= repmat(rhythmtype,1, repetitions);
Trialsequence=trialno(randperm(length(trialno)));
Trials =zeros(length(Trialsequence*3), 3);% for recording results
% tactile hardware setting
if tactile_on
    dioIn=digitalio('parallel','LPT1'); % DAQ, open the LPT1 port
    dioOut=digitalio('parallel','LPT1');
    addline(dioOut,0:7,'out'); % Write data
    addline(dioIn,10:12,'in');
    putvalue(dioOut,0); % clear zero
end
%% Get Subject information
promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)'};
defaultParameters = {'PL_PLW_default', '25','F', 'R'};
Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
if isempty(Subinfo)
    error('Subject information not entered!');
end;
%% initialization
try
    HideCursor;
    ListenChar(2);
    Screen('Preference','SkipSyncTests',0);
    Screen('Preference', 'ConserveVRAM',8);
    
    InitializeMatlabOpenGL;
    if regenerate
        % reading in bvh files
        readData = PLWread(filename);
        imagex=250;  % image size
        T = 130;
        readData.thet = 0;  %to rotate along the first axis
        readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default
        [dotx  doty ] = PLWtransform(readData, scale1, imagex);
        readData.xyzseq = [1 3 2];  %to rotate across xyz
        readData.thet = 180;  %to rotate along the first axis
        [dotx1 doty1] = PLWtransform(readData, scale1, imagex);
    end
    WaitSecs(0.5+rand*0.2);
    
    [w,wsize]=Screen('OpenWindow',0,0);
    cx = wsize(3)/2; %center x
    cy = wsize(4)/2; %center y
    Priority(MaxPriority(w));
    %% create the noise, using buffer, thus better than addNoise
    rectSize = 256;
    noisescale = 2;
    objRect = SetRect(0,0, rectSize, rectSize);
    dstRect = ArrangeRects(1, objRect, wsize);
    
    [xc, yc] = RectCenter(dstRect);
    %         Create a new rectange, centered at the same position, but 'scale'
    %         times the size of our pixel noise matrix 'objRect':
    dstRect=CenterRectOnPoint(objRect * noisescale, xc, yc);
    
    %         Enable alpha blending for smoothed points:
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    floop = 1:3*round(length(dotx)/2);        % 2 for less longer stimuli
    for f = floop;% 2 for accuracy, and T for period
        tex(f)=Screen(w, 'MakeTexture', 50*randn(rectSize, rectSize) + 128);
    end
    
    %% Instructions
    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 1);
    % Select specific text font, style and size:
    Screen('TextFont',w, 'Sans');
    Screen('TextSize',w, 13);
    Screen('TextStyle', w, 1+2);
    DrawFormattedText(w, sprintf(['This is a Point Light Walker demo.\n' ...
        'use arrow key for red Walker''s walking direction\n' ...
        'Hold on and switch the key if the percept changes\n\n' ...
        'Press any key to go on or ESCAPE to quit!']), 'center', 'center', [255, 255, 255]);
    Screen('Flip', w);
    KbStrokeWait;
    %% Here begins our trial
    for k=1:length(Trialsequence*3)
        WaitSecs(.8+rand*0.2);
        if regenerate
            initPosition = Randi(round(T/4),[2 1]);
            paceRate = Randi(3,[2 1]);
            floop = 1:round(length(dotx));% 2 for accuracy, and T for period
            [lefttouch righttouch] = touchground(dotx, initPosition(1), paceRate(1), floop, tactile_on);     %for the index when PLW touches ground
        else
            load RL_PLW_data;
            paceRate = Randi(3,[2 1]); %where we have two PLWs, and quicker than 3 maybe too quick
            initPosition = Randi(round(T/4),[2 1]);
        end
        moveDirection = round(rand([length(Trialsequence) * 3, 2])); %walkers walking direction is random
        %'+'
        Screen('DrawLine', w, 255, cx-10,cy,cx+10,cy,2);
        Screen('DrawLine', w, 255, cx,cy+10,cx,cy-10,2);
        Screen('Flip', w);
        
        WaitSecs(.8+rand*0.2);
        Screen('FillRect',w,0);
        Screen('Flip', w);
        isquit = 0;     % to capture ESCAPE for quitting
        %                 isresponse = 0;
        iniTimer=GetSecs;
        for f=floop  %loop leghth
            Screen('DrawTexture', w, tex(f), [], dstRect, [], 0);
            % and here comes the walkers
            RLonePLW(w,initPosition(1) + paceRate(1)*f, cx, cy, dotx , doty , moveDirection(k, :), [255 0 0]);
            RLonePLW(w,initPosition(2) + paceRate(2)*f, cx, cy, dotx1, doty1, moveDirection(k, :), [0 255 0]);
            Screen('Flip', w);
            WaitSecs(0.02);
            if tactile_on
                % here comes their footsteps
                if all(lefttouch - f)   %true if the left foot touches the ground.
                    putvalue(dioOut, 2);
                end
                if all(righttouch - f)  %true if the right foot touches the ground
                    putvalue(dioOut, 4);
                end
                
                % first channel-say left tactile, up to 8 channels (tactiles), binary coding
                % [1,2,4,8,16,32,64,128; up to 8 Channels of tactile, we could just used two, such
                % as channel 2 and channel 3, coding 2 and 4]
                
                % WON'T THIS AFFECT THE REACTION TIME!!?
                WaitSecs(0.03); % last 30ms, the duration of the first touch;
                putvalue(dioOut,0); % clear zero
            end
            % acquire responce
            
            if GetSecs-iniTimer==0.5+rand;
                beep; % start acquring response
            end
            
            
            getvalue(dioIn);
            switch  sum(getvalue(dioIn))
                case 1
                    response=1; % right response
                case 2
                    response=0;
                case 3
                    response=2; % left response
            end
            if  response~=prestate
                Trials(iCounter,1) = prestate;
                Trials(iCounter,2) = GetSecs - iniTimer;
                Trials(iCounter,3)=k;
                iniTimer = GetSecs;
                iCounter = iCounter + 1;
                prestate=response;
            end
            %                             [keyIsDown, secs, keyCode] = KbCheck;
            %                             if keyIsDown && (keyCode(leftArrow) || keyCode(rightArrow))
            %                                  switch keyCode(leftArrow) + keyCode(rightArrow)*2
            %                                      case 0
            %                                           response=0; % gap no response
            %                                      case 1
            %                                           response=1; % left key response
            %                                      case 2
            %                                           response=2; % right key response
            %                                  end
            %                                  if response~=prestate
            %                                     Trials(iCounter,1)=prestate;
            %                                     Trials(iCounter,2)=GetSecs-iniTimer;
            %                                     Trials(iCounter,3)=k;
            %                                     iniTimer=GetSecs;
            %                                     iCounter=iCounter+1;
            %                                     prestate=response;
            %                                  end
            %
            %                             end
            %     %
            %                         if keyIsDown && keyCode(escapeKey) %quit program
            %                                 isquit = 1;
            %                                 error('quit!');
            %                         end
            %                         if keyIsDown; while KbCheck; end; end; %clear buffer
            %
            %                 end
            %                 if isquit, break, end
            %                 end
            Screen('FillRect',w ,0);
            Screen('Flip', w);
            
            %                 [keyIsDown, secs, keyCode] = KbCheck; % catch last response, in case of omiss
            %                  if response>0
            %                                     Trials(iCounter,1)=prestate;
            %                                     Trials(iCounter,2)=GetSecs-iniTimer;
            %                                     Trials(iCounter,3)=k;
            %                                     iniTimer=GetSecs;
            %                                     iCounter=iCounter+1;
        end
        getvalue(dioIn);  %% the following to capture the last data
        
        switch  sum(getvalue(dioIn))
            case 1
                response=1; % right response
            case 2
                response=0;
            case 3
                response=2; % left response
        end
        
        if  response>0
            Trials(iCounter,1) = prestate;
            Trials(iCounter,2) = GetSecs - iniTimer;
            Trials(iCounter,3)=k;
            iniTimer = GetSecs;
            iCounter = iCounter + 1;
            prestate=response;
        end
        
    end
    save(['data/' Subinfo{1} '.mat'],'Trials', 'moveDirection');
    DrawFormattedText(w, sprintf(['Experiment was successful!\n' ...
        'Thanks for your participating.\n\n' ...
        'Press any key to ESCAPE ']), 'center', 'center', [255, 255, 255]);
    Screen('Flip', w);
    KbStrokeWait;
catch ME
    Screen('CloseAll');
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
Priority(0);
ShowCursor;
ListenChar(0);
