% This script is for testing the part of code that deals with controlling
% the PLW's walking pace. Since the original data is not spatially
% sysmmetric, creating new data by scanning it within a loop may cause the
% new data not a smooth one. Use this script to find a way for avoid it.
thepwd = pwd;
if strcmp(thepwd(end-2:end), 'lib')
cd ..;
end
addpath('data', 'lib', 'resources');

for i = 1:10
filename = '07_01.data3d.txt';% input data file
scale1 = 20;
readData = PLWread(filename);
imagex=250;  % image size
T = 130;
readData.thet = 0;  %to rotate along the first axis
readData.xyzseq = [1 3 2];  %axis rotation, [1 3 2] by default

[dotx  doty ] = PLWtransform(readData, scale1, imagex);

initPosition = Randi(round(T/4),[2 1]);
paceRate = Randi(3,[2 1]);
floop = 1:round(length(dotx));% 2 for accuracy, and T for period

[lefttouch righttouch] = touchgroundtest(dotx, initPosition(1), paceRate(1), floop);
end
close all;
