function [Trials, prestate, response, iniTimer, isquit, isresponse, nresp ] = ...
    getResponseU(tactile_on, iniTimer, dioIn, prestate, response,...
    Trialsequence, k, moveDirection, kb, isresponse, isquit, Trials, nresp, paceRate, iniTactile, isRT)
% Capture all the reaction input from pedal, if tactile decises can be
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
    
    
    if  isRecordResponse(isRT, prestate, response)
        Trials(nresp,3) = GetSecs - iniTimer;
        Trials(nresp,1)=Trialsequence(k);
        Trials(nresp,2) = prestate;
        Trials(nresp,[4 5]) = moveDirection(k, :);  % direction of walkers
        Trials(nresp,6) = k;
        Trials(nresp,7) = iniTactile;
        Trials(nresp,[8 9]) = paceRate;
        iniTimer = GetSecs;
        prestate=response;
        isresponse = 1;
        nresp = nresp + 1;
    end
    
    % Presss ESC for quitting!
    [ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if any(keyCode(kb.escapeKey)) %quit program
            isquit = 1;
            error('Manually pressed ESC button: quit!');
        end
    end
    
else  % use keyboard then
    % acquire responce
    [ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown & (keyCode(kb.leftArrow) || keyCode(kb.rightArrow))
        response = keyCode(kb.leftArrow) + keyCode(kb.rightArrow)*2 + keyCode(kb.upArrow)*3 + keyCode(kb.downArrow)*4;
        
        if  isRecordResponse(isRT, prestate, response)
            Trials(nresp,3) = GetSecs-iniTimer;
            Trials(nresp,1) = Trialsequence(k);
            Trials(nresp,2) = response;
            Trials(nresp,[4 5]) = moveDirection(k, :);  % direction of walkers
            Trials(nresp,6) = k;
            Trials(nresp,7) = iniTactile;
            Trials(nresp,[8 9]) = paceRate;
            % PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
            iniTimer = GetSecs;
            prestate=response;
            isresponse = 1;
            nresp = nresp + 1;
            
            %         break;
            return;
        end
    elseif any(keyCode(kb.escapeKey)) %quit program
        isquit = 1;
        error('Manually pressed ESC button: quit!');
    elseif (keyCode(kb.upArrow) || keyCode(kb.downArrow))
        % allow pressing this BY MISTAKE, as will most probably happen
        % due to the closeness of the arrow keys
    else
        % ignore other stuff!
        %         error(['###################################', 'Do not play around!, PLEASE. ', 'You have to do ALL OVER AGAIN, ', 'as you HAVE BEEN WARNED earlier!', '###################################']);
    end
end

% Do not clear buffer, or if the user holds any key pressed on, then
% all the display will wait until the key was released.
%     if keyIsDown; while KbCheck; end; end; %clear buffer
end

