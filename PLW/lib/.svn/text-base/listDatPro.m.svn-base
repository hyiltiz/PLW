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

## listDatPro

## Author: ھۆرمەتجان يىلتىز <hyiltiz@ThPad>
## Created: 2012-12-06

function [ ret ] = listDatPro ()
tmp=ls('*.mat');for i=1:size(tmp,1);dat=load(strtrim(tmp(i,:)));disp([num2str(size(dat.flow.Trialsequence)) '    '  strtrim(tmp(i,:))]);end
endfunction
