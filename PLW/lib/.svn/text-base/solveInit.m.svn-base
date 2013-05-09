function crit = solveInit(data, conf)
% use linear and binary method for solving the data.init

data.readData.thet=180; data.readData.xyzseq = [1 3 2];
[x y init] = PLWtransform(data.readData, conf.scale1, conf.imagex, 1);firstPoint = diff([mean(data.dotx1(:, [10 13]) - x(:,[10 13]))], 1); 
crit = round(1 - firstPoint/.17); %solved by simple linear math. Search the init around crit
if crit < 0; crit = 1;end

lastPoint=firstPoint;
looptimes = 1;
while ~(lastPoint < 1e-10 & lastPoint > -1e-10)
  if looptimes > 3; break; end  % use binary alog. This linear one did not work (though it makes it a big quck)
    Display(crit);
    [x y init] = PLWtransform(data.readData, conf.scale1, conf.imagex, crit);newPoint = diff([mean(data.dotx1(:, [10 13]) - x(:,[10 13]))], 1); 
    crit = (newPoint - firstPoint)/.17 + 1;
if crit < 0; crit = 1;end
    if newPoint == lastPoint; break; end  % nothing good is happening
      newPoint = lastPoint;
      looptimes = looptimes+1;
end
while ~(lastPoint < 1e-10 & lastPoint > -1e-10)
if crit < 0; crit = 1;end
  if (newPoint - firstPoint)*newPoint > 0
    crit = crit - 1;
  elseif (newPoint - firstPoint)*newPoint < 0
    crit = crit + 1;
  else
    crit = 1;
  end
  [x y init] = PLWtransform(data.readData, conf.scale1, conf.imagex, crit);newPoint = diff([mean(data.dotx1(:, [10 13]) - x(:,[10 13]))], 1); 
end
end
