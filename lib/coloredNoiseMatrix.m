function RGBplane = coloredNoiseMatrix(m, n, colorCell, percent)
  %percent = .05;
  if iscell(colorCell) & length(colorCell)==2
    %good
    %create the random colored dot index
    randmat = rand(m, n);
    firstColor = randmat<percent;
    secondColor = randmat > 1-percent;

    %actually I was thinking if possible to do below with prod()
    firstRGB=cat(3, firstColor*colorCell{1}(1), firstColor*colorCell{1}(2), firstColor*colorCell{1}(3));
    secondRGB=cat(3, secondColor*colorCell{2}(1), secondColor*colorCell{2}(2), secondColor*colorCell{2}(3));

    %the color RGB plane
    RGBplane = zeros(m, n, 3);
    RGBplane = firstRGB + secondRGB;
    %Display(whos('RGBplane'));
  else
    error('You may need to adjust coloring for two sets');
  end
end
