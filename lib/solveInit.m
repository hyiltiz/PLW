function init = solveInit(theta, dotx, conf, data)
  data.readData.thet=theta; data.readData.xyzseq = [1 3 2]; dot = dotx;
  % [x y init] = PLWtransform(data.readData, conf.scale1, conf.imagex, 1);
  % firstPoint = diff([mean(dot(:, [10 13]) - x(:,[10 13]))], 1);
  % crit = round(1 - firstPoint/.17); %solved by simple linear math. Search the init around crit
  % beginend = [crit-5 crit+5];
  % if beginend(1)<=0 ;
  %     beginend(1)=1;
  % end
  %
  % if beginend(2) > round(130/4);
  %     beginend(2) = round(130/4);
  % end
  %
  %
  % for i= beginend(1):beginend(2)
  %     [x y init] = PLWtransform(data.readData, conf.scale1, conf.imagex, i);
  %     a(i,:) = diff([mean(dot(:, [10 13]) - x(:,[10 13]))],1);
  %     keyboard;
  %     if ~isempty(find(a < 1e-10 & a > -1e-10));
  %         init = find(a < 1e-10 & a > -1e-10);
  %         init = init(1);
  %         Display('Found!', init);
  %         break;
  %     end
  % end;

  clear a;
  for i=1:round(130/4)+1;
    [x y init] = PLWtransform(data.readData, conf.scale1, conf.imagex, i);
    a(i,:) = diff([mean(dot(:, [10 13]) - x(:,[10 13]))],1);
  end;
  if ~isempty(find(a < 1e-10 & a > -1e-10));
    init = find(a < 1e-10 & a > -1e-10);
    init = init(1);
    Display('Found!', init);
  end
end
