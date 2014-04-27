function target = fillhole(orig, cond, rules)
% orig is output of grpstats 'mean' with groups cond
% rules define the encoding, map 1:n to response types such as 0,3,7 etc.
% it might be that some data is missing for some condition. we need to fill
% in this hole to make the matrix of the same size; MATLAB should have been
% doing this automatically!

% cond = [4 2 3];
% rules = {[0 1 2 3], [0 1], [0 3 4]};

target = sortrows(fullfact(cond));
for i=1:length(rules)
    target(:,i)=Replace(target(:,i), 1:cond(i), rules{i});
end
target = [eps.*ones(size(target,1),1) target];

if all(size(target)==size(orig))
    % do nothing; we are safe
    target = orig;
else
    % only if there are holes
    nrow = 1;
    for row=1:size(orig,1)
        while ~all(orig(row,2:end)==target(nrow,2:end)) %not there yet
            nrow=nrow+1;
        end
        target(nrow, 1) = orig(row, 1);
    end
end