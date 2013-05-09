% Trials(:,1) is the trial type.  1-tactile before visual; 2-congruent;
% 3-tactile lag visual; 4-baseline
% Trials(:,2)  response type 1 indicating right, while 2 left, and 0 both or none.
% Trials(:,3)   duration  
% Trials(:,4)   is the heading of the red PLW, 0  walking direction is right, while 1 is left. The other PLW's heading is always in opposite direction.
% Trials(:,5)  0 means the red PLW is upright, while 1 is upside-down. The other PLW is in align with the red PLW.
% Trials(:,6) is the number of the trial, begins from 1 
% Trials(:,7) is the initial tactile stimuli type. Definition is the same with response in Trials(:,2), 1 indicating right, while 2 left, and 0 is baseline, without tactile
% Trials(:,8) red -is the frame pitch, representing the walking speed. 1 is 130 frames per loop (which is full loop) while 2 is 130/2 frames per loop.
% Trials(:,9) walking speed for green walker
% Trials(:,10) position for red walker, negative value--left and positive
% value-right.
subs={'yuermaiMirrorD15-Dec-2012','changwenMirrorD16-Dec-2012','mesudemMirrorD15-Dec-2012','mubarakMirrorD15-Dec-2012','pexriyaMirrorD16-Dec-2012','xuhongquanMirrorD15-Dec-2012','yanyanMirrorD15-Dec-2012'};
 for isub=1:length(subs);
    Dur1temp=[]; % temp for transform
    Dur2temp=[]; % 
    dur1=[]; % store data;
    dur2=[];
    load(subs{isub},'Trials'); 
    idx=find(Trials(:,2)==0);
    Trials(idx,:)=[];  % delete the none-response data.
    Trials(:,4)=Trials(:,4)+1; %column4----- 1 for red PLW is rightwards/green leftwards; 2 for red PLW is leftwards/green rightwards.
    % find data that red PLW is leftwards motion;
   idx1=find(Trials(:,4)==2);
   Trials1=Trials(idx1,:); % red PLW is leftwards motion;
   idx2 =find(Trials(:,4)==1);
   Trials2=Trials(idx2,:); %  red PLW is rightwards motion;  
   [dur1 g] = grpstats(Trials1(:,3),{Trials1(:,5),Trials1(:,2),Trials1(:,1)},{'mean','gname'}); %  upright/invert;  resp-right or left; tactile conditions;  
   for j=1:length(g)
       dur1(j,2)=str2num(g{j,1});
       dur1(j,3)=str2num(g{j,2});
       dur1(j,4)=str2num(g{j,3});
   end
   for j=1:2 % upright/invert
       for k=1:2 % right/left resp  
       idxtemp=find(dur1(:,2)==j-1 & dur1(:,3)==k);
       dur1temp=dur1(idxtemp,:); 
         for tacondition=1:4 % for tactile conditions;      
            if isempty(find(dur1temp(:,4)==tacondition))
                dur1temp(size(dur1temp,1)+1,:) = [0 j-1 k tacondition];
            end
         end
         Dur1temp=[Dur1temp;dur1temp]; 
       end
   end       
   dur1=reshape(Dur1temp(:,1),[4 4]);
   
   for i=1:4  % dur1---> red PLW leftwards
       dur1(i,5)=dur1(i,2)/(dur1(i,1)+dur1(i,2)); % proportion of left motion/upright;
       dur1(i,6)=dur1(i,4)/(dur1(i,3)+dur1(i,4)); % proportion of left motion/invert;
       dur1(i,7)=1-dur1(i,5); % proportion of right motion/upright
       dur1(i,8)=1-dur1(i,6); % proportion of right motion/invert.
   end
   [dur2 g] = grpstats(Trials2(:,3),{Trials2(:,5),Trials2(:,2),Trials2(:,1)},{'mean','gname'});
   for j=1:length(g)
       dur2(j,2)=str2num(g{j,1});
       dur2(j,3)=str2num(g{j,2});
       dur2(j,4)=str2num(g{j,3});
   end
   for j=1:2 % upright/invert
       for k=1:2 % right/left resp  
       idxtemp=find(dur2(:,2)==j-1 & dur2(:,3)==k);
       dur2temp=dur2(idxtemp,:); 
         for tacondition=1:4 % for tactile conditions;      
            if isempty(find(dur2temp(:,4)==tacondition))
                dur2temp(size(dur2temp,1)+1,:) = [0 j-1 k tacondition];
            end
         end
         Dur2temp=[Dur2temp;dur2temp]; 
       end
   end       
   dur2=reshape(Dur2temp(:,1),[4 4]);  
   for i=1:4 % dur2---> red PLW rightwards.
       dur2(i,5)=dur2(i,1)/(dur2(i,1)+dur2(i,2)); % proportion of right motion/upright;
       dur2(i,6)=dur2(i,3)/(dur2(i,3)+dur2(i,4)); % proportion of right motion/invert; 
       dur2(i,7)=1-dur2(i,5); % proportion of left motion/upright;
       dur2(i,8)=1-dur2(i,6); % proportion of left motion/invert
   end
%    Dur1=[Dur1;dur1]; 
%    Dur2=[Dur2; dur2]; 
   redPLWupcong=(dur1(:,5)+dur2(:,5))/2; 
   redPLWupinicong=(dur1(:,7)+dur2(:,7))/2;
   redPLWinvertcong=(dur1(:,6)+dur2(:,6))/2;
   redPLWinvertincong=(dur1(:,8)+dur2(:,8))/2;
   
   figure;
   hold on;
   plot(1:4, redPLWupcong,'s-');
   plot(1:4, redPLWupinicong,'s-.');
   plot(1:4, redPLWinvertcong,'o-');
   plot(1:4, redPLWinvertincong,'o-.');
   hold off;   
   legend('RedPLW-Up-Congruent','RedPLW-UP-Incongruent','RedPLW-Invert-Congruent','RedPLW-Invert-Incongruent'); 
   xlabel('tactile conditions');
   ylabel('duration proportion');  
   set(gca,'Xtick',1:4);
   set(gca,'XtickLabel',{'tactile before','tactile congruent','tactile lag','baseline'});
   
   figure; % bias
   hold on;
   plot(1:4, redPLWupcong-redPLWupinicong,'s-'); % congruent minus incongurent.
   plot(1:4,  redPLWinvertcong- redPLWinvertincong,'o-.'); 
   hold off;   
   legend('RedPLW-Up-CongmiusIncong', 'RedPLW-Invert-CongminusIncong'); 
   xlabel('tactile conditions');
   ylabel('duration proportion bias'); 
   
   set(gca,'Xtick',1:4);
   set(gca,'XtickLabel',{'tactile before','tactile congruent','tactile lag','baseline'});
%    
end
 