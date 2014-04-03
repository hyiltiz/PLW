function [ques ] = StaticChoice(questionaire)

mode.debug_on = 0;

ques = quesDB(questionaire);


try
    kb = keyDefinition();
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    if mode.debug_on
        [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    else
        [w,wsize]=Screen('OpenWindow',screenNumber,0);
    end
    ListenChar(2);
    InitializeMatlabOpenGL;
    Screen('Preference', 'TextRenderer', 1);
    %     Screen('Preference','TextEncodingLocale','UTF-8');
    %     Screen('DrawText', w, ques.instr, 0, 150, [255, 255, 255, 255]);
    Screen('Preference', 'TextAntiAliasing', 1);
    
    
    for i = 1:length(ques.items)
        scalemap = ['1: ' ques.scales{i, 1}];
        for j=2:size(ques.scales, 2)
            scalemap = [scalemap, '  ', num2str(j) ': ', ques.scales{i, j}];
        end
        
        DrawFormattedText(w, ques.instr{i}, 0, 80, [255, 255, 255, 255]);
        Screen('DrawText', w, ['请用键盘上数字 1 到 ', num2str(size(ques.scales, 2)), ' 作出反应：'], 0, 300, [255, 255, 255, 255]);
        Screen('DrawText', w, scalemap, 0, 330, [255, 255, 255, 255]);
        
        kbCode = Instruction(ques.items{i}, w, wsize, 0, 1, kb, 5 ,1, 0);
        if sum(kbCode)==0
            [t, kbCode] = KbWait([],2);
        end
        kbName = KbName(kbCode);
        responseC{i} = kbName(1);
    end
    
    % encoding
    ques.response = responseC';
    responseM = str2num(cell2mat(responseC'));
    responseM(ques.encode.inv) = -1*responseM(ques.encode.inv);
    
    for ipar=1:size(ques.encode.scale,1)
        ques.encode.scale{ipar,3} = sum(responseM(ques.encode.scale{ipar,2}));
    end
    
    
    resultS = '';
    for i=1:size(ques.encode.scale,1)
        resultS = [resultS, ques.encode.scale{i,1} ': ', num2str(ques.encode.scale{i,3}) '  '];
    end
    Display(resultS);
    
    if ques.isShowResult
        Instruction(resultS, w, wsize, 0, 1, kb, 5 ,1, 0);
        WaitSecs(5);
    end
    
    save tmp
    if isempty(ques.thrsh)
        % do nothing, just record
    else
        if ~xor(ques.thrsh{3}, (ques.thrsh{2}(1) <= ques.encode.scale{ques.thrsh{1},3} & ques.encode.scale{ques.thrsh{1},3} <= ques.thrsh{2}(2)))
            % we wanted results to be inside [a,b] and now they are
            %             Screen('DrawText', w, ['Passed! Please continue to the next experiment.'], 0, 190, [0, 50, 0, 255]);
            DrawFormattedText(w, ['Passed! Please continue to the next experiment.'], 'center', 'center', [0, 255, 0, 255]);
        else
            %             Screen('DrawText', w, ['Thanks for your participation!'], 0, 190, [255, 255, 255, 255]);
            DrawFormattedText(w, ['Thanks for your participation, goodbye!'], 'center', 'center', [255, 255, 255, 255]);
        end
        Screen('Flip',w);
        KbWait;
    end
    
catch
    Screen('CloseAll');
    Priority(0);
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
    sca
end
sca
ListenChar(0);

end
