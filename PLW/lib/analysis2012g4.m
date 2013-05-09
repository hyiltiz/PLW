function analysis2012g4
% this prog is for general analysis, tactile directional congrurent or
% incongrurent response
% collapsed over all conditions.
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
subs={'yuermaiMirrorD15-Dec-2012','changwenMirrorD16-Dec-2012','mesudemMirrorD15-Dec-2012','mubarakMirrorD15-Dec-2012','pexriyaMirrorD16-Dec-2012','xuhongquanMirrorD15-Dec-2012','yanyanMirrorD15-Dec-2012','qiliyaMirrorD18-Dec-2012'};
  Data=[]; % to store all the data;
  Dur=[]; % for all calculated data;
  dur=[]; % store data;
for isub=1:length(subs)     
    Durtemp=[]; % temp for transform  
    load(subs{isub},'Trials'); 
    if isub>=2
    Trials(:,10)=[];
    end
    Trials(:,4)=Trials(:,4)+1; % 1 redPLW rightwards; 2-leftwards
    idx=find(Trials(:,2)==0);
    Trials(idx,:)=[];  % delete non-resp trial.
    Trials(:,10)=(Trials(:,4)==Trials(:,2))+1; % 1 incongruent;2 congruent.  
   [dur g] = grpstats(Trials(:,3),{Trials(:,5),Trials(:,10), Trials(:,1)},{'mean','gname'});
   
   %%% sorting as follows %%%
   % upright (0)/invert (1); 
   % resp condition: congruent (1)/ incongruent (2)
   %  tactile  conditions ( 1-tactile before visual; 2-congruent;
                          % 3-tactile lag visual; 4-baseline);  
   for j=1:length(g)
       dur(j,2)=str2num(g{j,1});
       dur(j,3)=str2num(g{j,2});
       dur(j,4)=str2num(g{j,3});
   end
   for j=1:2 % upright/invert
       for k=1:2 % congruent/incongruent resp
       idxtemp=find(dur(:,2)==j-1 & dur(:,3)==k);
       durtemp=dur(idxtemp,:); 
         for tacondition=1:4 % for tactile conditions;      
            if isempty(find(durtemp(:,4)==tacondition))
                durtemp(size(durtemp,1)+1,:) = [0.001 j-1 k tacondition];
            end
         end
         Durtemp=[Durtemp;durtemp]; 
       end
   end       
   dur=reshape(Durtemp(:,1),[4 4]); 
   for i=1:4   
       dur(i,5)=dur(i,2)/(dur(i,1)+dur(i,2)); % proportion of congruent/upright;
       dur(i,6)=dur(i,4)/(dur(i,3)+dur(i,4)); % proportion of congruent/invert; 
   end 
   Dur=[Dur;dur]; 
   figure;
   hold on;
   plot(1:4, dur(:,5),'s-');
   plot(1:4, dur(:,6),'o-.'); 
   hold off;   
   legend('upright-cong resp','invert-cong resp'); 
   xlabel('tactile conditions');
   ylabel('duration proportion');  
   set(gca,'Xtick',1:4);
   set(gca,'XtickLabel',{'lead','sync','lag','baseline'}); 
end
save('Result','Dur');
%% plot averaged data
Meandata=[];
Meandata=[Dur(:,5:6)];
% Meandata=Meandata';
Meandata1=reshape(Meandata,[4,16]);
avr1=mean(Meandata1(:,1:8)');
avr2=mean(Meandata1(:,9:16)');
figure;
   hold on;
   plot(1:4, avr1','s-');
   plot(1:4, avr2','o-.'); 
   hold off;   
   legend('upright-congruent resp','invert-congruent resp'); 
   xlabel('tactile conditions');
   ylabel('duration proportion');  
   set(gca,'Xtick',1:4);
   set(gca,'XtickLabel',{'lead','sync','lag','baseline'}); 

 