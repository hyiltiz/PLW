function [Trials, prestate, response, iniTimer, isquit, isresponse, nresp ] = ...
    getResponseU(tactile_on, iniTimer, dioIn, prestate, response,...
    Trialsequence, k, moveDirection, kb, isresponse, isquit, Trials, nresp, paceRate, iniTactile, isRT, xshift, islastResponse)
% Capture all the reaction input from pedal, if tactile decises can be
% found, or from the keyboard otherwise.
% Display(nresp);

if tactile_on
    % acquire responce with the pedal
    getvalue(dioIn);
    switch  sum(getvalue(dioIn))
        case 1
            response=1; % right response
        case 2
            response=0;
        case 3
            response=2; % left response
    end
    
else  % use keyboard then
    if islastResponse
        [~, keyCode] = KbWait; %wait for the response
        responseFlag = keyCode(kb.leftArrow) || keyCode(kb.rightArrow);
    else
        [ keyIsDown, ~, keyCode ] = KbCheck;
        responseFlag = keyIsDown & (keyCode(kb.leftArrow) || keyCode(kb.rightArrow));
    end
    
    if responseFlag
        response = keyCode(kb.rightArrow) + keyCode(kb.leftArrow)*2;
        
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

if  isRecordResponse(isRT, prestate, response, islastResponse, isresponse)
    Trials(nresp,3) = GetSecs - iniTimer;
    Trials(nresp,1)=Trialsequence(k);
    Trials(nresp,2) = prestate;
    Trials(nresp,[4 5]) = moveDirection(k, :);  % direction of walkers
    Trials(nresp,6) = k;
    Trials(nresp,7) = iniTactile;
    Trials(nresp,[8 9]) = paceRate;
    Trials(nresp, 10) = xshift;
    % PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
    iniTimer = GetSecs;
    prestate=response;
    isresponse = 1;
    nresp = nresp + 1;
end

% Presss ESC for quitting!
%     [ keyIsDown, ~, keyCode ] = KbCheck;
%     if keyIsDown
%         if any(keyCode(kb.escapeKey)) %quit program
%             isquit = 1;
%             error('Manually pressed ESC button: quit!');
%         end
%     end

% acquire responce

% Do not clear buffer, or if the user holds any key pressed on, then
% all the display will wait until the key was released.
%     if keyIsDown; while KbCheck; end; end; %clear buffer
end

