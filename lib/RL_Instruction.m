function RL_Instruction(w, debug_mode, english_on, kb)
% print out the instructions in different language on the screen.

% english_on = 1;
% debug_mode = 1;
% screens=Screen('Screens');
% screenNumber=max(screens);
% [w,wsize]=Screen('OpenWindow',screenNumber,0,[1,1,801,601],[]);

%     mytext = '';
%     tl = fgets(fd);
%     lcount = 0;
%     while (tl~=-1) & (lcount < 48)
%         mytext = [mytext tl];
%         tl = fgets(fd);
%         lcount = lcount + 1;
%     end
%     fclose(fd);
%     mytext = [mytext char(10)];
%     [nx, ny, bbox] = DrawFormattedText(w, mytext, 10, 20, 0, 48 );

% Select specific text font, style and size:
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);

Screen('TextFont',w, 'Sans');
Screen('TextStyle', w);
if debug_mode
    Screen('TextSize',w, 18);
    if english_on
        %         DrawFormattedText(w, sprintf(['In this exprtiment, you will be shown two walking dots, in green\n\n' ...
        %             'and red, each in the shape of a walking man. Please use an arrow \n\n' ...
        %             'key to point out the RED Walker''s walking direction as QUICK as \n\n' ...
        %             'as possible, while your reaction should also be CORRECT.\n\n\n\n' ...
        %             'Press any key if you understood the instructions above and begin \n\n' ...
        %             'the experiment. Otherwise press ESCAPE to quit!']), 25, 100, [255, 255, 255]);
        DrawFormattedText(w, sprintf(['In this exprtiment, you will be shown two walking dots, in green\n\n' ...
            'and red, each in the shape of a walking man. Please use an arrow \n\n' ...
            'key to point out the RED Walker''s walking direction as QUICK as \n\n' ...
            'as possible, while your reaction should also be CORRECT.\n\n\n\n' ...
            'Press any key if you understood the instructions above and begin \n\n' ...
            'the experiment. Otherwise press ESCAPE to quit!']), 25, 100, [255, 255, 255]);
        
    else
        DrawFormattedText(w, sprintf(['��ʵ���У���ῴ�����������еĵ㣬�ֱ�ʺ�ɫ����ɫ�����Ρ�\n\n' ...
            '���ֿ���׼������Ӧ�����Ҽ�ָ����ɫ�����ߵķ���\n\n\n' ...
            '����������ָ����밴�����ʼʵ�飬�����밴ESC���˳���']), 25, 170, [255, 255, 255]);
    end
    
else
    if english_on
        Screen('TextSize',w, 22);
        DrawFormattedText(w, sprintf(['In this exprtiment, you will be shown two walking dots, in green\n\n' ...
            'and red, each in the shape of a walking man. Please use an arrow \n\n' ...
            'key to point out the RED Walker''s walking direction as QUICK as \n\n' ...
            'as possible, while your reaction should also be CORRECT.\n\n\n\n' ...
            'Press any key if you understood the instructions above and begin \n\n' ...
            'the experiment. Otherwise press ESCAPE to quit!']), 80, 250, [255, 255, 255]);
    else
        DrawFormattedText(w, sprintf(['��ʵ���У���ῴ�����������еĵ㣬�ֱ�ʺ�ɫ����ɫ�����Ρ�\n\n' ...
            '���ֿ���׼������Ӧ�����Ҽ�ָ����ɫ�����ߵķ���\n\n\n' ...
            '����������ָ����밴�����ʼʵ�飬�����밴ESC���˳���']), 95, 470, [255, 255, 255]);
        
    end
end
Screen('Flip', w);
[~, keyCode] = KbStrokeWait;
if keyCode(kb.escapeKey) %quit program
    sca;
    error('Experiment aborted manually!');
end
end
