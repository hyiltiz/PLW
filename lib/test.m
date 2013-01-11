function new = updateStruct(old, new)
% update the Sturcture with new field values

for i=1:length(fieldnames(old))
setfield(new, fieldnames(old){i}, getfield(old, fieldnames(old){i}))
end
