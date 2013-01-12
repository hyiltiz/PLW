function loop = modloop(x, y)
  loop = mod(x, y);
  loop(loop == 0) = y;
end
