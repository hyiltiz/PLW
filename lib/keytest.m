
% unified key definitions
kb = keyDefinition();

KbWait;
[ keyIsDown, ~, keyCode ] = KbCheck;
if keyIsDown
  if (keyCode(kb.leftArrow) || keyCode(kb.rightArrow))
    %         Trials(k,3) = GetSecs-iniTimer;
    %         Trials(k,1) = Trialsequence(k);
    %         Trials(k,2) = keyCode(kb.leftArrow) + keyCode(kb.rightArrow)*2 + keyCode(kb.upArrow)*3 + keyCode(kb.downArrow)*4;
    %         Trials(k,[4 5]) = moveDirection(k, :);  % direction of walkers
    %         %                 PsychPortAudio('Stop', pahandle, 2);    %stop sound with discarding process
    %         isresponse = 1;
    %         break;
    display(KbName(keyCode));
    return;
  elseif any(keyCode(kb.escapeKey)) %quit program
    display(KbName(keyCode));
    isquit = 1;
    error('Manually pressed ESC button: quit!');
  else
    display(KbName(keyCode));
    % ignore other stuff!
    error('Do not play around!');
  end
end
if keyIsDown; while KbCheck; end; end; %clear buffer
