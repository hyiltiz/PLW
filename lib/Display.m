function Display(varargin)
  for i = 1:length(varargin)
    s(i) = size(sprintf('%s',varargin{i}),2);
  end

  disp('');
  disp(repmat('+',[1 max(s)]));
  for i = 1:length(varargin)
    %          printf('Input argument %d: ', i);
    disp(varargin{i});
  end
  disp(repmat('+',[1 max(s)]));
end
