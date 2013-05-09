function out = PLWsound(in)
%makes transformations for PLW sound stimuli

% Written by Hormetjan Yiltiz, Department of Psychology, Peking University
% 2012-05-19
left = in(:,1);
right = in(:,2);

left = transform(left, 1);  % 1 for reducing from beginning
right = transform(right, 0); %0 for reducing from end
% this makes the sound from right to left
out = [left right]';

        function y = transform(x, flag)
                %adjusting function
                k = linspace(0, 1, length(x))';
                if flag == 0, k = flipud(k);end
                y = k .* x;
        end
end