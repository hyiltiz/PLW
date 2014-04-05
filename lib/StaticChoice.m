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
    
    responseC={};
    for i = 1:length(ques.items)
        % here we callect each item idx with i; helper function
        responseC =  oneItem(ques, i, w, wsize, kb, responseC);
    end
    
    % encoding
    ques.response = responseC;
    
    responseM = str2double(responseC);
    isMissing = ~ismember(responseM, 1:size(ques.scales,2));
    while sum(isMissing) % we [still] have missing values
    responseM(isMissing) = NaN;
    
    % collect back those missing ones
    idxMissing = find(isMissing);
    for i=idxMissing
        responseC = oneItem(ques, i, w, wsize, kb, responseC);
    end
    responseM = str2double(responseC);
    isMissing = ~ismember(responseM, 1:size(ques.scales,2));
    end
    
    responseM(ques.encode.inv) = size(ques.scales, 2) + -1*responseM(ques.encode.inv);
    
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
        ques.isOK = ~xor(ques.thrsh{3}, (ques.thrsh{2}(1) <= ques.encode.scale{ques.thrsh{1},3} & ques.encode.scale{ques.thrsh{1},3} <= ques.thrsh{2}(2)));
        if ques.isOK
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
