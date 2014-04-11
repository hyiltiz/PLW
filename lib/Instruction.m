function keyCode = Instruction(filename, w, wsize, debug_mode, english_on, kb, time,skipFile, tactile_on)
% Print instructions in instruction file.

isSkip = 1;
if ~isSkip
    english_on = 0;
    debug_mode = 0;
    skipFile = 1;
    kb = keyDefinition();
    tactile_on = 0;
    time = 3;
    
    % use instructions for RL_PLW() if the filename is not given.
%     try
%         if ~isemyty(filename); end
%     catch
%         switch english_on
%             case 1
%                 filename = 'instructions_Octal.txt';
%             case 0
%                 filename = 'instructions_Octal_zh.txt';
%             otherwise
%                 filename = 'instructions_Octal.txt';
%         end
%     end
end
Screen('Preference', 'TextRenderer', 1);


% Read some text file:
if skipFile
    mytext = filename;
else
    [fd msg] = fopen(['./resources/' filename], 'rt', 'n', 'Shift_JIS');
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
mytext = native2unicode(mytext, 'Shift_JIS');
% mytext = double(mytext);
% disp(mytext);

if ~isSkip
    screens=Screen('Screens');
    screenNumber=max(screens);
    if debug_mode
%         [w,wsize]=Screen('OpenWindow',screenNumber,0);
        [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    else
        [w,wsize]=Screen('OpenWindow',screenNumber,0);
    end
end

% Select specific text font, style and size:
% Screen('TextFont',w, 'Microsoft YaHei UI');
Screen('TextSize',w, 20);
% Screen('TextStyle', w, 1+2);
Screen('TextStyle', w, 1);


% Select specific text font, style and size:
%   Screen('Preference', 'TextRenderer', 1);
%   Screen('Preference', 'TextAntiAliasing', 1);

% golden_ratio = (sqrt(5)-1)/2;
lenghth = 32;
[~, ~, bbox] = DrawFormattedText(w, mytext, 0, 0, 0, lenghth);
textbox = (wsize - bbox)/2;
DrawFormattedText(w, mytext, textbox(3), textbox(4), [255 255 255], lenghth);

% Show computed text bounding box:
Screen('FrameRect', w, 0, bbox);
Screen('Flip',w);

keyCode = pedalWait(tactile_on, time, kb);

end
