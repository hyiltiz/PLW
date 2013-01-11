function flag = manualAbort(kb)
% used for manually aborted situations

[ ~, ~, keyCode ] = KbCheck;
if keyCode(kb.escapeKey) %quit program
    flag = 1;
    sca;
    error('Experiment aborted manually!');
end