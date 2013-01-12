function kb = keyDefinition()
  KbName('UnifyKeyNames')
  escapeKey = KbName('escape');
  leftArrow = KbName('LeftArrow'); % modify for Windows?
  rightArrow = KbName('RightArrow');
  upArrow = KbName('UpArrow');
  downArrow = KbName('DownArrow');
  kb = struct('escapeKey', escapeKey, 'leftArrow', leftArrow,...
    'rightArrow', rightArrow, 'upArrow', upArrow, 'downArrow', downArrow);
end
