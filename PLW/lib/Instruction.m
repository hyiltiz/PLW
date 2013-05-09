function Instruction(filename, w, wsize, debug_mode, english_on, kb, time,skipFile, tactile_on)
% Print instructions in instruction file.

isSkip = 1;
if ~isSkip
    english_on = 1;
    debug_mode = 1;
end

% use instructions for RL_PLW() if the filename is not given.
% try
%     if ~isemyty(filename); end
% catch
%     switch english_on
%         case 1
%             filename = 'RL_Instruction_en.txt';
%         case 0
%             filename = 'RL_Instruction_zh.txt';
%         otherwise
%             filename = 'RL_Instruction_en.txt';
%     end
% end

% Read some text file:
if skipFile
    mytext = filename;
else
    [fd msg] = fopen(['./resources/' filename], 'rt');
    if fd==-1
        error(sprintf(['Could not open the %s file in ./resources directory! ' msg], filename));
    end
    
    mytext = '';
    tl = fgets(fd);
    lcount = 0;
    while (tl~=-1) & (lcount < 48)
        mytext = [mytext tl];
        tl = fgets(fd);
        lcount = lcount + 1;
    end
    fclose(fd);
end
mytext = [mytext char(10)];

% disp(mytext);

if ~isSkip
    debug_mode = 1;
    screens=Screen('Screens');
    screenNumber=max(screens);
    if debug_mode
        [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    else
        [w,wsize]=Screen('OpenWindow',screenNumber,0);
    end
end

% Select specific text font, style and size:
% Screen('TextFont',w, 'Times');
Screen('TextSize',w, 20);
% Screen('TextStyle', w, 1+2);
Screen('TextStyle', w, 1);

% Select specific text font, style and size:
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);

% golden_ratio = (sqrt(5)-1)/2;
lenghth = 52;
[~, ~, bbox] = DrawFormattedText(w, mytext, 0, 0, 0, lenghth);
textbox = (wsize - bbox)/2;
DrawFormattedText(w, mytext, textbox(3), textbox(4), [255 255 255], lenghth);

% Show computed text bounding box:
Screen('FrameRect', w, 0, bbox);
Screen('Flip',w);

if tactile_on
    dioIn=digitalio('parallel','LPT1'); % DAQ, open the LPT1 port
    addline(dioIn,10:12,'in'); % for footswitch input.
    secs = -inf;
    ini = GetSecs;
    while secs - ini < time
        if sum(getvalue(dioIn)) ~= 2 % play if not pressed pedal
            return;
        end
        
        % Wait for .01 to prevent system overload.
        secs = WaitSecs('YieldSecs', .01);
        manualAbort(kb);
    end
else
    % wait for any key press to go on, unless breaking out by calling ESC
    [~, keyCode] = KbStrokeWait([], time);
    
    if keyCode(kb.escapeKey) %quit program
        sca;
        error('Experiment aborted manually!');
    end
    
end
