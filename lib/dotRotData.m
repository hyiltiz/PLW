function [xymatrix, dat] = dotRotData(rect, fps, render_DotRot, isInit)


    % ---------------------------------------
    % initialize dot positions and velocities
    % ---------------------------------------

    rot_flag = 0; % no rotation
    ndots       = 200; % number of dots
    mon_width   = 39;   % horizontal dimension of viewable screen (cm)
    v_dist      = 60;   % viewing distance (cm)
    dot_speed   = 7;    % dot speed (deg/sec)
    dot_w       = 0.1;  % width of dot (deg)
    fix_r       = 0.15; % radius of fixation point (deg)
    max_d       = 15;   % maximum radius of  annulus (degrees)
    min_d       = 1;    % minumum
    differentsizes = 0; % Use different sizes for each point if >= 1. Use one common size if == 0.
    f_kill      = 0.01; % fraction of dots to kill each frame (limited lifetime)

    ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
    pfs = dot_speed * ppd / fps;                            % dot speed (pixels/frame)
    s = dot_w * ppd;                                        % dot size (pixels)
    [center(1), center(2)] = RectCenter(rect);
    fix_cord = [center-fix_r*ppd center+fix_r*ppd];

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


        % Create a vector with different point sizes for each single dot, if
        % requested:
        if (differentsizes>0)
            s=(1+rand(1, ndots)*(differentsizes-1))*s;
        end;



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
        xymatrix = transpose(xy);
    end

    dat.xy    =    xy;
    dat.dxdy  =  dxdy;
    dat.r     =     r;
    dat.dr    =    dr;
    dat.cs    =    cs;
end
