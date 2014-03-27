function [ ret ] = listDatPro (tmp)
% list data properties
%tmp=ls('./Small_*.mat');
%for i=1:size(tmp,1);
%  dat=load(strtrim(tmp(i,:)));
load(strtrim(tmp));
%keyboard;
%Display([num2str(isfield(dat.data, {'init', 'init1', 'dotx', 'dotx1', 'readData'})), strtrim(tmp(i,:))]);
save('-7', ['./tmp/' strtrim(tmp)]);
%clear;
%end
disp(pwd);
end