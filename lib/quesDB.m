function ques = quesDB(nameS)
% questionaire db

switch nameS
    case 'IRI'
        ques.items = {'我时常作白日梦，幻想可能会发生在我身上的事情。', '对于那些没有我幸运的人，我经常会怀有体贴、关切之情。', '有时候我觉得很难从他人的角度看问题。', '当别人遇到困难时，有时我并不会很同情他们。', '我确实会陷入小说人物的情感中。', '在紧急状况下，我会感到担心和不安。', '欣赏电影或戏剧时，我往往会很客观，并不会完全陷入其中。', '在做决定之前，我会去参考大家的不同意见。', '看到有人被利用时，我就有保护他们的想法。', '当身处高度情绪化的情境中时，我有时会感到无助。', '有时我会想象朋友对事情的看法，从而更好地理解他们。', '我很少会完全沉浸于一本好书或一部好电影中。', '看到有人受伤害时，我往往会保持平静。', '他人的不幸通常不会令我很不安。', '如果我肯定自己是对的，我就不会浪费许多时间去听别人的意见。', '看完戏剧或电影后，我感觉自己好像就是其中的一个角色。', '身处紧张的情境中，我会感到恐惧。', '当看到有人受到不公平对待时，有时我不会很同情他们。', '我经常会很有效地处理紧急事件。', '我经常被看到的事情所深深感动。', '我认为任何问题都有两面性，并尽量从正反两方面来考虑问题。', '我认为自己是个非常心软的人。', '观看一部精彩的电影时，我很容易把自己想象成是里面的主角。', '我往往会在紧急情况下不知所措。', '当有人让我心烦时，我常会设身处地地为他想一下。', '在读有趣的故事或小说时，我会想像如果故事里的情节发生在我身上，\n\n我会有什么样的感受。', '看到有人在紧急情况下急需帮助时，我会六神无主。', '在批评别人之前，我会想像如果自己处于他们的立场，会有怎样的感受。'};
        ques.title = {1, '作答说明：您好！下列是有关您在不同情境下可能会有的想法和感受。\n\n对每一题目，请选择与您情况最符合的选项，并用相应的数字键做出选择。'}; % display title before 1st item, only for once (this time)
        ques.target = repmat({''}, numel(ques.items),1); % to be used along with title, so for each item, a specific keyword as question can be specified
        ques.instr = repmat({'作答说明：您好！下列是有关您在不同情境下可能会有的想法和感受。\n\n对每一题目，请选择与您情况最符合的选项，并用相应的数字键做出选择。'}, numel(ques.items),1);
        ques.scales = repmat({'完全不符合','基本不符合', '不确定', '基本符合', '完全符合'}, numel(ques.items),1);
        ques.encode.scale = {'PT', [3, 8, 11, 15, 21, 25, 28]; 'FS', [1, 5, 7, 12, 16, 23, 26]; 'EC', [2, 4, 9, 14, 18, 20, 22]; 'PD', [6, 10, 13, 17, 19, 24, 27]};
        %反向记分题：
        ques.encode.inv = [3, 4, 7, 12, 13, 14, 15, 18, 19];
        ques.thrsh = {1, [-inf, inf], 0}; % for ques.encode.scale, {idx, [a b], isInGood}; or [] if no thrreshold required
        ques.isShowResult = 0; % whether show result for the participant
        % %问卷说明：该问卷分4个维度，分数越高，说明共情能力越高。
        % %观点采择（perspective-taking，
        % PT = [3, 8, 11, 15, 21, 25, 28];
        % %幻想（fantasy,
        % FS = [1, 5, 7, 12, 16, 23, 26];
        % %共情关注（empathic concern,
        % EC = [2, 4, 9, 14, 18, 20, 22];
        % %个人悲伤（personal distress,
        % PD = [6, 10, 13, 17, 19, 24, 27];
        
    case 'STAI'
        ques.items = {'我感到心情平静', '我感到安全', '我是紧张的', '我感到紧张束缚', '我感到安逸', '我感到烦乱', '我现在正烦恼，感到这种烦恼超过了可能的不幸', '我感到满意', '我感到害怕', '我感到舒适', '我有自信心', '我觉得神经过敏', '我极度紧张不安', '我优柔寡断', '我是轻松的', '我感到心满意足', '我是烦恼的', '我感到慌乱', '我感觉镇定', '我感到愉快','我感到愉快', '感到神经过敏和不安', '我感到自我满足', '我希望能象别人那样高兴', '我感到我象衰竭一样', '我感到很宁静', '我是平静的、冷静的和泰然自若的', '我感到困难一一堆集起来，因此无法克服', '我过分优虑一些事，实际这些事无关紧要', '我是高兴的', '我的思想处于混乱状态', '我缺乏自信心', '我感到安全', '我容易做出决断', '我感到不合适', '我是满足的', '一些不重要的思想总缠绕着我，并打扰我', '我产生的沮丧是如此强烈，以致我不能从思想中排除它们', '我是一个镇定的人', '当我考虑我目前的事情和利益时，我就陷人紧张状态'};
        ques.title = {1, '下面列出的是人们常常用来描述他们自己的陈述，\n\n请阅读每一个陈述，然后通过键盘数字键来表示你现在最恰当的感觉，\n\n也就是你此时此刻最恰当的感觉。没有对或错的回答，\n\n不要对任何一个陈述花太多的时间去考虑，但所给的回答应该是\n\n你现在最恰当的感觉。'; 1+numel(ques.items)/2, '下面列出的是人们常常用来描述他们自己的陈述，\n\n请阅读每一个陈述，然后通过键盘数字键来表示你经常的感觉。没有对或错的回答。\n\n不要对任何一个陈述花太多的时间去考虑，但所给均回答应该是你平常所感觉到的。'}; % display title before 1st item, only for once (this time)
        ques.target = repmat({'此时此刻', '平常'}, numel(ques.items)/2,1); % to be used along with title, so for each item, a specific keyword as question can be specified
%         ques.target = repmat({''}, numel(ques.items),1);
        ques.instr = [repmat({'下面列出的是人们常常用来描述他们自己的陈述，\n\n请阅读每一个陈述，然后通过键盘数字键来表示你现在最恰当的感觉，\n\n也就是你此时此刻最恰当的感觉。没有对或错的回答，\n\n不要对任何一个陈述花太多的时间去考虑，但所给的回答应该是\n\n你现在最恰当的感觉。'},numel(ques.items)/2,1); repmat({'下面列出的是人们常常用来描述他们自己的陈述，\n\n请阅读每一个陈述，然后通过键盘数字键来表示你经常的感觉。没有对或错的回答。\n\n不要对任何一个陈述花太多的时间去考虑，但所给均回答应该是你平常所感觉到的。'},numel(ques.items)/2,1)];
        ques.scales = [repmat({'完全没有','有些','中等程度','非常明显'}, numel(ques.items)/2,1);repmat({'几乎没有','有些','经常','几乎总是如此'}, numel(ques.items)/2,1)];
        ques.encode.scale = {'SAI', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]; 'TAI', [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40]};
        ques.encode.inv = [2,5,8,10,11,15,16,19,20,23,24,26,27,30,33,34,36,39];
        ques.thrsh = {1, [35, 45], 0}; % threshould for SAI, we do not want those between [35, 45];
        ques.isShowResult = 0;
        ques.target = ques.target(:);
        % ### STAI 状态一特质焦虑问卷
        %         由指导语和二个分量表共40项描述题组成。第1-20项为状态焦虑量表(STAI，Form Y-I，以下简称S-AD。其中半数为描述负性情绪的条目，半数为正性情绪条目。主要用于评定即刻的或最近某一特定时间或情景的恐惧、紧张、忧虑和神经质的体验或感受。可用来评价应激情况下的状态焦虑。第21-40题为特质焦虑量表（STAI，Form Y-l，简称T-AI)，用于评定人们经常的情绪体验。其中有11项为描述负性情绪条目，9项为正性情绪条目。
        %
        % 评定方法：该问卷由自我评定或自我报告来完成。受试者根据指导语逐题圈出答案。可用于个人或集体测试，受试者一般需具有初中文化水平。测查无时间限制，一般10-20分钟可完成整个量表条目的回答。
        %
        % 计分法：STAI每一项进行1-4级评分S-AI：1一完全没有，2一有些，3一中等程度，4一非常明显。T-AI：1一几乎没有，2一有些，3一经常，4一几乎总是如此。由受试者根据自己的体验选圈最合适的分值。凡正性情绪项目均为反序计分。分别计算S-AI和T-AI量表的累加分，最小值20，最大值为80，反映状态或特质焦虑的程度。下表显示各项目所属类别（SAI或TAI）、正序（正数）或逆序（负数）性。
        %
        %       SAI: [1, -2, 3, 4, -5, 6, 7, -8, 9, -10, -11, 12, 13, 14, -15, -16, 17, 18, -19, -20]
        %       TAI: [21, 22, -23, -24, 25, -26, -27, 28, 29, -30, 31, 32, -33, -34, 35, -36, 37, 38, -39, 40]
        %
        % 北医大精神卫生研究所与长春第一汽车公司职工医院精神科合作在长春地区和北京分别对正常人群与抑郁症病人进行了STAI中译版的测试。获得了与原作者近似的结果：1.正常人群总样本S-AI评分为39.71±8.89（男，375例），38.97±8.45（女，443例）；T-AI评分为41.11±7.74（男），41.31±7.54（女）。抑郁症组(50例）：S-AI为57.22±10.48，T-AI为46.22±26.22，明显高于正常人群。2.各年龄组与S-Al评分无明显差异；T-AI评分以50-55岁的男性组最高（平均42.8)。3.不同文化组的评分无差异。4.不同职业者中S-AI与T-AI的评分均以女性干部为最低（平均36. 7和39.6)。
        %
        % 分类依据： 根据以上材料，初步筛选掉分数在 [35,45] 区间的被试。
        
    case 'LSAS'
        ques.items =  repmat({'公众场合打电话', '参加小组活动', '公众场合吃东西', '公共场合与人共饮', '与重要人物谈话', '在听众前表演、演示或演讲', '参加聚会', '在有人注视下工作', '被人注视下书写', '与不太熟悉的人打电话', '与不太熟悉的人交谈', '与陌生人会面', '在公共卫生间小便', '进入已有人就坐到房间', '成为关注的中心', '在会议上发言', '参加测试', '对不太熟悉的人表达不同的观点和看法', '与不太熟悉的人目光对视', '在小组中汇报', '试着搭识某人', '去商店退货', '组织聚会', '拒绝推销员的强制推销'}, 2,1);
        ques.title = {1, '本量表评估不同情景下社交恐怖对您生活的影响。请仔细阅读每个情景，\n\n并回答两个相关的问题。第一个问题关于您在该情景下感到焦虑或恐惧的程度。\n\n第二个问题关于您逃避该情景的频率。如果问题中情景您平时不会经历，\n\n请您想象该情景。'};
        ques.target = repmat({'感到焦虑/恐惧程度'; '逃避的频率'}, numel(ques.items)/2, 1);
        ques.instr = repmat([{'本量表评估不同情景下社交恐怖对您生活的影响。请仔细阅读每个情景，\n\n并回答两个相关的问题。如果问题中情景您平时不会经历，请您想象该情景。\n\n\n\n在该情景下感到焦虑或恐惧的程度：'}, {'本量表评估不同情景下社交恐怖对您生活的影响。请仔细阅读每个情景，并回答两个相关的问题。\n\n如果问题中情景您平时不会经历，\n\n请您想象该情景。\n\n\n\n您逃避该情景的频率：'}], 1, numel(ques.items)/2);
        ques.scales = repmat([{'完全没有','有些','中等程度','非常明显'}; {'几乎没有','有些','经常','几乎总是如此'}], numel(ques.items)/2, 1);
        ques.encode.scale = {'fear', 1:2:numel(ques.items); 'avoidance', 2:2:numel(ques.items)};
        ques.encode.inv = [];
        ques.thrsh = {[1 2], [15, 35]+numel(ques.items)/2, 0}; % threshould for LSAS, total score between [15, 35] not wanted; exp use 1:4 rather than 0:3, so add 1 for each scale point
        ques.isShowResult = 0;
        
        ques.items = ques.items(:);
        ques.instr = ques.instr(:);
        
        
        % Liebowitz Social Anxiety Scale Test
        % The Liebowitz Social Anxiety Scale (LSAS) is a questionnaire developed by Dr. Michael R. Liebowitz, a psychiatrist and researcher.
        %
        %     This measure assesses the way that social phobia plays a role in your life across a variety of situations.
        %     Read each situation carefully and answer two questions about that situation.
        %     The first question asks how anxious or fearful you feel in the situation.
        %     The second question asks how often you avoid the situation.
        %     If you come across a situation that you ordinarily do not experience, we ask that you imagine "what if you were faced with that situation," and then rate the degree to which you would fear this hypothetical situation and how often you would tend to avoid it. Please base your ratings on the way that the situations have affected you in the last week.
        %     Heimburg, R. G. & Becker, R. E. (2002). Cognitive-Behavioral Group Therapy for Social Phobia. New York, NY: The Guilford Press.
        %
        % Chinese:
        %
        %             SAD             NORMAL
        % FEAR        37.84(14.61)    12.30(9.21)
        % AVOID       31.80(14.90)    10.01(9.12)
        % TOTAL       69.59(28.65)    22.31(16.86)
        % 诊断学理论与实践 2004, Vol.3, No.2
        %
        %
        %             Total           total.fear                     fear.socialinteraction   fear.performance     total.avoidance      avoidance.socialinteraction         avoidance.performance
        % patients    66.6/28.3       36.8/14.1                      16.4/6.7                 20.4/8.0             30.0/16.0            13.9/7.7                            16.1/8.7
        % normal      29.1/17.3       16.5/9.4                       7.4/4.7                  9.1/5.1              12.6/9.6             5.9/4.9                             6.8/5.3
        % 中国精神疾病杂志 2006, Vol.32, No.3
        % 0 1 2 3
        % 'none' 'mild tolerable' 'moderate distressing' 'severe distrubing'
        % 'never(0%)' 'occasionally(1%-33%)'  'often(33%-66%)' 'usually(67%-100%)'
        %
        % 11 social: talking to prople in authority...
        % 13 performance: working while being observed...
        
    case 'test'
        ques.items = {'1', '2', '3','4','5'};
        ques.title = {'boring questionaire'};
        ques.target = repmat({'care?'}, numel(ques.items),1);
        ques.instr = repmat({'this is test!'}, numel(ques.items),1);
        ques.scales = repmat({'A','B', 'C', 'D'}, numel(ques.items),1);
        ques.encode.scale = {'a', 1:2:numel(ques.items); 'b', 2:2:numel(ques.items)};
        %反向记分题：
        ques.encode.inv = [numel(ques.items)-1 numel(ques.items)];
        ques.thrsh = {1, [-inf, inf], 1}; % for ques.encode.scale, {idx, [a b], isInGood}; or [] if no thrreshold required
        ques.isShowResult = 1; % whether show result for the participant
        
    otherwise
        error('no such questionaire in the database!');
end
end
