function new = updateStruct(old, new)
  % update the Sturcture with new field values

  tmp=fieldnames(old);
  for i=1:length(tmp)
    new = setfield(new, tmp{i}, getfield(old, tmp{i}));
  end
