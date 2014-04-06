function PLWTactileBase
% As a baseline test for PLW tactile asynchrony manipulation
%% 14, Mar, 2013, lihan chen
addpath('./data', './lib', './resources');
global   iCounter dioIn dioOut initTime  trials mainWnd  prestate   response  iTrl seq  totaltrials
totaltrials = [];
kbName('UnifyKeyNames');
escapeKey = kbName('escape');
response= 0;
prestate = 2; %[1 0];PLW
trials = [];
iCounter = 1;
Tinterval=0;
seq = genTrials(2,[2 3]); % first-1 from initial inwards; 2-initial leftwards;
% second, 1-tactile short-long-short, 2-tactile equal; 3-tactile
% long-short-long.
%% initialize dio
dioIn=digitalio('parallel','LPT1');
dioOut=digitalio('parallel','LPT1');
addline(dioOut,0:7,'out');
addline(dioIn,10:12,'in');
putvalue(dioOut,0);
%% audio parameters
% freq = 44100;
% tone(1,:) = 0.9 * MakeBeep(1000, 0.03, 44100); %40ms < visual display to avoid clicks sound
% tone(2,:) = tone(1,:);
%% Get Subject information
promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)','Response direction(L1 or R1)'};
defaultParameters = {'', '','', 'R',''};
Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
% initialization of screen
%%Stimuli duration-Tactile
sampleRate = 0.01; %100 hz % mointor refresh interval 100ms
HFrames= 0.01/sampleRate;  % haptic duration 10ms
TFrames = 1.3/sampleRate; % half circle frames  650ms
SFrames = 0.15/sampleRate; %step frames 150ms
initHFrame = 0.1/sampleRate;
tAdjust = 0.00035;
HideCursor;
Screen('Preference','SkipSyncTests',0);
Screen('Preference', 'ConserveVRAM',8);
InitializeMatlabOpenGL;
try
    AssertOpenGL; %Check if PTB-3 is properly installed on the system
    screens=Screen('Screens');
    screenNumber=max(screens);
    [mainWnd wsize] = Screen('OpenWindow',screenNumber); % Open On Screen window, mainWnd
    cx = wsize(3)/2; %center x
    cy = wsize(4)/2; %center y
    Screen('TextFont',mainWnd,'Arial');
    Screen('TextSize',mainWnd,15);
    flipIntv=Screen('GetFlipInterval', mainWnd, 10); % get monitor refresh interval in second
    %%0.1 Display Instructions,the first page;
    Screen('FillRect',mainWnd);
    drawTextAt(mainWnd,'This is an experiment about apparent motion.', cx,cy-200,[200 200 200]);
    drawTextAt(mainWnd,'There will be two tactile taps successively presented on your left and right foot', cx,cy-100,[200 200 200]);
    drawTextAt(mainWnd,'your task is to report the dominant direction of the motion after the first several tactile pair is presented ', cx,cy-50,[200 200 200]);
    drawTextAt(mainWnd,'If you perceive in-ward motion [^], please press red button and HOLD it', cx,cy,[200 200 200]);
    drawTextAt(mainWnd,'If you perceive out-ward motion [v], please press green button and HOLD it', cx,cy+50,[200 200 200]);
    drawTextAt(mainWnd,'Press red button to second page...', cx,cy+250,[200 200 200]);
    Screen('Flip', mainWnd);
    DioWait;
    WaitSecs(1);
    
    %%0.2 Display Instructions,the second page;
    Screen('FillRect',mainWnd);
    drawTextAt(mainWnd,'Please make your responses after the signal ''begins'' appears', cx,cy,[200 200 200]);
    drawTextAt(mainWnd,'Press red button to start', cx,cy+250,[200 200 200]);
    Screen('Flip', mainWnd);
    DioWait;
    WaitSecs(1);
    
    Screen('FillRect',mainWnd);
    Screen('Flip', mainWnd);
    %% present stimli
    for iTrl = 1: length(seq)
        if mod(iTrl,4)==0  % take a rest for every three trials.
            WaitSecs(2);
            Screen('TextSize',mainWnd,15);
            strTrl = sprintf('Trial No %d',iTrl);
            drawTextAt(mainWnd,strTrl, cx,cy-20,255);
            drawTextAt(mainWnd,'Please take a rest', cx,cy+ 20,255);
            drawTextAt(mainWnd,'Press red button to continue...',cx,cy+60,255);%% and then lift the padel
            Screen('Flip', mainWnd);
            DioWait;
            Screen('FillRect',mainWnd);
            Screen('Flip', mainWnd);
        else
            WaitSecs(2);
            Screen('TextSize',mainWnd,15);
            strTrl = sprintf('Trial No %d',iTrl);
            Screen('Flip', mainWnd);
            drawTextAt(mainWnd,strTrl,cx,cy-20,255);
            drawTextAt(mainWnd,' red button to start...',cx,cy+20,255);
            Screen('Flip', mainWnd);
            DioWait;
            Screen('FillRect',mainWnd);
            Screen('Flip', mainWnd);
        end
        
        
        %exit if press excape key
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if keyCode(escapeKey)
                break;
            end
            while KbCheck; end
        end
        % sampleRate = 0.01; %100 hz
        % HFrames= 0.01/sampleRate;  % haptic duration 10ms
        % TFrames = 1.3/sampleRate; % half circle frames  650ms
        % SFrames = 0.15/sampleRate; %step frames 150ms
        % initHFrame = 0.1/sampleRate;
        % tAdjust = 0.00035;
        % seq = genTrials(2,[2 3]); % first-1 from initial inwards; 2-initial leftwards;
        % second, 1-tactile short-long-short, 2-tactile equal; 3-tactile
        % long-short-long.
        
        %% seq(iTrl,2)=1,tactile short-long-short temporal structure
        %% seq(iTrl,2)=2,bistable motion
        %% seq(iTrl,2)=3,tactile long-short-long temporal structure
        
        T=70;   %duration 70 seconds
        Tinterval=GetSecs;
        % initTime = GetSecs;
        if seq(iTrl,1)==1 %% initial tactile: left
            if seq(iTrl,2)==1 % first tactile leading, short-long-short
                tStim = [zeros(1,initHFrame), 1, -1, zeros(1,10), 3,-1,zeros(1, round(TFrames/2)-SFrames-2-12),2,-1, zeros(1,10), 4,-1, zeros(1,round(TFrames/2)-initHFrame-2-12+SFrames)];
            elseif seq(iTrl,2)==2
                tStim = [zeros(1,initHFrame), 1, -1, zeros(1,10), 3,-1,zeros(1, (round(TFrames/2)-2-12)),2,-1, zeros(1,10), 4,-1, zeros(1,TFrames-initHFrame-2-12-round(TFrames/2))];
            elseif seq(iTrl,2)==3 %% long-short-long
                tStim = [zeros(1,initHFrame), 1, -1, zeros(1,10), 3,-1,zeros(1,  round(TFrames/2)+SFrames-2-12),2 -1, zeros(1,10), 4,-1, zeros(1,round(TFrames/2)-initHFrame-2-12-SFrames)];
            end
        else  % initial tactile tap: right tap
            if seq(iTrl,2)==1 % first tactile leading, short-long-short
                tStim = [zeros(1,initHFrame), 2, -1, zeros(1,10), 4,-1,zeros(1, round(TFrames/2)-SFrames-2-12),1,-1, zeros(1,10), 3,-1, zeros(1,round(TFrames/2)-initHFrame-2-12+SFrames)];
            elseif seq(iTrl,2)==2
                tStim = [zeros(1,initHFrame), 2, -1, zeros(1,10), 4,-1,zeros(1, (round(TFrames/2)-2-12)),1,-1, zeros(1,10), 3,-1, zeros(1,TFrames-initHFrame-2-12-round(TFrames/2))];
            elseif seq(iTrl,2)==3 %% long-short-long
                tStim = [zeros(1,initHFrame), 2, -1, zeros(1,10), 4,-1,zeros(1,  round(TFrames/2)+SFrames-2-12),1 -1, zeros(1,10), 3,-1, zeros(1,round(TFrames/2)-initHFrame-2-12-SFrames)];
            end
        end
        
        prestate=2;
        response=0;
        iCounter = 1;
        trials = [];
        
        %presenting stimuli
        for iRep = 1:round(T/1.3);
            if iRep==5
                initTime = GetSecs;
            end
            for iframe = 1: TFrames
                if iRep>=5
                    drawTextAt(mainWnd,'begins', cx,cy-20,[255 0 0]);
                end
                switch tStim(iframe)
                    case 1
                        putvalue(dioOut,2);%% left tactile
                    case 2
                        putvalue(dioOut,8); %% right tactile
                    case 3
                        putvalue(dioOut, 16);% the left front foot touches the ground.
                    case 4
                        putvalue(dioOut, 32);% the left front foot touches the ground.
                    case -1
                        putvalue(dioOut,0);
                end
                
                %acquiring data
                if iRep>=5 %% eliminate initial bias,start response
                    getvalue(dioIn);
                    if sum(getvalue(dioIn))==2
                        response=0;
                    elseif sum(getvalue(dioIn))==3
                        response=1;
                    elseif sum(getvalue(dioIn))==1
                        response=2;
                    end
                    if  response~=prestate
                        trials(iCounter,1) = prestate;
                        trials(iCounter,2) = GetSecs - initTime;
                        trials(iCounter,3)=iTrl;
                        trials(iCounter,4)=seq(iTrl,1);
                        trials(iCounter,5)=seq(iTrl,2);
                        initTime = GetSecs;
                        iCounter = iCounter + 1;
                        prestate=response;
                    end
                end
                Screen('Flip', mainWnd);
            end
            %end one cycle
        end  %% end a trial
        M{iTrl}=Getsecs-Tinterval; %% to capture the real time of a trial
        getvalue(dioIn);  %% the following to capture the last data
        Screen('FillRect',mainWnd);
        Screen('Flip', mainWnd);
        if sum(getvalue(dioIn))==2
            response=0;
        elseif sum(getvalue(dioIn))==3
            response=1;
        elseif sum(getvalue(dioIn))==1
            response=2;
        end
        
        if  response>0
            trials(iCounter,1) = response;
            trials(iCounter,2) = GetSecs - initTime;
            trials(iCounter,3)=iTrl;
            trials(iCounter,4)=seq(iTrl,1);
            trials(iCounter,5)=seq(iTrl,2);
            initTime = GetSecs;
            iCounter = iCounter + 1;
        end
        
        totaltrials=[totaltrials;trials];
        
        putvalue(dioOut,0);
    end %% end all trials
    putvalue(dioOut,0);
    %store reponses to trials
    WaitSecs(1);
    Screen('TextSize',mainWnd,30);
    drawTextAt(mainWnd,'The experiment ends!', cx,cy-20,255);
    drawTextAt(mainWnd,'Thank you!!',cx,cy+ 20,255);
    Screen('Flip', mainWnd);
    WaitSecs(3);
    Screen('CloseAll');
    Priority(0);
    ShowCursor;
    if isempty(Subinfo{1})
        save('data/Test','seq','totaltrials','M');
    else
        save(['data/', Subinfo{1}],'seq','Subinfo','totaltrials','M' );
    end
    clear all;
catch
    Screen('CloseAll');
    Priority(0);
    ShowCursor;
    whatswrong = lasterror;
    disp(whatswrong.message);
    disp(whatswrong.stack.line);
end
