## Copyright (C) 2012 ھۆرمەتجان يىلتىز
## 
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## stripData

## Author: ھۆرمەتجان يىلتىز <hyiltiz@ThPad>
## Created: 2012-12-07

function [ ret ] = stripData (matfile)
% this function aims at minimizing the collected data yet keeping all the valueable info.
% use for storing the data
% for analysing, use expandData() for constructing full varialble Trials

addpath('./data/');
try
  load(matfile);
catch
  return; %do not do anything if the .mat-file doesn't exist.
end

indxcol = 6; % the column used for indexing the trials in variable Trials
stat = [6 1 4 5 7 8 9]; % columns of variable Trials that does not change across a trial;
dynam = [2 3];

Condition = Trials([true; any(diff(Trials(:,indxcol)),2)],stat);  %remember only the changing Condition infos;
% See below for meanings of each colomns in Condition;
%Condition(:,1) = k; % the k.th trial
%Condition(:,2)= Trialsequence(k);
%Condition(:,[3 4]) = moveDirection(k, :);  % direction of walkers
%Condition(:,5) = iniTactile;
%Condition(:,[6 7]) = paceRate;

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
end
data = rmfield(data, uselessfield);

save(['data/', 'Small_', matfile],'conf', 'Subinfo','flow','mode','data', 'Response', 'Condition');
end
