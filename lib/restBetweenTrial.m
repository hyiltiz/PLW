function restcount = restBetweenTrial(restcount, resttime, pertrial, w, wsize, debug_mode, english_on, kb, skipFile, tactile_on)
  % take a rest after some trials

  isSkip = 1;
  if ~isSkip
    debug_mode = 1;
    screens=Screen('Screens');
    screenNumber=max(screens);
    english_on = 1;
    restcount = 1;
    pertrial=1;
    kb = keyDefinition();
    resttime=5;
    skipFile=0;
    tactile_on=0;
    if debug_mode
      [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    else
      [w,wsize]=Screen('OpenWindow',screenNumber,0);
    end
  end

  if restcount == pertrial
    if english_on
      Display(resttime);
      Instruction(['Please rest for ' num2str(resttime) ' seconds.\n\nIf you want to proceed, press any button.'], w, wsize, debug_mode, english_on, kb, resttime, skipFile, tactile_on);
    else
      Instruction(['请休息 ' num2str(resttime) ' 秒。\n\n如果希望继续，请按任意键继续。'], w, wsize, debug_mode, english_on, kb, resttime, skipFile, tactile_on);
    end
    restcount = 1;
  else
    restcount = restcount + 1;
  end
end
