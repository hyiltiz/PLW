function testMirror(w, cx, cy, grey, xy0, maxdot, tactile_on, kb)
  enlarge = 0.1 * maxdot(2);
  xy0 = mapxy0(xy0, cx, cy);

  % A rectangle
  Screen('FrameRect',w ,40*[1 1 1], [xy0(1)-maxdot(1)-enlarge, xy0(2)-maxdot(2)-enlarge, xy0(1)+maxdot(1)+enlarge, xy0(2)+maxdot(2)+enlarge],4);

  % Big cross
  Screen('DrawLine',w ,grey*[1 1 1], xy0(1)-maxdot(1),xy0(2),xy0(1)+maxdot(1),xy0(2),2);
  Screen('DrawLine',w ,grey*[1 1 1], xy0(1),xy0(2)+maxdot(2),xy0(1),xy0(2)-maxdot(2),2);

  % small cross at the center of the screen
  Screen('DrawLine', w, [0 255 0], cx-10,cy,cx+10,cy,2);
  Screen('DrawLine', w, [0 255 0], cx,cy+10,cx,cy-10,2);


end
