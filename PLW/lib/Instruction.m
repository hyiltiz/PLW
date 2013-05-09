function Instruction(filename, w, wsize, debug_mode, english_on, kb)
% Print instructions in instruction file.

% english_on = 1;
% debug_mode = 1;

% use instructions for RL_PLW() if the filename is not given.
try
    if ~isemyty(filename); end
catch
    switch english_on
        case 1
            filename = 'RL_Instruction_en.txt';
        case 0
            filename = 'RL_Instruction_zh.txt';
        otherwise
            filename = 'RL_Instruction_en.txt';
    end
end

% Read some text file:
fd = fopen(['resources/' filename], 'rt');
if fd==-1
    error('Could not open Instruction.txt file in ./resource directory!');
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
mytext = [mytext char(10)];

% disp(mytext);

% screens=Screen('Screens');
% screenNumber=max(screens);
% [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
% [w,wsize]=Screen('OpenWindow',screenNumber,0);

% Select specific text font, style and size:
% Screen('TextFont',w, 'Times');
Screen('TextSize',w, 20);
% Screen('TextStyle', w, 1+2);
Screen('TextStyle', w, 1);

% Select specific text font, style and size:
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);

% golden_ratio = (sqrt(5)-1)/2;
lenghth = 64;
[~, ~, bbox] = DrawFormattedText(w, mytext, 0, 0, 0, lenghth);
textbox = (wsize - bbox)/2;
DrawFormattedText(w, mytext, textbox(3), textbox(4), [255 255 255], lenghth);

% Show computed text bounding box:
Screen('FrameRect', w, 0, bbox);
Screen('Flip',w);

% wait for any key press to go on, unless breaking out by calling ESC
[~, keyCode] = KbStrokeWait;
if keyCode(kb.escapeKey) %quit program
    sca;
    error('Experiment aborted manually!');
end

end