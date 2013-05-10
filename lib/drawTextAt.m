function drawTextAt(w,txt,x,y,color)
%draw text with center at x,y
%get BoundsRect
bRect= Screen('TextBounds', w,txt);
Screen('DrawText',w,txt,x-bRect(3)/2,y-bRect(4)/2,color);
