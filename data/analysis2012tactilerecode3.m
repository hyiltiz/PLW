% Trials(:,1) is the trial type.  1-tactile before visual; 2-congruent;
% 3-tactile lag visual; 4-baseline
% Trials(:,2)  response type 1 indicating inwards, while 2 outwards, and 0 both or none.
% Trials(:,3)   duration
% Trials(:,4)   is the heading of the red PLW, 0  walking direction is inwards, while 1 is outwards. The other PLW's heading is always in opposite direction.
% Trials(:,5)  both PLWs are upright (label as 1)
% Trials(:,6) is the number of the trial, begins from 1
% Trials(:,7) is the initial tactile stimuli type.  1-left foot first (two
% touches-first back and then front); 2-right foot first (two touches)
% Trials(:,8) red -is the frame pitch, representing the walking speed. 1 is 130 frames per loop (which is full loop) (normal speed).
% Trials(:,9) walking speed for green walker
% Trials(:,10) position for red walker, negative value--left and positive
% value-right
% eight subs, delete zhaohongyu(3),fenglili(7),yangzhiqiang(12)
% subs={'lixiaofengMirrorD12-Jan-2013','liujunyangMirrorD13-Jan-2013','ywjMirrorD13-Jan-2013','zhangzitengMirrorD20-Jan-2013',...,
%     'zhangfengqiangMirrorD20-Jan-2013','liuweiMirrorD20-Jan-2013','yumeilingMirrorD19-Jan-2013','wangdanMirrorD19-Jan-2013',...
%     'yeshaoqiangMirrorD26-Jan-2013','maqianliMirrorD27-Jan-2013','songyuchenMirrorD03-Mar-2013','sundanMirrorD03-Mar-2013','zhaolijianMirrorD02-Mar-2013',...,
%     'guoxinMirrorD02-Mar-2013','zhouyanlingMirrorD03-Mar-2013'};

%subs={'anshuaiMirrorD_InOut_17-Sep-2013.mat','cuizhenpengMirrorD_InOut_15-Sep-2013.mat','lilingyuMirrorD_InOut_15-Sep-2013.mat','liuweifangMirrorD_InOut_17-Sep-2013.mat','liuyeMirrorD_InOut_15-Sep-2013.mat','liuziMirrorD_InOut_15-Sep-2013.mat','lushilinMirrorD_InOut_15-Sep-2013.mat','mawenjingMirrorD_InOut_17-Sep-2013.mat','shaojiayuanMirrorD_InOut_15-Sep-2013.mat','shaorenjieMirrorD_InOut_17-Sep-2013.mat','sihongweiMirrorD_InOut_17-Sep-2013.mat','songqingjunMirrorD_InOut_15-Sep-2013.mat','tantianMirrorD_InOut_15-Sep-2013.mat','wanghaoMirrorD_InOut_17-Sep-2013.mat','wenghanxingMirrorD_InOut_15-Sep-2013.mat','zhaoyuanMirrorD_InOut_17-Sep-2013.mat','zhengguomaoMirrorD_InOut_17-Sep-2013.mat'};
subs = {'zhaoyuanMirrorD_InOut_17-Sep-2013.mat'};
time_on = 0;  % 0: do NOT plot for response time

Dur=[];
Table=[];% collect response switches
Data=[];
for isub=1:length(subs)
  Durtemp=[]; % temp for transform
  dur=[]; % store data;
  load(subs{isub},'Trials');
  idx=find(Trials(:,2)==0);
  Trials(idx,:)=[];  % delete the none-response data.
  keyboard
  %% here set the "congruent" and "incongruent" conditions
  Trials(2:end,12)=diff(Trials(:,2));
  idx=find(Trials(:,12)~=0);
  switchrate=length(idx)/length(Trials);
  Trials(:,2)=((Trials(:,2)-1)==Trials(:,4))+1; % 1--> incong  2-->cong
  keyboard

  % step 2: normalized phase duration for each subject
  Trials(:,3)=Trials(:,3)/(mean(Trials(:,3)));
  Data=[Data;Trials];

  % [normdata g] = grpstats(Data(:,3),{Data(:,12)},{'mean','gname'});
  % for i=1:length(g)
  %     idx = find(Data(:,12)== str2num(g{i})); %find that subject's data
  %     Data(idx,3) = Data(idx,3)/normdata(i); %normalized
  % end
  %     Trials(:,4)=Trials(:,4)+1; %column4----- 1 for red PLW is rightwards/green leftwards; 2 for red PLW is leftwards/green rightwards.
  %     % find data that red PLW is leftwards motion;
  %    idx1=find(Trials(:,4)==2);
  %    Trials1=Trials(idx1,:); % red PLW is leftwards motion;
  %    idx2 =find(Trials(:,4)==1);
  %    Trials2=Trials(idx2,:); %  red PLW is rightwards motion;

  keyboard
  if IsOctave
    dur = accumarray([Trials(:,1) Trials(:,2)],Trials(:,3),[],@mean);
    %1.72  1.08
    %0.51  0.46
    %0.03  2.39
    %0.71  1.10
  else
    [dur g] = grpstats(Trials(:,3),{Trials(:,1),Trials(:,2)},{'mean','gname'}); %  cond: 4; resp: 1-inward; 2-outward
  end
  tbl1 = sum(table(Trials(Trials(:,2)==1,1),Trials(Trials(:,2)==1,6)),2);%number of incongruent response
  tbl2 = sum(table(Trials(Trials(:,2)==2,1),Trials(Trials(:,2)==2,6)),2);%number of congruent response
  for j=1:length(g)
    dur(j,2)=str2num(g{j,1});
    dur(j,3)=str2num(g{j,2});
  end

  for j=1:4 % cond
    idxtemp=find(dur(:,2)==j);
    durtemp=dur(idxtemp,:);
    for resp=1:2 % for four conditions-"congruent","incongruent","bistable","baseline";
      if isempty(find(durtemp(:,3)==resp))
        durtemp(size(durtemp,1)+1,:) = [0.001 j resp];
      end
    end
    Durtemp=[Durtemp;durtemp];
  end
  dur1=reshape(Durtemp(:,1),[2 4])'; % four column,
  Dur=[Dur;dur1];
  Table = [Table;[tbl1'  tbl2']]; % 1-4 column for incong; 5-8 for cong
  % %    Dur2=[Dur2; dur2];
  %    redPLWupcong=(dur1(:,5)+dur2(:,5))/2;
  %    redPLWupinicong=(dur1(:,7)+dur2(:,7))/2;
  %    redPLWinvertcong=(dur1(:,6)+dur2(:,6))/2;
  %    redPLWinvertincong=(dur1(:,8)+dur2(:,8))/2;

  figure;
  hold on;
  if time_on
    plot(1:4, dur1(:,1),'rs-');
    plot(1:4, dur1(:,2),'s-.');
    ylabel('duration (s)');
  else
    plot(1:4, tbl1,'rs-');
    plot(1:4, tbl2,'s-.');
    ylabel('number of responses');
  end;

  hold off;
  legend('Incong','Cong');
  xlabel('tactile conditions');
  set(gca,'Xtick',1:4);
  set(gca,'XtickLabel',{'TbeforV','Synchronous','TafterV','baseline'});
end

%% Averaged plot
Dur1=Dur(:,1);
Dur2=Dur(:,2);
Dur1=reshape(Dur1,[4,17]);
Dur2=reshape(Dur2,[4,17]);
Dur1=Dur1';
Dur2=Dur2';
Dur1avr=mean(Dur1);
Dur2avr=mean(Dur2);
keyboard

if time_on
  figure;
  hold on;
  plot(1:4, Dur1avr','s-');
  plot(1:4, Dur2avr','s-.');
  hold off;
  legend('Incong','Cong');
  xlabel('tactile conditions');
  ylabel('duration (s)');
  set(gca,'Xtick',1:4);
  set(gca,'XtickLabel',{'TbeforV','Synchronous','TafterV','baseline'});

else
  %% Averaged plot
  figure;
  hold on;
  plot(1:4, mean(Table),'s-');
  plot(1:4, Dur2avr','s-.');
  hold off;
  legend('Incong','Cong');
  xlabel('tactile conditions');
  ylabel('duration (s)');
  set(gca,'Xtick',1:4);
  set(gca,'XtickLabel',{'TbeforV','Synchronous','TafterV','baseline'});
end
