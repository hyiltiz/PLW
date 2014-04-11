function [responseC, t] =  oneItem(ques, i, w, wsize, kb, mode, conf, sign)
scalemap = ['1: ' ques.scales{i, 1}];
for j=2:size(ques.scales, 2)
    scalemap = [scalemap, '  ', num2str(j) ': ', ques.scales{i, j}];
end


if mode.constantInstr_on % show isntr every screen
    DrawFormattedText(w, [ques.instr{i} '\n\n' sign.lang.rule], 0, 30, [255, 255, 255, 255], inf);
else
    DrawFormattedText(w, ques.target{i}, 'center', wsize(4)/2-100, 255, inf);
end

% kbCode = Instruction(ques.items{i}, w, wsize, 0, 1, kb, 5 ,1, 0);
DrawFormattedText(w, [ques.items{i} '\n\n\n' scalemap], 'center', 'center', [255 255 255], inf);

Screen('Flip',w);

preT = GetSecs;
[kbCode, postT] = pedalWait(0, inf,kb);
% [t, kbCode] = KbWait([],2);

kbName = KbName(kbCode);
responseC = kbName(1);
t = postT - preT;
end