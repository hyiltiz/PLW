%1-response value 1-leftwards response (switch output 3); value
%2-rightwards response (footswitch output 1);
% 2-dur
% 3-Trial no.
% 4-1 from initial inwards; 2-initial outwards
% 5-second, 1-tactile short-long-short, 2-tactile equal; 3-tactile
% long-short-long.
%subs={'anshuai','cuizhenpeng','lilingyu','liuweifang','liuye','liuzi','mawenjing','shaojiayuan','shaorenjie','sihongwei','songqingjun','tantian','wanghao','wenghanxin','zhaoyuan','zhengguomao'};

% subs = {'epar_Simple_.mat','mesede_Simple_.mat'}; % pre exp

% simple task, day 1 and day 2
subs={'cuihao_Simple_.mat','diaoruochen_Simple_.mat','epar_Simple_.mat','hujiying_Simple_.mat','liuzhao_Simple_.mat','liyawen_Simple_.mat','luobinfeng_Simple_.mat','mesede_Simple_.mat','renshanshan_Simple_.mat','wanghui_Simple_.mat','wanglin_Simple_.mat','wangzhongrui_Simple_.mat','xulihua_Simple_.mat','zhangzehua_Simple_.mat','zhaoyaping_Simple_.mat','zhaoyuan2_Simple_.mat','zhengmei_Simple_.mat','zhengqianning_Simple_.mat','zhoupeng_simple_Simple_.mat','lichen.mat','chenxiyue.mat','penghuilin.mat','fushenjiang.mat','zhouyifan.mat','chenpeikai.mat','yuanhuibang.mat','chenxinyan.mat','chengcheng.mat','chenjun.mat','zhaokai.mat','hujuntao.mat','wangkangda.mat','hanjiayun.mat','libixing.mat','hansiqi.mat'};
subs = {'zhaoyaping_Simple_'};
M=[];
durtemp=[];
for isub=1:length(subs)
    load(subs{isub},'totaltrials');

    idx=find(totaltrials(:,1)==0);
    totaltrials(idx,:)=[];
    totaltrials(:,2)=totaltrials(:,2)/(mean(totaltrials(:,2)));
    [m1,g1] = grpstats(totaltrials(:,2),{totaltrials(:,5)},{'mean','gname'});
%    grpstats(totaltrials(:,2),{totaltrials(:,1)==totaltrials(:,4), totaltrials(:,5)})
    for j=1:length(g1)
        m1(j,2)=str2num(g1{j,1});
        %         m1(j,3)=str2num(g1{j,2});
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
    %     keyboard
    %     M1=reshape(M(:,1),[6,16])'; % resort
end

% M1=reshape(M(:,1),[6,numel(subs)])';

% M1 = reshape(M(:,1),[sum(M(:,2)==1),numel(M(:,1))/sum(M(:,2)==1)]);
% M1=mean(M1);
figure;
hold on;

%     plot(1:3, M1(1,[1,3,5]),'rs-');
%     plot(1:3, M1(1,[2,4,6])','s-.');
plot(1:3,mean(M),'ks-');
ylabel('触觉刺激似动主导方向持续时间(s)');
ylabel('Standardized Dominant Duration (s)');


hold off;
% legend('Inwards','Outwards');
% legend('Outwards','Inwards');
xlabel('实验触觉条件');
xlabel('Tactile Conditions');
set(gca,'Xtick',1:3);
set(gca,'XtickLabel',{'短-长-短','同时','长-短-长'});
set(gca,'XtickLabel',{'Short-Long-Short','Synchronous','Long-Short-Long'});
legend('boxoff')


