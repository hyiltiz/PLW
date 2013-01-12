function resultFlag = checkVersion()
  % Check if your software version is supported. You will try run the program
  % yourself, commenting out this function from the main program, such as
  % RL_PLW(), but you may encounter some incompatibility.

  resultFLag = 1;
  if IsOctave
    version_code = version;
    if str2num(version_code(1:2:end)) < 324
      resultFlag = 0;
      error('GNU/Octave version is too old. Your version is not supported. You will comment out checkVersion() to try it out.');
    end
  else
    version_code = version;
    if str2num(version_code(end-5:end-2)) < 2009
      resultFlag = 0;
      error('Matlab version is too old. Your version is not supported. You will comment out checkVersion() to try it out.');
    end

  end
end
