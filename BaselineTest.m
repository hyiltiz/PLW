function BaselineTest()
  % Baseline test

  % time setting vatiables
  conf.flpi               =  0.01;        % each frame is set to 20ms (the monitor's flip interval is 16.7ms)
  conf.trialdur           =  70;          % duration time for every trial
  conf.repetitions        =  1;           % repetition time of a condition
  conf.resttime           =  30;          % rest for 30s
  conf.restpertrial       =  1;           % every x trial a rest

  % state control variables
  mode.mirror_on     = 1;  % use mirror rather that spectacles for binacular rivalry
  mode.many_on       = 0;  % the task is the majority of dots the participant saw
  mode.debug_on      = 0;  % default is 0; 1 is not to use full screen, and skip the synch test
  mode.once_on       = 3;  % pass in 3 for demo with all three trial
  mode.baseline_on   = 0;  % baseline trial, without visual stimuli

  % Call the main function RL_PLW()
  RL_PLW(conf, mode);
