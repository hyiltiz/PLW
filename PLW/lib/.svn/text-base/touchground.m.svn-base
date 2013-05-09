function [leftfoot rightfoot] = touchground(dotx, init, pace, floop)
% return the index of the points where the PLW touches ground
% This function is mainly written for testing. It is only used by script
% ground_touch_test.m
% Only use this function for fixing the problem reported below.
isplot = 0;

selected = init + pace * floop;

selected = mod(selected, length(dotx));  %select over the data by pace, beginning from init
selected(selected == 0) = length(dotx);  %actually it the last one should be itself, rather than 0 mathematically

X = dotx(selected ,[10 13]);  %used for calculation below, left and right foot data

% Find the touching ground point
leftfoot = find(X(1:end-2, 1) > X(2:end-1, 1) & X(2:end-1, 1) < X(3:end, 1)) + 1;
rightfoot = find(X(1:end-2, 2) > X(2:end-1, 2) & X(2:end-1, 2) < X(3:end, 2)) + 1;
%% Clean the mess up described above
% I have found by looking at many plots of it that the unwanted solution of
% the leftfoot is always has a up-going pitch just before it. So check for it.
% If there is, then this is the unwanted thing. The right foot has a
% up-going one next to it.
flag = 0;  %true if touch ground point is almost at the beginning
if rightfoot(end) + 2 > length(X)
    X = [X; X(end,:)];      %duplicate the last one. It is just for the checking below.
end
if leftfoot(1) -2 < 1
    X = [X(1,:); X];        %the first one rather.
    leftfoot = leftfoot + 1;
    rightfoot = rightfoot + 1;
    flag = 1;
end
try
    leftfoot(X(leftfoot - 2, 1) < X(leftfoot - 1, 1) & X(leftfoot - 1, 1) > X(leftfoot, 1)) = [];  %get rid of /o\ points
    rightfoot(X(rightfoot, 2) < X(rightfoot + 1, 2) & X(rightfoot + 1, 2) > X(rightfoot + 2, 2)) = []; %get rid of /o\ points
catch
    disp('load the file buggy_index!');
    save('data/buggy_index.mat', 'init', 'pace', 'floop', 'dotx');
end
if flag  %subtract them back if added for the checking above
    leftfoot = leftfoot - 1;
    rightfoot = rightfoot - 1;
end
% rightfoot(X(rightfoot) > prctile(X(rightfoot,2),.75)) = [];  % kick out the extremes
rightfoot(X(rightfoot,2) - median(X(rightfoot,2)) > std(X(rightfoot,2))) = [];  % kick out the ones beyond std

if any(X(leftfoot,1) > (min(min(X)) + max(max(X)))/2) || any(X(rightfoot,2) > (min(min(X)) + max(max(X)))/2)
    beep;   %the data created is unwanted here!
    save('data/buggy.mat', 'init', 'pace', 'floop', 'dotx');
    disp([init pace]);
    
    if isplot
        figure
        % plot(dotx(:, [10 13]),'--');
        hold on
        plot(X,'k');
        plot(leftfoot, X(leftfoot,1), 'ro');
        plot(rightfoot, X(rightfoot,2), 'bo');
        refline(0, (min(min(X)) + max(max(X)))/2);
        %         return;
    end
end
if isplot
    if ~tactile_on
        figure
        % plot(dotx(:, [10 13]),'--');
        hold on
        plot(X,'k');
        plot(leftfoot, X(leftfoot,1), 'ro');
        plot(rightfoot, X(rightfoot,2), 'bo');
        line([0 max(max(dotx))], [(min(min(X)) + max(max(X)))/2 (min(min(X)) + max(max(X)))/2]);
        title('Tactile Stimuli(red for left)');
    end
end