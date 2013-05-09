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
error(nargchk(0,3,nargin));
[~,args,nargs] = axescheck(varargin{:});

filename = '07_01.data3d.txt';% input data file
scale1 = 20;
% image size
imagex=250;
%it appears the joint numbers are arranged in a series like 26 27 28.
%Order of joints: head; l shoulder; l elbow, l hand; r shoulder; r elbow; r
%hand; l hip; l knee; l foot; r hip; r knee; r foot;
% 0 for head, 1 for left parts and 2 for right parts of PLW.
mapping = [0 1 1 1 2 2 2 1 1 1 2 2 2];

if nargs > 0, filename = args{1}; end
if nargs > 1, scale1 = args{2}; end
if nargs > 2, imagex = args{3}; end
if nargs > 3, mapping = args{4}; end

%% Ggenerate pointlight display data using 3D coordinates file
% reading in bvh files
readData = PLWread(filename);

% calculate the discrete dots along each limb
readData.thet = 0;  %to rotate along the first axis
readData.xyzseq = [1 3 2];  %to rotate across xyz
[dotx doty] = PLWtransform(readData, scale1, imagex);

%% Make display
figure;
clear F;
count=0;
xrange = [min(min(dotx))-50, max(max(dotx))+50];
yrange = [min(min(doty))-80, max(max(doty))+80];
gcolor = {'black', 'blue', 'red'};

% uncomment this for loop to check if the original data is loopable.
% for times = 1:3
for f=1:5:size(dotx,1)% two for accuracy
        count=count+1;
        % signal parts
        for grouping = 0 : 2
                h = plot(dotx(f,mapping == grouping),...
                        doty(f,mapping == grouping),'o');
                set(h,'MarkerSize',6);
                set(h,'MarkerFaceColor',gcolor{grouping + 1});
                set(h,'MarkerEdgeColor',gcolor{grouping + 1});
                hold on;
        end
        axis equal;
        axis([xrange(1) xrange(2) yrange(1) yrange(2)]);
        %     pause(0.02);
        F(count)=getframe;
        refresh;
        hold off;
end;
% end
movie2avi(F,sprintf('%s.pl2.avi',filename),'fps',20,'compression','None');
close;
end