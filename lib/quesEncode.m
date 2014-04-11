function [ques, responseM] = quesEncode(ques, responseC)
% convect and calculate output according to response chars and ques.encode
% result is ques.encdoe.scale{:,3} and responseM

responseM = str2double(responseC);
if ~isempty(ques.encode.inv)
    responseM(ques.encode.inv) = size(ques.scales, 2) + -1*responseM(ques.encode.inv);
end

for ipar=1:size(ques.encode.scale,1)
    ques.encode.scale{ipar,3} = sum(responseM(ques.encode.scale{ipar,2}));
end
end