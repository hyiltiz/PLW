function testflag = isRecordResponse(isRT, prestate, response)
% check whether to record response on the very occation given the response last time
% PRESTATE, and the current response RESPONSE, based on if the variable is Reaction 
% time RT or duration time. 

if isRT
  testflag = response;  %as long as any pressed for Reaction time, after this it
  %will be aborted
else
  testflag = response ~= prestate;  %record the difference for duration time, so
  %go on recording if holding on the original key/pedal
end
  end
