function [leftfoot rightfoot] = touchgroundtest(dotx, init, pace, floop)
% return the index of the points where the PLW touches ground
% This function is mainly written for testing. It is only used by script
% ground_touch_test.m
% Only use this function for fixing the problem reported below.

selected = init + pace * floop;

% THIS LOOPING ALOGRITH WAS USED FOR CONTROLLING THE PLW'S PACE SPEED, BUT
% ITS FILTERING PROCESS (THE LINE BELOW) IS SOMEWHAT FLAWED, BY ADDING ONE
% MORE DATA POINT FROM DOTX TO X DUE TO SELECTED. CHECK IT OUT!
% ORIGINAL DATA IS ALL RIGHT. ( I HAVE CHECKED THAT!)
% while max(selected) > length(dotx),  selected(selected > length(dotx)) = selected(selected > length(dotx)) - length(dotx); end

% do not use the while loop, just mod()
selected = mod(selected, length(dotx));
selected(selected == 0) = length(dotx);  %actually it the last one should be itself, rather than 0 mathematically

X = dotx(selected ,[10 13]);

leftfoot = find(X(1:end-2, 1) > X(2:end-1, 1) & X(2:end-1, 1) < X(3:end, 1)) + 1;
rightfoot = find(X(1:end-2, 2) > X(2:end-1, 2) & X(2:end-1, 2) < X(3:end, 2)) + 1;

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
% rightfoot(X(rightfoot,2) > prctile(X(rightfoot,2),90)) = [];  % kick out the ones beyond std
rightfoot(X(rightfoot,2) - median(X(rightfoot,2)) > std(X(rightfoot,2))) = [];  % kick out the ones beyond std

if any(X(leftfoot,1) > (min(min(X)) + max(max(X)))/2) || any(X(rightfoot,2) > (min(min(X)) + max(max(X)))/2)
        beep;   %the data created is unwanted here!
        save('data/buggy.mat', 'init', 'pace', 'floop', 'dotx');
        disp([init pace]);

        %         return;
end

figure
% plot(dotx(:, [10 13]),'--');
hold on
plot(X,'k');
plot(leftfoot, X(leftfoot,1), 'ro');
plot(rightfoot, X(rightfoot,2), 'bo');
refline(0, (min(min(X)) + max(max(X)))/2);

%{
THIS WAS RATHER COMPLICATED!

% close all;
% plot(X,'k');
% hold on;

a = 5;

left = find(diff(X(:,1))<a & diff(X(:,1)) > -a & X([1: end - 1], 1) < 100);
% rl = X(left,1)

right = find(diff(X(:,2))<a & diff(X(:,2)) > -a & X([1: end - 1], 2) < 100);

% plot(left, X(left,1), 'r*');
% plot(right, X(right,2), 'b*');
% rr = X(right,2)

% approximately solve it
% rang = pace * 5;
% leftfoot = [left(find(diff(diff(left)) > rang) - 1); left(end)];
% rightfoot = [right(find(diff(diff(right)) > rang) - 1); right(end)];


res = diff(left);
isone = [];
root = [];
for i = 1:length(res)
        if res(i) == 1,
                isone = [isone; i];
        else
                root = [root; round(mean(isone))];
        end
end
leftfoot = left(root);

        
plot(X,'k');
hold on;
% plot(left, X(left,1), 'r*');
% plot(right, X(right,2), 'b*');
plot(leftfoot, X(leftfoot,1), 'r>');
plot(rightfoot, X(rightfoot,2), 'b>');

%}

