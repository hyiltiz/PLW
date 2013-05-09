function [ ret ] = listDatPro ()
tmp=ls('./data/Small*.mat');
for i=1:size(tmp,1);
  dat=load(strtrim(tmp(i,:)));
  %keyboard;
  Display([num2str(isfield(dat.data, {'init', 'init1', 'dotx', 'dotx1', 'readData'})), strtrim(tmp(i,:))]);
end
disp(pwd);
end
