function [ ret ] = expandData (matfile)
  % DEPRECATED! PLEASE DO NOT USE THIS FILE. SUPPORT FOR THIS FILE HAS BEEN TERMINATED
  % DUE TO INCONSISTANCY IN TRIALS
  %
  % this function is a help function for analysing mat files generated using stripData(), in order to construct full varialble Trials, and somehting more
  %
  % run expandData('Smallxxxx.mat') in the root directory
  % or expandData('all') to convert all of the Small data to normal .mat data files with Trials matrix
  addpath('./data/');

  if strcmp('all', matfile)
    % expand all the Small data in ./data
    cd data;
    smalls = ls('Small*.mat');
    cd ..;
  else
    % only expand the data required
    matfiles = matfile;
  end

  for filenum=1:size(smalls,1)
    matfile = strtrim(smalls(filenum, :));

    try
      disp(matfile);
      if strmatch('Small', matfile);load(matfile);whos,end
    catch
      ret = -1;
      return; %do not do anything if the .mat-file doesn't exist.
    end

    % See below for meanings of each colomns in Condition;
    %Condition(:,1) = k; % the k.th trial
    %Condition(:,2)= Trialsequence(k);
    %Condition(:,[3 4]) = moveDirection(k, :);  % direction of walkers
    %Condition(:,5) = iniTactile;
    %Condition(:,[6 7]) = paceRate;
    %Condition(:,8)=xshift;

    %Response = Trials(:,dynam);
    % See below for meanings of each colomns in Response;
    %Response{i} = k; the k.th trial
    %Response{i}(:,1) = prestate;
    %Response{i}(:,2) = GetSecs - iniTimer;

    %Trials(nresp,3) = GetSecs - iniTimer;
    %Trials(nresp,1)=Trialsequence(k);
    %Trials(nresp,2) = prestate;
    %Trials(nresp,[4 5]) = moveDirection(k, :);  % direction of walkers
    %Trials(nresp,6) = k;
    %Trials(nresp,7) = iniTactile;
    %Trials(nresp,[8 9]) = paceRate;

    Trials = [];
    for i=1:length(Response);
      iCon = repmat(Condition(i,:), length(Response{i}), 1);
      Trials = [Trials; [iCon(:,2), Response{i}, iCon(:,[3 4 1 5 6 7 8])]];
    end

    % reading in bvh text files for raw data
    data.readData = PLWread(data.visualfilename);
    if isfield(data, 'init')  % dotx and such can be regenerated
      % Generate the data for plotting Point Light Walkers
      data.readData.thet = 0;  %to rotate along the first axis
      data.readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default
      [data.dotx  data.doty data.init] = PLWtransform(data.readData, conf.scale1, conf.imagex, data.init);

      data.readData.xyzseq = [1 3 2];  %to rotate across xyz
      data.readData.thet = 180;  %to rotate along the first axis
      [data.dotx1 data.doty1 data.init] = PLWtransform(data.readData, conf.scale1, conf.imagex, data.init1);
    end

    matfile = matfile(7:end);  % strip the prefix Small
    save('-7', ['data/', 'Expanded_', matfile],'Trials','conf', 'Subinfo','flow','mode','data', 'Response', 'Condition');
  end
end
