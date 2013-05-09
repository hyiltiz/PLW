function [Trialsequence, Trials] = genTrial(repetitions, columns)
% generate experiment trial conditions according to the experiment

rhythmtype= [1 2 3 4];  % condition type
trialno = repmat(rhythmtype,1, repetitions);
Trialsequence=trialno(randperm(length(trialno))); % condition
Trials =zeros(length(Trialsequence*3), columns);% for recording results

end