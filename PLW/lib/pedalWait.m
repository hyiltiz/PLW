function pedalWait(tactile_on, time, kb)
if tactile_on
    dioIn=digitalio('parallel','LPT1'); % DAQ, open the LPT1 port
    addline(dioIn,10:12,'in'); % for footswitch input.
    secs = -inf;
    ini = GetSecs;
    while secs - ini < time
        if sum(getvalue(dioIn)) ~= 2 % play if not pressed pedal
            return;
        end
        
        % Wait for .01 to prevent system overload.
        secs = WaitSecs('YieldSecs', .01);
        manualAbort(kb);
    end
else
    % wait for any key press to go on, unless breaking out by calling ESC
    [~, keyCode] = KbStrokeWait([], time);
    
    if keyCode(kb.escapeKey) %quit program
        sca;
        error('Experiment aborted manually!');
    end
    end
