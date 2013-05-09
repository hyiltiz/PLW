function Subinfo= getSubInfo()
    if ~ IsOctave
        promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)'};
        defaultParameters = {'PL_PLW_default', '25','F', 'R'};
        Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
        if isempty(Subinfo)
            error('Subject information not entered!');
        end;
    else
        % This is for octave
        promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)'};
        defaultParameters = {'PL_PLW_default', '25','F', 'R'};
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
