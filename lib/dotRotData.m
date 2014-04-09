function [xymatrix, dat] = dotRotData(rect, fps, render_DotRot, isInit)
% ---------------------------------------
% initialize dot positions and velocities
% ---------------------------------------

rot_flag = 0; % no rotation
ndots       = 1000; % number of dots
mon_width   = 39;   % horizontal dimension of viewable screen (cm)
v_dist      = 60;   % viewing distance (cm)
dot_speed   = 2;    % dot speed (deg/sec)
% max_d       = 1.8;   % maximum radius of  annulus (degrees)
max_d       = 9;   % maximum radius of  annulus (degrees)
min_d       = 0.4;    % minumum
f_kill      = 0.01; % fraction of dots to kill each frame (limited lifetime)

ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
pfs = dot_speed * ppd / fps;                            % dot speed (pixels/frame)

rmax = max_d * ppd;	% maximum radius of annulus (pixels from center)
rmin = min_d * ppd; % minimum

if isInit
    r = rmax * sqrt(rand(ndots,1));	% r
    r(r<rmin) = rmin;
    t = 2*pi*rand(ndots,1);                     % theta polar coordinate
    cs = [cos(t), sin(t)];
    xy = [r r] .* cs;   % dot positions in Cartesian coordinates (pixels from center)

    mdir = 2 * floor(rand(ndots,1)+0.5) - 1;    % motion direction (in or out) for each dot

    if rot_flag
        dt = pfs * mdir ./ r;                       % change in theta per frame (radians)
    else
        dr = pfs * mdir;                            % change in radius per frame (pixels)
        dxdy = [dr dr] .* cs;                       % change in x and y per frame (pixels)
    end

else

    % ###################################################################
    % ### DrawDots ######################################################
    % ###################################################################

    %        updateStruct(dat, render_DotRot);

    xy = render_DotRot.xy;
    dxdy = render_DotRot.dxdy;
    r = render_DotRot.r;
    dr = render_DotRot.dr;
    cs = render_DotRot.cs;


    if rot_flag
        t = t + dt;                         % update theta
        xy = [r r] .* [cos(t), sin(t)];     % compute new positions
    else
        xy = xy + dxdy;						% move dots
        r = r + dr;							% update polar coordinates too
    end

    % check to see which dots have gone beyond the borders of the annuli

    r_out = find(r > rmax | r < rmin | rand(ndots,1) < f_kill);	% dots to reposition
    nout = length(r_out);

    if nout

        % choose new coordinates

        r(r_out) = rmax * sqrt(rand(nout,1));
        r(r<rmin) = rmin;
        t(r_out) = 2*pi*(rand(nout,1));

        % now convert the polar coordinates to Cartesian

        %            keyboard
        cs(r_out,:) = [cos(t(r_out))', sin(t(r_out))'];
        xy(r_out,:) = [r(r_out) r(r_out)] .* cs(r_out,:);

        % compute the new cartesian velocities

        if rot_flag
            dt(r_out) = pfs * mdir(r_out) ./ r(r_out);
        else
            dxdy(r_out,:) = [dr(r_out) dr(r_out)] .* cs(r_out,:);
        end

    end;
end

xymatrix = transpose(xy);
dat.xy    =    xy;
dat.dxdy  =  dxdy;
dat.r     =     r;
dat.dr    =    dr;
dat.cs    =    cs;
end
