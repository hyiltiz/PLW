function [dotx doty init maxdot] = PLWtransform(readData, scale1, imagex, init)
%PLWtransform for PLW display. Makes transformation for displayed dots.
%[dotx doty] = PLWtransfor(readData, scale1, imagex)
jointspos = readData.jointspos;
thet = readData.thet; 
framenum = readData.framenum;
jointsnum = readData.jointsnum;
dotnum = readData.dotnum;
xyzseq = readData.xyzseq;

%%
jointspos1(:,:,1)=jointspos(:,:,1)+cos(thet*pi/180)*scale1;%ranint(50)*10;
jointspos1(:,:,3)=jointspos(:,:,3)+sin(thet*pi/180)*scale1;%ranint(50)*10;%ranint(30)*10;%100*i;
jointspos1(:,:,2)=jointspos(:,:,2);

for framei = 1:framenum
    mean1 = mean(jointspos1(framei,:,1));
    mean2 = mean(jointspos1(framei,:,2));
    mean3 = mean(jointspos1(framei,:,3));
    jointspos1(framei,:,1)=jointspos1(framei,:,1);%-mean1;
    jointspos1(framei,:,2)=jointspos1(framei,:,2);%-mean2;
    jointspos1(framei,:,3)=jointspos1(framei,:,3);%-mean3;  % horizantal travel distance
end;

[coefw1, coefw2]=orthocal(thet,jointspos1(:,:,xyzseq(1)),jointspos1(:,:,xyzseq(2)),jointspos1(:,:,xyzseq(3)),framenum,jointsnum);%what is this orthocal means?
scale = scale1/5;  
coefwx(:,:)=coefw1*scale+imagex/2;%+ranint(50)*20*(2*ranint(2)-3);
coefwy(:,:)=coefw2*scale+imagex/2;%+ranint(50)*20*(2*ranint(2)-3);

% glad to find out that the period is exactly 130, so make sure keeping the
% dots for plotting in the shape of 13 * 130n, where n is 1, 2, 3, ...
for i=1:size(dotnum,2)
    dotx(:,i)=coefwx(:,dotnum(i));
    doty(:,i)=coefwy(:,dotnum(i));
end;

% thanks to solving an equation while looking for the touching ground point
% it is found that the last state of the PLW is unusable
% just : plot(dotx(end-20:end, end)) to see
% missing = 0;
% dotx = dotx(1:end-missing, :);
% doty = doty(1:end-missing, :);
if init == -1
init = round(rand * 130/4) + 1;
end

dotx = dotx(init : init + 130 * 2, :);
doty = doty(init : init + 130 * 2, :);

dotx = 3 * dotx;
doty = 3 * doty;
dotx = dotx - min(min(dotx))/2 - max(max(dotx))/2;
doty = doty - min(min(doty))/2 - max(max(doty))/2;
maxdot = [max(max(dotx)) max(max(doty))];
