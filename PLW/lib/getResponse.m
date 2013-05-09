function [Trials, prestate, response, iniTimer, isquit, isresponse ] = ...
    getResponse(tactile_on, iniTimer, dioIn, prestate, response,...
    Trialsequence, k, moveDirection, kb, isresponse, isquit, Trials)
% Capture all teh reaction input from pedal, if tactile decises can be
% found, or from the keyboard otherwise.

if tactile_on
    % acquire responce with the pedal
    if GetSecs-iniTimer==0.5+rand;
        beep; % start acquring response
    end
    
    getvalue(dioIn);
    switch  sum(getvalue(dioIn))
        case 1
            response=1; % right response
        case 2
            response=0;
        case 3
            response=2; % left response
    end
    
    if  response~=prestate
        Trials(k,3) = GetSecs - iniTimer;
        Trials(k,1)=Trialsequence(k);
        Trials(k,2) = prestate;
        Trials(k,[4 5]) = moveDirection(k, :);  % direction of walkers
        iniTimer = GetSecs;
        prestate=response;
        isresponse = 1;
    end
    
else  % use keyboard then
    % acquire responce
    [ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if (keyCode(kb.leftArrow) || keyCode(kb.rightArrow))
            Trials(k,3) = GetSecs-iniTimer;
            Trials(k,1) = Trialsequence(k);
            Trials(k,2) = keyCode(kb.leftArrow) + keyCode(kb.rightArrow)*2 + keyCode(kb.upArrow)*3 + keyCode(kb.downArrow)*4;
            Trials(k,[4 5]) = moveDirection(k, :);  % direction of walkers
            %                 PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
            isresponse = 1;
            %         break;
            return;
        elseif any(keyCode(kb.escapeKey)) %quit program
            isquit = 1;
            error('Manually pressed ESC button: quit!');
        elseif (keyCode(kb.upArrow) || keyCode(kb.downArrow))
            % allow pressing this BY MISTAKE, as will most probably happen
            % due to the closeness of the arrow keys
        else
            % ignore other stuff!
            error(['###################################', 'Do not play around!, PLEASE. ', 'You have to do ALL OVER AGAIN, ', 'as you HAVE BEEN WARNED earlier!', '###################################']);
        end
    end
    
    % Do not clear buffer, or if the user holds any key pressed on, then
    % all the display will wait until the key was released.
    %     if keyIsDown; while KbCheck; end; end; %clear buffer
end
end