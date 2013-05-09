function restcount = restBetweenTrial(restcount, resttime, pertrial, w, wsize, debug_mode, english_on, kb)
% take a rest after some trials

isSkip = 1;
if ~isSkip
    debug_mode = 1;
    screens=Screen('Screens');
    screenNumber=max(screens);
    english_mode = 0;
    restcount = 0
    if debug_mode
        [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    else
        [w,wsize]=Screen('OpenWindow',screenNumber,0);
    end
end

if restcount == pertrial
    if english_on
    Instruction('restBetweenTrial_text_en.txt', w, wsize, debug_mode, english_on, kb, resttime);
    else
        Instruction('restBetweenTrial_text_zh.txt', w, wsize, debug_mode, english_on, kb, resttime);
    end
    restcount = 0;
else
    restcount = restcount + 1;
end
end