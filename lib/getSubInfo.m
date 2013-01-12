function Subinfo= getSubInfo()
  promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)', 'Left eyesight', 'Right eyesight', 'dominant eye (L or R)'};
  defaultParameters = {'RL_PLW_default', '23','F', 'R', '1.0', '1,0', 'L'};
  if ~ IsOctave
    Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
    if isempty(Subinfo)
      error('Subject information not entered!');
    end;
  else
    % This is for octave
    %Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
    Subinfo = cell(length(defaultParameters));
    for i = 1 : length(promptParameters)
      getinput = input(['Please enter ', promptParameters{i}, ':'],'s');
      if isempty(getinput)
        getinput = defaultParameters{i};
      end
      Subinfo{i} = getinput;
    end

    if isempty(Subinfo)
      error('Subject information not entered!');
    end;
  end
end
