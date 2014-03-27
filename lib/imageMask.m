function imraw = imageMask(imraw, dmask, wmask)
% add mask to image
% dmask: d of two masked area == w of per visible area; 1 for default
% wmask: w of per masked area == d of per visible area; 8 for default

maskx = 1:size(imraw,1);
masky = 1:size(imraw,2);

% [] the visible area out
braster=logical([ones(dmask,1); zeros(wmask,1)]);
xraster=repmat(braster,ceil(numel(maskx)/numel(braster)),1);
yraster=repmat(braster,ceil(numel(masky)/numel(braster)),1);

xraster=xraster(1:numel(maskx));
yraster=yraster(1:numel(masky));

%    keyboard
maskx(xraster)=[];
masky(yraster)=[];

% 0 the masked area
imraw(maskx,masky,:)=0;
end