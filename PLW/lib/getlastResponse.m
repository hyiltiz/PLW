function [Trials, prestate, response, iniTimer, isquit, isresponse ]  = ...
    getlastResponse(tactile_on, iniTimer, dioIn, prestate, response,...
    Trialsequence, k, moveDirection, kb, isresponse, isquit, Trials)
% this function captures the last reaction, which might not be captured
% during the trial session.

if tactile_on 
    getvalue(dioIn);  %% the following to capture the last data
    switch  sum(getvalue(dioIn))
        case 1
            response=1; % right response
        case 2
            response=0;
        case 3
            response=2; % left response
    end
    
    if  response > 0
        Trials(k,3) = GetSecs - iniTimer;
        Trials(k,1)=Trialsequence(k);
        Trials(k,2) = prestate;
        Trials(k,[4 5]) = moveDirection(k, :);  % direction of walkers
        iniTimer = GetSecs;
        prestate=response;
        isresponse = 1;
    end
        
else  % use keyboard then
    while ~isresponse  %well get response then, better late than never
        [~, keyCode] = KbWait; %wait for the response
        if keyCode(kb.leftArrow) || keyCode(kb.rightArrow)
            Trials(k,3) = GetSecs-iniTimer;
            Trials(k,1) = Trialsequence(k);
            Trials(k,2) = keyCode(kb.leftArrow) + keyCode(kb.rightArrow)*2 + keyCode(kb.upArrow)*3 + keyCode(kb.downArrow)*4;
            Trials(k,[4 5]) = moveDirection(k, :);  % direction of walkers
            %                 PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
            isresponse = 1;
        end
    end
end
end