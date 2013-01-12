function [Trialsequence, Trials] = genTrial(repetitions, columns)
  % generate experiment trial conditions according to the experiment

  % rhythmtype= [1:2*4];  % condition type, upright vs. upside-down; congurent or not:4
  rhythmtype= fullfact([2,4])';
  trialno = repmat(rhythmtype,1, repetitions);
  % Trialsequence=trialno(randperm(length(trialno))', :); % condition
  Trialsequence=trialno(:, randperm(length(trialno)))'; % condition
  Trials =zeros(length(Trialsequence*3), columns);% for recording results

end
