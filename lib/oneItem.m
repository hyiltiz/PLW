function [responseC, t] =  oneItem(ques, i, w, wsize, kb)
scalemap = ['1: ' ques.scales{i, 1}];
for j=2:size(ques.scales, 2)
    scalemap = [scalemap, '  ', num2str(j) ': ', ques.scales{i, j}];
end

DrawFormattedText(w, ques.instr{i}, 0, 80, [255, 255, 255, 255]);
Screen('DrawText', w, ['请用键盘上数字 1 到 ', num2str(size(ques.scales, 2)), ' 作出反应：'], 0, 300, [255, 255, 255, 255]);
Screen('DrawText', w, scalemap, 0, 330, [255, 255, 255, 255]);

% kbCode = Instruction(ques.items{i}, w, wsize, 0, 1, kb, 5 ,1, 0);
DrawFormattedText(w, ques.items{i}, 'center', 450, [255 255 255], 32);
Screen('Flip',w);

[kbCode, t] = pedalWait(0, inf,kb);
% [t, kbCode] = KbWait([],2);

kbName = KbName(kbCode);
responseC = kbName(1);
end