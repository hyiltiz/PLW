function loop = lagloop(series, T)
  % used for looping over series stopping on each item T tiems

  if size(series, 1) == 1
    %good
  else
    series = series';
  end

  loop = reshape(repmat(series, T, 1), 1, T*numel(series));
end
