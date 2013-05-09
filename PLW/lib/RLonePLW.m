function RLonePLW(w, f, cx, cy, dotx, doty, isinv, Color)
% onePLW(w, f, cx, cy, dotx, doty, xy0) displays one PLW on w at frequency
% f at center xy0 within -1<xy0()<1 relative to given center cx, cy, according to the given
% data input dotx, doty. The PLW is vertically inversse if set to [0 1]

% Written by Hormetjan Yiltiz, Department of Psychology, Peking University
% 2012-05-19

%it appears the joint numbers are arranged in a series like 26 27 28.
%Order of joints: head; l shoulder; l elbow, l hand; r shoulder; r elbow; r
%hand; l hip; l knee; l foot; r hip; r knee; r foot;
% 0 for head, 1 for left parts and 2 for right parts of PLW.
mapping = [1 1 1 1 1 1 1 1 1 1 1 1 1];
gcolor = {Color};
dot_w = 7;
xy0 = [0 0];

% use xy0 within (0,1)
if (-1 < xy0(1) && xy0(1) < 1) && (-1 < xy0(2) && xy0(2) < 1)
        xy0(2) = -xy0(2);
        xy0 = xy0 + 1;
        xy0 = xy0 .* [cx cy];
end

dotx = 3 * dotx;
doty = 3 * doty;
dotx = dotx - min(min(dotx))/2 - max(max(dotx))/2;
doty = doty - min(min(doty))/2 - max(max(doty))/2;

if isinv(1) == 1, dotx = -dotx; end
if isinv(2) == 1, doty = -doty; end
% if cx == 0, dotx = -dotx;end

%this is important to loop over data
while f > length(dotx), f = f - length(dotx); end

grouping = 1;
%         Screen('DrawDots', w, [(cx-dotx(f,mapping == grouping));(cy-doty(f,mapping == grouping))], dot_w, gcolor{grouping + 1}, [cx-xy0(1) cy-xy0(2)], 1);
Screen('DrawDots', w, [dotx(f,mapping == grouping);doty(f,mapping == grouping)], dot_w, gcolor{grouping }, xy0, 2);
end