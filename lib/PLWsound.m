function out = PLWsound(in, dir, rate)
%makes transformations for PLW sound stimuli

% Written by Hormetjan Yiltiz, Department of Psychology, Peking University
% 2012-05-19
% left = in(1:rate:end,1);
% right = in(1:rate:end,2);
left = in(:,1);
right = in(:,2);

if dir % true if walking to left
        left = transform(left, 1);  % 1 for small -> large
        right = transform(right, 0); %0 for large -> small
else
        left = transform(left, 0);  % 1 for small -> large
        right = transform(right, 1); %0 for large -> small
end

% this makes the sound from right to left
out = [left right]';

        function y = transform(x, flag)
                %adjusting function
                k = linspace(0, 1, length(x))';
                if flag == 0, k = flipud(k);end
                y = k .* x;
        end
end