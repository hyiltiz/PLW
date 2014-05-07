function [ques ] = StaticChoice(questionaire, mode, conf)

if nargin < 2
    mode.debug_on = 0;
    mode.constantInstr_on = 0;
    mode.english_on = 0;
    mode.recordImage = 0;
    conf.instrWait = 2;
    conf.byetime = 3;
end
mode.recordImage = 0;
ques = quesDB(questionaire);

sign.en.bye  = ['Thanks for your participation, goodbye!'];
sign.en.pass = ['Passed! Please continue to the next experiment.'];
sign.en.press= ['Press any key to continue'];
sign.en.miss = ['Some answers to the following questions cannot be identified. \nAnswer again according to the requirements.'];
sign.en.rule = ['Please use keys 1 to ', num2str(size(ques.scales, 2)), ' to response. And do NOT press any other key.'];
sign.zh.bye  = ['感谢您的参与，再见！'];
sign.zh.pass = ['测试通过！请进入下一个实验。'];
sign.zh.press= ['请按任意键以继续'];
sign.zh.miss = ['以下问题的答案不符合要求。请根据要求重新填写'];
sign.zh.rule = ['请用键盘上数字 1 到 ', num2str(size(ques.scales, 2)), ' 作出反应（请不要按其它键）。'];

if mode.english_on
    sign.lang = sign.en;
else
    sign.lang = sign.zh;
end



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
    Screen('Preference', 'TextAntiAliasing', 1);
    
    responseC=cell(numel(ques.items),1);
    restime=zeros(numel(ques.items),1);
    
    for i = 1:length(ques.items)
        %         whichtitle = find(cell2mat(ques.title(:,1))==i>0, 1);
        if ~mode.constantInstr_on && sum(cell2mat(ques.title(:,1))==i>0)
            % show instruction as a title for one session if needed
            DrawFormattedText(w, [ques.title{find(cell2mat(ques.title(:,1))==i>0, 1),2} '\n\n' sign.lang.rule], 'center', 'center', 255, inf);
            Screen('Flip', w);
            if mode.recordImage; recordImage(1,1,[questionaire '_instr'] ,w,wsize);end
            WaitSecs(conf.instrWait);
            DrawFormattedText(w, [ques.title{find(cell2mat(ques.title(:,1))==i>0, 1),2} '\n\n' sign.lang.rule '\n\n' sign.lang.press], 'center', 'center', 255, inf);
            Screen('Flip', w);
            if mode.recordImage; recordImage(1,1,[questionaire '_instr'] ,w,wsize);end
            pedalWait(0, inf, kb);
        end
        
        % here we callect each item idx with i; helper function
        [responseC{i}, restime(i)] =  oneItem(ques, i, w, wsize, kb, mode, conf, sign);
        if mode.recordImage; recordImage(1,1,[questionaire],w,wsize);end
    end
    
    % any missing values present?
    ques.response = responseC;
    ques.restime  = restime;
    
    responseM = str2double(responseC);
    isMissing = ~ismember(responseM, 1:size(ques.scales,2));
    if sum(isMissing)
        % tell them to be a good kid
        DrawFormattedText(w, [sign.lang.miss  '\n\n' sign.lang.rule], 'center', 'center', [255 0 0], inf);
        WaitSecs(conf.byetime);
        Screen('Flip', w);
        pedalWait(0, inf, kb);
        
    end
    while sum(isMissing) % we [still] have missing values
        responseM(isMissing) = NaN;
        
        % collect back those missing ones
        idxMissing = find(isMissing);
        for i=idxMissing'
            [responseC{i}, restime(i)] =  oneItem(ques, i, w, wsize, kb, mode, conf, sign);
        end
        responseM = str2double(responseC);
        isMissing = ~ismember(responseM, 1:size(ques.scales,2));
    end
    
    % convect and calculate output according to response chars and ques.encode
    % result is ques.encdoe.scale{:,3} and responseM
    [ques, responseM] = quesEncode(ques, responseC);
    
    
    resultS = '';
    for i=1:size(ques.encode.scale,1)
        resultS = [resultS, ques.encode.scale{i,1} ': ', num2str(ques.encode.scale{i,3}) '  '];
    end
    Display(resultS);
    
    if ques.isShowResult
        Instruction(resultS, w, wsize, 0, 1, kb, 5 ,1, 0);
        WaitSecs(5);
    end
    
    
    if isempty(ques.thrsh)
        % do nothing, just record
    else
        ques.isOK = ~xor(ques.thrsh{3}, (ques.thrsh{2}(1) <= sum(ques.encode.scale{ques.thrsh{1},3}) & sum(ques.encode.scale{ques.thrsh{1},3}) <= ques.thrsh{2}(2)));
        if ques.isOK
            % we wanted results to be inside [a,b] and now they are
            %             Screen('DrawText', w, ['Passed! Please continue to the next experiment.'], 0, 190, [0, 50, 0, 255]);
            DrawFormattedText(w, sign.lang.pass, 'center', 'center', [0, 255, 0, 255]);
        else
            %             Screen('DrawText', w, ['Thanks for your participation!'], 0, 190, [255, 255, 255, 255]);
            DrawFormattedText(w, sign.lang.bye, 'center', 'center', [255, 255, 255, 255]);
        end
        Screen('Flip',w);
        WaitSecs(conf.byetime);
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

boxplot(ques.restime);
end
