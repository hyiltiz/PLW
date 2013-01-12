function stripData(matfile)
  % this function aims at minimizing the collected data yet keeping all the valueable info.
  % use for storing the data
  % for analysing, use expandData() for constructing full varialble Trials

  addpath('./data/');
  try
    load(matfile);
  catch
    disp(['Cannot load file ' matfile]);
    return; %do not do anything if the .mat-file doesn't exist.
  end

  indxcol = 6; % the column used for indexing the trials in variable Trials
  stat = [6 1 4 5 7 8 9 10]; % columns of variable Trials that does not change across a trial;
  dynam = [2 3];

  Condition = Trials([true; any(diff(Trials(:,indxcol)),2)],stat);  %remember only the changing Condition infos;
  % See below for meanings of each colomns in Condition;
  %Condition(:,1) = k; % the k.th trial
  %Condition(:,2)= Trialsequence(k);
  %Condition(:,[3 4]) = moveDirection(k, :);  % direction of walkers
  %Condition(:,5) = iniTactile;
  %Condition(:,[6 7]) = paceRate;
  %Condition(:,8)=xshift;

  %Response = Trials(:,dynam);
  for i=1:max(Trials(:,indxcol));
    Response{i} = Trials(Trials(:,indxcol)==i, dynam);
  end;
  % See below for meanings of each colomns in Response;
  %Response{i} = k; the k.th trial
  %Response{i}(:,1) = prestate;
  %Response{i}(:,2) = GetSecs - iniTimer;
  clear Trials;

  tmp=fieldnames(data);
  uselessfield={'readData'};
  if isfield(data, 'init')  % dotx and such can be regenerated
    uselessfield = [uselessfield; tmp(strmatch('dot', tmp))];
  else
    data.init = solveInit(0, data.dotx, conf, data);
    %Display('Second');
    data.init1= solveInit(180,data.dotx1, conf, data);
    if ~isempty(data.init) & ~isempty(data.init1)
      uselessfield = [uselessfield; tmp(strmatch('dot', tmp))];
    end
  end;
  % plot(a);

  %     clear a;
  %     data.readData.thet=180; data.readData.xyzseq = [1 3 2];
  %     for i=1:round(130/4)+1;
  %         [x y init] = PLWtransform(data.readData, conf.scale1, conf.imagex, i);
  %         a(i,:) = diff([mean(data.dotx1(:, [10 13]) - x(:,[10 13]))],1);
  %     end;

  data = rmfield(data, uselessfield);

  newmatfileName = ['data/', 'Small_', matfile];
  save('-7', newmatfileName,'conf', 'Subinfo','flow','mode','data', 'Response', 'Condition');
  disp([newmatfileName ' created successfully!']);
end
