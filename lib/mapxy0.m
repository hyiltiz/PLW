function xy0 = mapxy0(xy0, cx, cy)
  %help function for several functions such as RLonePLW testMirror

  % use xy0 within (0,1)
  if (-1 < xy0(1) && xy0(1) < 1) && (-1 < xy0(2) && xy0(2) < 1)
    xy0(2) = -xy0(2);
    xy0 = xy0 + 1;
    xy0 = xy0 .* [cx cy];
  end
end
