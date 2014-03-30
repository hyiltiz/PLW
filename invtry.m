function invtr()
% instr = '作答说明：您好！下列是有关您在不同情境下可能会有的想法和感受。对每一题目，请选择与您情况最符合的选项，并用相应的数字键做出选择。';
% scales = {'完全不符合','基本不符合', '不确定', '基本符合', '完全符合'};
% items = {'我时常作白日梦，幻想可能会发生在我身上的事情。', '对于那些没有我幸运的人，我经常会怀有体贴、关切之情。', '有时候我觉得很难从他人的角度看问题。', '当别人遇到困难时，有时我并不会很同情他们。', '我确实会陷入小说人物的情感中。', '在紧急状况下，我会感到担心和不安。', '欣赏电影或戏剧时，我往往会很客观，并不会完全陷入其中。', '在做决定之前，我会去参考大家的不同意见。', '看到有人被利用时，我就有保护他们的想法。', '当身处高度情绪化的情境中时，我有时会感到无助。', '有时我会想象朋友对事情的看法，从而更好地理解他们。', '我很少会完全沉浸于一本好书或一部好电影中。', '看到有人受伤害时，我往往会保持平静。', '他人的不幸通常不会令我很不安。', '如果我肯定自己是对的，我就不会浪费许多时间去听别人的意见。', '看完戏剧或电影后，我感觉自己好像就是其中的一个角色。', '身处紧张的情境中，我会感到恐惧。', '当看到有人受到不公平对待时，有时我不会很同情他们。', '我经常会很有效地处理紧急事件。', '我经常被看到的事情所深深感动。', '我认为任何问题都有两面性，并尽量从正反两方面来考虑问题。', '我认为自己是个非常心软的人。', '观看一部精彩的电影时，我很容易把自己想象成是里面的主角。', '我往往会在紧急情况下不知所措。', '当有人让我心烦时，我常会设身处地地为他想一下。', '在读有趣的故事或小说时，我会想像如果故事里的情节发生在我身上，我会有什么样的感受。', '看到有人在紧急情况下急需帮助时，我会六神无主。', '在批评别人之前，我会想像如果自己处于他们的立场，会有怎样的感受。'};
% 
% kb = keyDefinition();
% screens=Screen('Screens');
% screenNumber=max(screens);
% % if 1
% %     [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
% % else
% %     [w,wsize]=Screen('OpenWindow',screenNumber,0);
% % end
% for i = 1:length(items)
% 
%         h = msgbox(items{i}, '心理量表', 'modal');
%         set(h, 'Visible', 'off');
%         set(h,'Units','normalized','Position',[0 0 1 1])
%         ah = get( h, 'CurrentAxes' );
%         ch = get( ah, 'Children' );
%         set(ch, 'FontSize', 30 );
%         set(ch, 'Units', 'normalized', 'Position', [0.025 0.5 0]);
%         set(h, 'Visible', 'on');
%         pause;
% end

clear
load data/inventoryIRI.mat;
%问卷说明：该问卷分4个维度，分数越高，说明共情能力越高。
%观点采择（perspective-taking，
PT = [3, 8, 11, 15, 21, 25, 28];
%幻想（fantasy,
FS = [1, 5, 7, 12, 16, 23, 26];
%共情关注（empathic concern,
EC = [2, 4, 9, 14, 18, 20, 22];
%个人悲伤（personal distress,
PD = [6, 10, 13, 17, 19, 24, 27];

%反向记分题：
inv = [3, 4, 7, 12, 13, 14, 15, 18, 19];

x = double(SimpleTask(2:end,5:end));
x(:,inv)=-1*x(:,inv);
PTscore = sum(x(:,PT),2);
FSscore = sum(x(:,FS),2);
ECscore = sum(x(:,EC),2);
PDscore = sum(x(:,PD),2);
Allscore = sum(x,2);
SimpleTask = [SimpleTask dataset({[-Inf; PTscore],'PTscore'},{[-Inf; FSscore],'FSscore'},{[-Inf; ECscore],'ECscore'},{[-Inf; PDscore],'PDscore'},{[-Inf; Allscore], 'Allscore'})];

types = {'PT','EC'};
for i=1:numel(types)
Sorted = sortrows(SimpleTask,[types{i} 'score']);
names = Sorted.columnA(2:end);

disp(['low ' types{i}]);
disp(names(1:round(end/2)));

disp(['middle of ' types{i} ': ' num2str(Sorted.([types{i} 'score'])(round(end/2))) ]);

disp(['high ' types{i}]);
disp(names(round(end/2):end))

%文献 - 人际反应指数量表的信度和效度研究
% keyboard
end

% low PT
%     '于泓峰'
%     'epar'
%     '罗斌峰'
%     '王琳'
%     '郑倩宁'
%     '任珊珊'
%     '郑梅'
%     '赵原'
%     'mesude'
%     '赵亚平'
%     '霍慧芳'
% 
% middle of PT: 15, min:1  max:11  SD=4.1090 N=22
% high PT
%     '霍慧芳'
%     '刁若尘'
%     '胡志英'
%     '司宏伟'
%     '李雅雯'
%     '崔颢'
%     '张泽华'
%     '周鹏'
%     '王慧'
%     '朱峰峰'
%     '李天一'
%     '许丽华'
% 
% low EC
%     '罗斌峰'
%     '赵亚平'
%     'epar'
%     '郑梅'
%     '王慧'
%     '王琳'
%     '赵原'
%     '李雅雯'
%     '崔颢'
%     '胡志英'
%     '周鹏'
% 
% middle of EC: 8  min:1  max:15  SD = 4.2501 N=22
% high EC
%     '周鹏'
%     '郑倩宁'
%     '司宏伟'
%     '任珊珊'
%     'mesude'
%     '于泓峰'
%     '张泽华'
%     '朱峰峰'
%     '霍慧芳'
%     '刁若尘'
%     '李天一'
%     '许丽华'

end
