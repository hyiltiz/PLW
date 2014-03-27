function testflag = isRecordResponse(isRT, prestate, response, isLastResponse, isresponse)
  % check whether to record response on the very occation given the response last time
  % PRESTATE, and the current response RESPONSE, based on if the variable is Reaction
  % time RT or duration time.
  % testflag=True -> record the time, condition and other stuff;

  if isRT
    if isLastResponse
      % For the last response, be sure to at least record the response,
      % though the Reaction Time is TOO BIG then!
      testflag = ~isresponse;
    else
      % this is the normal reation of the participant, responsing as
      % quick as possible
      testflag = response;  %as long as any pressed for Reaction time, after this it
      %will be aborted
    end
  else
    % this is for recording the duration time of the response

    %only begin recording when there is change in the response
    testflag = response ~= prestate;  %record the difference for duration time, so
    %and go on recording if holding on the original key/pedal

    % if this is the last response of the trial, record it. No more
    % response is coming for a change!
    if isLastResponse
      testflag = response>0;  %as long as any pressed for the last response
    end
  end
end
