untilTime = 5
secs = -inf;
ini = GetSecs;
while secs - ini < untilTime
    [isDown, secs, keyCode, deltaSecs] = KbCheck([]);
    if isDown | (secs - ini >= untilTime) %#ok<OR2>
        disp('time up!');disp(secs - ini);
        return;
    end

    % Wait for yieldInterval to prevent system overload.
    secs = WaitSecs('YieldSecs', 0.005);
end