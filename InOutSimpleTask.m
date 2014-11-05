function InOutSimpleTask(is_once_on)
% In-Out simple task, pass in 1 for demo with only one trial, or just run it with no input;
% binocular 2 PLWs with simple tactile stimuli:
% back1=back2, front1=front2; front1 = back1+ 15(std~conf)


% time setting vatiables
conf.flpi               =  0.02;        % each frame is set to 20ms (the monitor's flip interval is 16.7ms)
conf.trialdur           =  70;          % duration time for every trial
conf.repetitions        =  5;           % repetition time of a condition
conf.resttime           =  30;          % rest for 30s
conf.restpertrial       =  5;           % every x trial a rest
conf.tiltangle          =  7;           % tilt angle for simulating 3D stereo display
conf.xshift             =  0;           % shift PLW for using mirror, see mode.mirror_on
conf.shadowshift        = .4;           % distance between PLWs and their twin shadows
conf.doubleTactileDiff  = 10 ;          % flips between taps on one tactile stimuli (double tactile);0 to disable
conf.color              = {[128 128 128],[128 128 128],[128 128 128]}; %2014/11/05

% state control variables
mode.simpleInOut_on= 1;  % simple InOut exp, with the same tactile stimuli for both foot
mode.colorbalance_on    = 1;  % balance the color of the target PLW, which is by default red
mode.mirror_on     = 1;  % use mirror rather that spectacles for binacular rivalry
mode.many_on       = 0;  % the task is the majority of dots the participant saw
mode.debug_on      = 0;  % default is 0; 1 is not to use full screen, and skip the synch test
mode.english_on    = 0;  % use English for Instructions etc., 0 for Chinese(not supported for now!)

if nargin > 0
    mode.once_on       = is_once_on;  % only one trial, used for demostration before experiment
else
    mode.once_on       = 0;  % only one trial, used for demostration before experiment
end

% Call the main function RL_PLW()
RL_PLW(conf, mode);
end
