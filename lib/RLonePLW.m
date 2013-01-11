function RLonePLW(w, f, cx, cy, dotx, doty, isinv, Color, xy0, maxdot)
% onePLW(w, f, cx, cy, dotx, doty, xy0) displays one PLW on w at frequency
% f at center xy0 within -1<xy0()<1 relative to given center cx, cy, according to the given
% data input dotx, doty. The PLW is vertically inversse if isinv set to [0 1]

% Written by Hormetjan Yiltiz, Department of Psychology, Peking University
% 2012-05-19

%it appears the joint numbers are arranged in a series like 26 27 28.
%Order of joints: head; l shoulder; l elbow, l hand; r shoulder; r elbow; r
%hand; l hip; l knee; l foot; r hip; r knee; r foot;
% 0 for head, 1 for left parts and 2 for right parts of PLW.
mapping = [1 1 1 1 1 1 1 1 1 1 1 1 1];
gcolor = {Color};
dot_w = 7;
%xy0 = [-.4 0];

xy0 = mapxy0(xy0, cx, cy);

if isinv(1) == 1, dotx = -dotx; end
if isinv(2) == 1, doty = -doty; end
% if cx == 0, dotx = -dotx;end

%this is important to loop over data
while f > length(dotx), f = f - length(dotx); end

grouping = 1;
%         Screen('DrawDots', w, [(cx-dotx(f,mapping == grouping));(cy-doty(f,mapping == grouping))], dot_w, gcolor{grouping + 1}, [cx-xy0(1) cy-xy0(2)], 1);
Screen('DrawDots', w, [dotx(f,mapping == grouping);doty(f,mapping == grouping)], dot_w, gcolor{grouping }, xy0, 2);

if xy0(1) == 0
    % then we know mirror_on=FALSE
else
    % mirror_on=TRUE, draw ovals with cross at the center
    %xmax = max(max(dotx));
    %ymax = max(max(doty));
    enlarge = 0.4 * maxdot(2);
    Screen('FrameOval',w ,80*[1 1 1], [xy0(1)-maxdot(1)-enlarge, xy0(2)-maxdot(2)-enlarge, xy0(1)+maxdot(1)+enlarge, xy0(2)+maxdot(2)+enlarge],4);
    Screen('DrawLine',w ,80*[1 1 1], xy0(1)-5,xy0(2),xy0(1)+5,xy0(2),2);
    Screen('DrawLine',w ,80*[1 1 1], xy0(1),xy0(2)+5,xy0(1),xy0(2)-5,2);
    % Screen('DrawLine', w, [0 255 0], cx-10,cy,cx+10,cy,2);
    % Screen('DrawLine', w, [0 255 0], cx,cy+10,cx,cy-10,2);
end
end
