function RL_PLW_octave(tactile_on, repetitions, filename, scale1)
%% this code to generate pointlight display using 3D coordinates file
%   Written by Lihan Chen, Ph.D, Department of Psychology, Peking University
%   Merged in onePLW, PLWtransform, PLWsound modification to optimaze code
%   by Hormetjan, Department of Psychology, Peking University
try
        addpath('./data', './lib', './resources');
        
        if nargin < 4
                tactile_on = 0;  % 0 is no tactile device
                repetitions=2;
                filename = '07_01.data3d.txt';% input data file
                scale1 = 20;
        end
        
        % if nargin > 0
        %         regenerate = 1;
        % else
        %         regenerate = 0;
        % end
        regenerate = 1;
        
        % key definitions
        KbName('UnifyKeyNames')
        escapeKey = KbName('escape');
        leftArrow = KbName('LeftArrow'); % modify for Windows?
        rightArrow = KbName('RightArrow');
        upArrow = KbName('UpArrow');
        downArrow = KbName('DownArrow');
        
        % sample exp. conditions and trial sequences randomized.
        rhythmtype= [1 2 3];
        trialno= repmat(rhythmtype,1, repetitions);
        Trialsequence=trialno(randperm(length(trialno)));
        Trials =zeros(length(Trialsequence*3), 3);% for recording results
        
        % psychoaudio hardware setting.
        freq = 48000;
        latbias = (64 / freq); %hardware delay
        InitializePsychSound(1);
        pahandle = PsychPortAudio('Open');
        % Tell driver about hardwares inherent latency
        PsychPortAudio('LatencyBias', pahandle, latbias);
        PsychPortAudio('LatencyBias', pahandle);
        
        % tactile hardware setting
        if tactile_on
                dioIn=digitalio('parallel','LPT1'); % DAQ, open the LPT1 port
                dioOut=digitalio('parallel','LPT1');
                addline(dioOut,0:7,'out'); % Write data
                addline(dioIn,10:12,'in'); % for footswitch input.
                putvalue(dioOut,0); % clear zero
        end
        %% Get Subject information
        promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)'};
        defaultParameters = {'PL_PLW_default', '25','F', 'R'};
        %Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
        Subinfo = {};
        for i = 1 : length(promptParameters)
                getinput = 0;
                getinput = input(['Please enter ', promptParameters{i}, ':']);
                if isempty(getinput)
                        getinput = defaultParameters{i};
                end
                Subinfo = {Subinfo; getinput};
        end
        
        if isempty(Subinfo)
                error('Subject information not entered!');
        end;
        
        % try
        %% initialization
        HideCursor;
        ListenChar(2);
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
        HideCursor;
        
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
        
        floop = 1:round(length(dotx)/2);        % 2 for less longer stimuli
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
                'React as quick and right as possible\n\n' ...
                'Press any key to go on or ESCAPE to quit!']), 'center', 'center', [255, 255, 255]);
        Screen('Flip', w);
        KbStrokeWait;
        
        %% Here begins our trial
        for k=1:length(Trialsequence*3)
                WaitSecs(.8+rand*0.2);
                
                % randomization
                save('data/RL_PLW_data');
                if regenerate
                        initPosition = Randi(round(T/4),[2 1]);
                        paceRate = Randi(3,[2 1]);
                        floop = 1:round(length(dotx));% 2 for accuracy, and T for period
                        [lefttouch righttouch] = touchground(dotx, initPosition(1), paceRate(1), floop);     %for the index when PLW touches ground
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
                
                %Here comes the sound
                freq = 48000 * paceRate(1);  %adjusting here is inadequate!
                latbias = (64 / freq); %hardware delay
                % Tell driver about hardwares inherent latency
                PsychPortAudio('LatencyBias', pahandle, latbias);
                y = wavread('footsteps.wav');
                y = PLWsound(y, moveDirection(k, 1), paceRate(1));  %make transformation for sound
                PsychPortAudio('FillBuffer', pahandle, y);
                PsychPortAudio('Start', pahandle, 1, 0, 0);
                
                %% PLW that you can see on the screen
                isquit = 0;     % to capture ESCAPE for quitting
                isresponse = 0;
                iniTimer=GetSecs;
                for f=floop  %loop leghth
                        % here comes the noise background
                        % addNoise(w, 256, wsize);  %Do not use this, since
                        % buffer tex is used
                        Screen('DrawTexture', w, tex(f), [], dstRect, [], 0);
                        % and here comes the walkers
                        RLonePLW(w,initPosition(1) + paceRate(1)*f, cx, cy, dotx , doty , moveDirection(k, :), [255 0 0]);
                        RLonePLW(w,initPosition(2) + paceRate(2)*f, cx, cy, dotx1, doty1, moveDirection(k, :), [0 255 0]);
                        
                        if tactile_on
                                % here comes their footsteps
                                if all(lefttouch - f)   %true if the left foot touches the ground.
                                        putvalue(dioOut, 2);
                                end
                                if all(righttouch - f)
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
                        [keyIsDown, secs, keyCode ] = KbCheck;
                        if keyIsDown && (keyCode(leftArrow) || keyCode(rightArrow))
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
                
                Screen('FillRect',w ,0);
                Screen('Flip', w);
                if ~isresponse  %well get response then, better late than never
                        [secs, keyCode] = KbWait; %wait for the response
                        if keyCode(leftArrow) || keyCode(rightArrow)
                                Trials(k,3) = GetSecs-iniTimer;
                                Trials(k,1) = Trialsequence(k);
                                Trials(k,2) = keyCode(leftArrow) + keyCode(rightArrow)*2 + keyCode(upArrow)*3 + keyCode(downArrow)*4;
                                PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
                        end
                end
                
                
        end;
        save(['data/' Subinfo{1} '.mat'],'Trials', 'moveDirection');
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
        %       disp(ME);
        %       disp('');
        %       for k=1:length(ME.stack)
        %               ME.stack(k)
        %       end
        %       disp(getReport(ME));
        
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
