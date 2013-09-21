function PLWviewer(varargin)
%PLWviewer DISPLAYS POITLIGHT WALKER ANIMATION
%   PLWviewer(filename, scale, imagex, mapping) does the trick.
%   filename: input data file
%   scale: animation noise scale
%   imagex: image size
%   mapping: display goup control

%   Written by Lihan Chen, Ph.D, Department of Psychology, Peking University
%   Merged in onePLW, PLWtransform modification to optimaze code
%   by Hormetjan, Department of Psychology, Peking University
%% Input Control
error(nargchk(0,4,nargin));
% [~,args,nargs] = axescheck(varargin{:});
addpath('./data', './lib', './resources');

filename = '07_01.data3d.txt';% input data file
scale1 = 20;
% image size
imagex=250;
%it appears the joint numbers are arranged in a series like 26 27 28.
%Order of joints: head; l shoulder; l elbow, l hand; r shoulder; r elbow; r
%hand; l hip; l knee; l foot; r hip; r knee; r foot;
% 0 for head, 1 for left parts and 2 for right parts of PLW.
mapping = [0 1 1 1 2 2 2 1 1 1 2 2 2];

if nargin > 0, filename = varargin{1}; end
if nargin > 1, scale1 = varargin{2}; end
if nargin > 2, imagex = varargin{3}; end
if nargin > 3, mapping = varargin{4}; end
is_Octave = ismember(exist('OCTAVE_VERSION', 'builtin'), [102, 5]);
%% Ggenerate pointlight display data using 3D coordinates file
% reading in bvh files
readData = PLWread(filename);

% calculate the discrete dots along each limb
readData.thet = 30;  %to rotate along the first axis
readData.xyzseq = [1 3 2];  %to rotate across xyz
[dotx, doty] = PLWtransform(readData, scale1, imagex, -1);

%% Make display
figure;
if is_Octave
    % Octave, does not support getframe;
else
    clear F;
end
count=0;
xrange = [min(min(dotx))-50, max(max(dotx))+50];
yrange = [min(min(doty))-80, max(max(doty))+80];
gcolor = {'black', 'blue', 'red'};

% uncomment this for loop to check if the original data is loopable.
% for times = 1:3
length = 1000;
dotloop = modloop(1:length, size(dotx,1));

for f=1:5:length  % two for accuracy
    count=count+1;
    % signal parts
    for grouping = 0 : 2
        h = plot(dotx(dotloop(f),mapping == grouping),...
            doty(dotloop(f),mapping == grouping),'o');
        set(h,'MarkerSize',6);
        set(h,'MarkerFaceColor',gcolor{grouping + 1});
        set(h,'MarkerEdgeColor',gcolor{grouping + 1});
        hold on;
    end
    axis equal;
    axis([xrange(1) xrange(2) yrange(1) yrange(2)]);
    %     pause(0.02);
    if is_Octave
        % Octave, does not support getframe;
    else
        F(count)=getframe;
    end
    refresh;
    hold off;
end;
% end
if is_Octave
    % Octave, does not support getframe;
else
    %     movie2avi(F,sprintf('%s.pl2.avi',filename),'fps',20,'compression','None');
end
close;
end
