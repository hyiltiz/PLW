function DirectionTask(is_once_on)
% Direction task, pass in 1 for demo with only one trial, or just run it with no input;

% time setting vatiables
conf.flpi               =  0.02;        % each frame is set to 20ms (the monitor's flip interval is 16.7ms)
conf.trialdur           =  2;          % duration time for every trial
conf.repetitions        =  5;           % repetition time of a condition
conf.resttime           =  30;          % rest for 30s
conf.restpertrial       =  1;           % every x trial a rest
conf.lagFlip            =  2;           % every x Flip change a noise

% state control variables
mode.mirror_on     = 1;  % use mirror rather that spectacles for binacular rivalry
mode.many_on       = 0;  % the task is the majority of dots the participant saw
mode.debug_on      = 0;  % default is 0; 1 is not to use full screen, and skip the synch test
if nargin > 0
    mode.once_on       = is_once_on;  % only one trial, used for demostration before experiment
else
    mode.once_on       = 0;  % only one trial, used for demostration before experiment
    
end

% Call the main function RL_PLW()
RL_PLW(conf, mode);
