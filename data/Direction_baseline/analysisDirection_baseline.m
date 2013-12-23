%1-response value 1-leftwards response (switch output 3); value
%2-rightwards response (footswitch output 1);
% 2-dur
% 3-Trial no.
% 4-1 from initial rightwards; 2-initial leftwards
% 5-second, 1-tactile short-long-short, 2-tactile equal; 3-tactile
% long-short-long.
%subs={'anshuai','cuizhenpeng','lilingyu','liuweifang','liuye','liuzi','mawenjing','shaojiayuan','shaorenjie','sihongwei','songqingjun','tantian','wanghao','wenghanxin','zhaoyuan','zhengguomao'};

% subs = {'epar_Simple_.mat','mesede_Simple_.mat'}; % pre exp

% direction task
subs={'liangsha.mat','liuling.mat','shisensen.mat','sunqianqian.mat','wanwgxing.mat','zhangyunhao.mat','hejiahuang.mat','qiuxu.mat','zhanglibo.mat','zhangshuo.mat'};

M=[];
durtemp=[];
for isub=1:length(subs)
    load(subs{isub},'totaltrials');

    idx=find(totaltrials(:,1)==0);
    totaltrials(idx,:)=[];
    totaltrials(:,2)=totaltrials(:,2)/(mean(totaltrials(:,2)));
    [m1,g1] = grpstats(totaltrials(:,2),{totaltrials(:,5),totaltrials(:,4)==totaltrials(:,1)},{'mean','gname'});
    % 0: 1st -> 2nd;  0: 2nd <- 1st
    for j=1:length(g1)
        m1(j,2)=str2num(g1{j,1});
        m1(j,3)=str2num(g1{j,2});
    end


    for k=1:3 % cond
        idxtemp=find(m1(:,2)==k);
%         durtemp=m1(idxtemp,:);
%         for resp=1:2 % for four conditions-"congruent","incongruent","bistable","baseline";
            if isempty(idxtemp)
                m1(size(m1,1)+1,:) = [0.001 k];
            end
%         end
    end

    M=[M; m1(:,1)'];
%     disp(size(m1,1));
%     M1=reshape(M(:,1),[6,16])'; % resort
end

% M1=reshape(M(:,1),[6,numel(subs)])';

% M1 = reshape(M(:,1),[sum(M(:,2)==1),numel(M(:,1))/sum(M(:,2)==1)]);
% M1=mean(M1);
figure;
hold on;

    plot(1:3, mean(M(:,[1,3,5])),'k>-');
    plot(1:3, mean(M(:,[2,4,6])),'ks--');
% plot(1:3,mean(M),'ks-');
% errorbar(1:3, mean(M), std(M));
ylabel('触觉刺激似动主导方向持续时间(s)');
ylabel('Standardized Dominant Duration (s)');


hold off;
legend('1st->2nd','2nd->1st');
xlabel('实验触觉条件');
xlabel('Tactile Conditions');
set(gca,'Xtick',1:3);
set(gca,'XtickLabel',{'短-长-短','同时','长-短-长'});
set(gca,'XtickLabel',{'Short-Long-Short','Synchronous','Long-Short-Long'});
legend('boxoff')

