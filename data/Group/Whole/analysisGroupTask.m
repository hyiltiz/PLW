function [stat, alldata] = analysisGroupTask
%% analyse Group task
% input: all mat-files under data/Group/Whole/; see matfiles variable below
% output:
% DS: a data set array that has condition(4)*responsetype(3) rows for each
% subject, with corresponding data for each condition*responsetype
% combination; all data were collected from the mat-file, specifically from
% ques.*.encode.scales, wrkspc.Octal.Subinfo, wrkspc.*.Trials; see helper
% function singleds below, that generates single dataset array ids for each
% subject; see below:
% id    dur      condition  resptype    otherinfo
% 1    1.5190    1.0000         0
% 1   16.4243    1.0000    3.0000
% 1   29.8217    1.0000    4.0000
% 1    3.4529    2.0000         0
% 1   28.5258    2.0000    3.0000
% 1   35.7774    2.0000    4.0000
% 1    3.7762    3.0000         0
% 1    4.7768    3.0000    3.0000
% 1   23.4488    3.0000    4.0000
% 1    1.3791    4.0000         0
% 1    6.6571    4.0000    3.0000
% 1   30.4061    4.0000    4.0000
%
%
% there are 4 type of duration time in the dateset DS
% 1.
% absolute dur value:            tplw, tdot;
% also returned as struct DUR
%
% 2.
% absolute dur value(normalized): tnormplw, tnormdot;
% also returned as struct DURNORM
% used Trials(:,3)/mean(Trials(:,3) for normalization
%
% 3.
% relative dur value(as mentioned in the email by Prof. Chen): rplw, rdot;
% also returned as struct DURR
% 绝对时间算三种的-朝里、朝外和不动作；
% 相对时间算每个被试算所有朝里和朝外的平均数，
% 然后本别将朝里和朝外的时间除以这个平均数
%
% 4.
% dur ratio(for each condition per sub, ratio of the differect dur means to
% inward dur means); taking the above table as example:
% it is the ratio of column1./column2
%     tdur     tdur(restype==3)
%     1.5190   16.4243
%    16.4243   16.4243
%    29.8217   16.4243
%     3.4529   28.5258
%    28.5258   28.5258
%    35.7774   28.5258
%     3.7762    4.7768
%     4.7768    4.7768
%    23.4488    4.7768
%     1.3791    6.6571
%     6.6571    6.6571
%    30.4061    6.6571

%% description of the mat file
% filename:     <name>_Whole<date>.mat
% -- data stored in this file ---------------------------------------------
%   Name        Description
%   isForced    logical, TRUE iff failed LSAS & continued by experimenter
%   isPLWFirst  logical, TRUE iff DotRotTask is folowed by OctalTask
%   ques        struct, contails data from StaticChoice questionaires
%   wrkspc      struct, contains data from RL_PLW tasks
%
% -- the structure of variables ques, wrkspc -----------------------------
%{

ques
     IRI
           items: {1x28 cell}
           title: {[1]  [1x68 char]}
          target: {28x1 cell}
           instr: {28x1 cell}
          scales: {28x5 cell}
          encode: [1x1 struct]
          		scale: {4x3 cell}
						'fear'         [1x24 double]    [56]
						'avoidance'    [1x24 double]    [52]
      			inv: [3 4 7 12 13 14 15 18 19]
           thrsh: {[1]  [-Inf Inf]  [0]}
    isShowResult: 0
        response: {28x1 cell}
         restime: [28x1 double]
            isOK: 0

     LSAS
           items: {48x1 cell}
           title: {[1]  [1x119 char]}
          target: {48x1 cell}
           instr: {48x1 cell}
          scales: {48x4 cell}
          encode: [1x1 struct]
             	scale: {2x3 cell}
         			    'PT'    [1x7 double]    [24]
					    'FS'    [1x7 double]    [22]
					    'EC'    [1x7 double]    [18]
					    'PD'    [1x7 double]    [20]
      			inv: []
           thrsh: {[1 2]  [39 59]  [0]}
    isShowResult: 0
        response: {48x1 cell}
         restime: [48x1 double]
            isOK: 0

wrkspc
     Octal
	       conf: [1x1 struct]
	       mode: [1x1 struct]
	    Subinfo: {8x1 cell}
	       data: [1x1 struct]
	       flow: [1x1 struct]
	     Trials: [66x10 double]
    DotRot
	       conf: [1x1 struct]
	       mode: [1x1 struct]
	    Subinfo: {8x1 cell}
	       data: [1x1 struct]
	       flow: [1x1 struct]
	     Trials: [315x10 double]
    ImEval
	       conf: [1x1 struct]
	       mode: [1x1 struct]
	    Subinfo: {8x1 cell}
	       data: [1x1 struct]
	       flow: [1x1 struct]
	     Trials: [20x10 double]



data most most likely used for analysis are as follows:
ques.<task>.encode.scale{:,1}	name of each sub-inventory
ques.<task>.encode.scale{:,2}	items in each sub-inventory (use ques.<task>.items for lookup)
ques.<task>.encode.scale{:,3}	total score for each sub-inventory
ques.<task>.response 			raw response as char, use ./lib/quesEncode.m to calculate the above total score
ques.<task>.restime				response time for each items, in seconds. least interval 0.01s
<task> is either IRI, or LSAS

wrkspc.<task>.Trials			contains all data necessary for analysis
wrkspc.<octal>.data.imnames     images used for each Trials

Trials:
1 			2 				3 				4 			5 			6 			7
condition	response_type	response_time	is_outward	is_upright	trialNo		iniTactile(INVALID,no tactile)

condition: controls the face stimuli, 1:4
    case 1
        % anger
        weight = [6 0 2];
    case 2
        % neutral
        weight = [0 8 0];
    case 3
        % happy
        weight = [2 0 6];
    case 4
        % no image here; return blank image path
        weight = 0;


	number of images we have for each type
	           anger     neu     happy
	1:male     37        113     123
	2:female   37        109     125

response_type: 3, 4, 7*N
	3 <-> UPkey   <-> inward
	4 <-> DOWNkey <-> outward
	7*N: for ImEvalTask, encoded as product of 7. e.g. if response is 4 indicating neutral, then response_type = 7*4 = 28
%}

%% Begin analysis
mode.keepnoresponse = 0;

mode.interactive = 0;
mode.verbose = 1;

mode.write = 0;

mode.picture = 0;
mode.inspect = 0;
mode.meanpic = 1;
mode.errbar = 1;
mode.isline = 0;


if mode.interactive
    mode.verbose = 1;
    mode.picture = 1; %picture for each sub
    mode.inspect = 1;
end

try
    % all data files nto moved to tmp
    % matfiles = cellstr(ls('data/Group/Whole/*.mat'));
    % subs he suggested
    matfiles = {'LiuMingjie_Whole1_18-Apr-2014.mat','abduletif_Whole1_13-Apr-2014.mat','chentongsheng_Whole1_27-Apr-2014.mat','dongyinan_Whole1_17-Apr-2014.mat','gaorenqiang_Whole1_20-Apr-2014.mat','guoyanlin_Whole1_19-Apr-2014.mat','hongyanxue_Whole1_27-Apr-2014.mat','houhao_Whole1_27-Apr-2014.mat','jiangrongjie_Whole1_27-Apr-2014.mat','jinchao_Whole1_19-Apr-2014.mat','lintingrui_Whole1_17-Apr-2014.mat','liuziye_Whole1_27-Apr-2014.mat','liweizhao_Whole1_18-Apr-2014.mat','lixixiao_Whole1_18-Apr-2014.mat','maoheting_Whole1_20-Apr-2014.mat','pahriya_Whole1_13-Apr-2014.mat','shisensen_Whole1_28-Apr-2014.mat','sunqisong_Whole1_27-Apr-2014.mat','tanghuijuan_Whole1_20-Apr-2014.mat','tangyating_Whole1_27-Apr-2014.mat','wangsixue_Whole1_19-Apr-2014.mat','xuhuaxuan_Whole1_17-Apr-2014.mat','xumiaomiao_Whole1_19-Apr-2014.mat','yuhuan_Whole1_27-Apr-2014.mat','yuzhanyuan_Whole1_18-Apr-2014.mat','zhanghuaigong_Whole1_18-Apr-2014.mat','zhanglinlin_Whole1_20-Apr-2014.mat','zhaoxiubo_Whole1_20-Apr-2014.mat','zhaoyutian_Whole1_17-Apr-2014.mat','zhengguomao_Whole1_27-Apr-2014.mat','zhengnanjian_Whole1_19-Apr-2014.mat'};
    % subs after I filered some out
    % matfiles = {'LiuMingjie_Whole1_18-Apr-2014.mat','abduletif_Whole1_13-Apr-2014.mat','chentongsheng_Whole1_27-Apr-2014.mat','chenziyu_Whole1_19-Apr-2014.mat','dongyinan_Whole1_17-Apr-2014.mat','gaorenqiang_Whole1_20-Apr-2014.mat','guoyanlin_Whole1_19-Apr-2014.mat','hanya_Whole1_27-Apr-2014.mat','hongyanxue_Whole1_27-Apr-2014.mat','houhao_Whole1_27-Apr-2014.mat','jiangrongjie_Whole1_27-Apr-2014.mat','lintingrui_Whole1_17-Apr-2014.mat','liuziye_Whole1_27-Apr-2014.mat','lixixiao_Whole1_18-Apr-2014.mat','maoheting_Whole1_20-Apr-2014.mat','pahriya_Whole1_13-Apr-2014.mat','shisensen_Whole1_28-Apr-2014.mat','sunqisong_Whole1_27-Apr-2014.mat','tanghuijuan_Whole1_20-Apr-2014.mat','tangyating_Whole1_27-Apr-2014.mat','wangsixue_Whole1_19-Apr-2014.mat','xuhuaxuan_Whole1_17-Apr-2014.mat','xumiaomiao_Whole1_19-Apr-2014.mat','yuhuan_Whole1_27-Apr-2014.mat','yuzhanyuan_Whole1_18-Apr-2014.mat','zhaoxiubo_Whole1_20-Apr-2014.mat','zhaoyutian_Whole1_17-Apr-2014.mat','zhengguomao_Whole1_27-Apr-2014.mat','zhengqianning_Whole1_20-Apr-2014.mat'};
    % the original subs before adding a whole bunch of subs
    % matfiles = {'abduletif_Whole1_13-Apr-2014.mat','chenziyu_Whole1_19-Apr-2014.mat','dongyinan_Whole1_17-Apr-2014.mat','gaorenqiang_Whole1_20-Apr-2014.mat','guoyanlin_Whole1_19-Apr-2014.mat','jinchao_Whole1_19-Apr-2014.mat','lintingrui_Whole1_17-Apr-2014.mat','liuyang_Whole1_19-Apr-2014.mat','maoheting_Whole1_20-Apr-2014.mat','mominjan_Whole1_13-Apr-2014.mat','pahriya_Whole1_13-Apr-2014.mat','tanghuijuan_Whole1_20-Apr-2014.mat','wangsixue_Whole1_19-Apr-2014.mat','xuhuaxuan_Whole1_17-Apr-2014.mat','xumiaomiao_Whole1_19-Apr-2014.mat','yuzhanyuan_Whole1_18-Apr-2014.mat','zhanghuaigong_Whole1_18-Apr-2014.mat','zhanglinlin_Whole1_20-Apr-2014.mat','zhaoxiubo_Whole1_20-Apr-2014.mat','zhaoyutian_Whole1_17-Apr-2014.mat','zhengnanjian_Whole1_19-Apr-2014.mat','zhengqianning_Whole1_20-Apr-2014.mat'};
    
    % single face subs
%     matfiles = {'changzhao_Whole1_07-May-2014.mat','guoxin_Whole1_07-May-2014.mat','liangxiao_Whole1_07-May-2014.mat','zhangfengqiang_Whole1_07-May-2014.mat'};
    alldata = cell(numel(matfiles),1);
    DS = dataset();
    TDS = dataset();
    for i=1:numel(matfiles)
        % check if all data is with the same structure as described above
        % already done, and YES
        s=load(matfiles{i});
        s.wrkspc = orderfields(s.wrkspc, {'Octal','DotRot','ImEval'});
        s.ques = orderfields(s.ques, {'LSAS','IRI'});
        tasks = fieldnames(s.wrkspc);
        
        Disp(matfiles{i},mode.inspect);
        Disp(size(fieldnames(s.wrkspc)),mode.inspect);
        Disp(size(fieldnames(s.ques)),mode.inspect);
        
        if mode.picture
            figure;
            set(gcf,'Units','normalized','Position',[0 0 1 1])
            pn = 2;
            pidx = reshape(1:numel(tasks)*pn,[],pn);
        end
        
        for ii = 1:numel(tasks)
            Disp(tasks{ii},mode.inspect);
            Trials = s.wrkspc.(tasks{ii}).Trials;
            switch tasks{ii}
                case 'ImEval'
                    validres = [1:7];
                    Trials(:,2) = Trials(:,2)/7;
                    fltr = ismember(Trials(:,2),validres);
                    Trials=Trials(fltr,:);
                    dur{i}.(tasks{ii}) = digest2(Trials(:,2),{Trials(:,1)}, {1:4},'mean');
                    durnorm{i}.(tasks{ii}) = digest2(Trials(:,3),{Trials(:,1)}, {1:4}, 'mean'); % RT stored here
                    
                case {'Octal','DotRot'}
                    if mode.keepnoresponse
                        validres = [0 3 4];
                    else
                        validres = [3 4];
                    end
                    fltr = ismember(Trials(:,2),validres);
                    Trials=Trials(fltr,:);
                    Trials(:,end+1) = Trials(:,3) / mean(Trials(:,3));
                    dur{i}.(tasks{ii}) = digest2(Trials(:,3),{Trials(:,1), Trials(:,2)}, {[1:4] validres},'mean');
                    durnorm{i}.(tasks{ii}) = digest2(Trials(:,end),{Trials(:,1), Trials(:,2)}, {[1:4] validres},'mean');
                    durr{i}.(tasks{ii}) = digest2(Trials(:,3),{Trials(:,2)}, {validres}, 'mean');
                    nshift{i}.(tasks{ii}) = digest2(Trials(:,5),{Trials(:,1), Trials(:,2)}, {[1:4] validres},'sum');
                otherwise
                    error('what task is this?');
            end
            
            if mode.picture
                subplot(pn,numel(tasks),pidx(ii,1));
                histfit(Trials(:,3));
                subplot(pn,numel(tasks),pidx(ii,2));
                boxplot(Trials(:,3),[Trials(:,2) Trials(:,1)]);
                % boxplot(Trials(:,3),[Trials(:,2)]);
                xlabel(tasks{ii});
            end
            if mode.inspect;tabulate(Trials(:,2));end
            
            Disp(correct(s.ques.LSAS.encode.scale),mode.inspect);
            Disp(s.ques.IRI.encode.scale,mode.inspect);
            
        end
        
        if mode.picture
            title(['LSAShigh=' num2str(s.isForced==0) ':' matfiles{i}]);
        end
        
        if mode.interactive
            iswanted = input('Include this sub for processing? 1 for yes, 0 for no:\n');
        else
            iswanted = 1;
        end
        
        if iswanted
            [ids, itds] = singleds(s, dur, durnorm, durr, nshift, i);
            DS = [DS; ids];
            TDS = [TDS; itds];
            alldata{i} = s;
            stat.mfile{i} = matfiles{i};
            Disp([matfiles{i} ' added!'],mode.verbose);
        else
            Disp([matfiles{i} ' skipped!'],mode.verbose);
        end
        close all;
        Disp('-------------------',mode.verbose);
        
    end
    
        writeDS('PLWGroup-single', mode, DS);
        writeDS('PLWGroupCollapsed-single', mode, TDS);
    
        stat.ds = DS;
        stat.tds = TDS;
        stat.dur = dur;
        stat.durnorm = durnorm;
        stat.durr = durr;
        
%% now plot
        
        % export(grpstats(a.ds,{'condition','restype','LSAShigh'},{'mean','std'},'DataVars',{'tplw','tdot','tnormplw', 'tnormdot'}),'file','xtabs.csv','Delimiter',',');
        grp.data = {'tnormplw', 'tnormdot'};
        grp.name = {'condition','LSAShigh','restype'};
        if mode.keepnoresponse
            grp.level = {{'负性','中性','正性','基线'},{'低焦虑','高焦虑'},{'无反应','朝里','朝外'},{'PLW','散点'}};
        else
            grp.level = {{'负性','中性','正性','基线'},{'低焦虑','高焦虑'},{'朝里','朝外'},{'PLW','散点'}};
        end
        grp.fname = 'condLSASTaskDur';
        grp.txy = {'','情绪面孔背景图片的语义分布','标准化持续主导时间/s'};
        stat.xtabs{1} = grpstats(stat.ds, grp.name,{'mean','std'},'DataVars',grp.data);
        stat.plt{1} = plthandle(stat.xtabs{1}, grp);
        
        grp.data = {'nshiftplw', 'nshiftdot'};
        grp.fname = 'condLSASTaskShift';
        grp.txy = {'','情绪面孔背景图片的语义分布','知觉主导方向切换次数'};
        stat.xtabs{3} = grpstats(stat.ds, grp.name,{'mean','std'},'DataVars',grp.data);
        stat.plt{3} = plthandle(stat.xtabs{3}, grp);
        
        grp.data = {'tnormplw', 'tnormdot'};
        grp.name = {'restype','LSAShigh'};
        if mode.keepnoresponse
            grp.level = {{'无反应','朝里','朝外'},{'低焦虑','高焦虑'},{'PLW','散点'}};
        else
        grp.level = {{'朝里','朝外'},{'低焦虑','高焦虑'},{'PLW','散点'}};
        end
        grp.fname = 'typeLSASDur';
        grp.txy = {'','知觉主导方向（反应类型）','标准化持续主导时间/s'};
        stat.xtabs{2} = grpstats(stat.ds, grp.name,{'mean','std'},'DataVars',grp.data);
        stat.plt{2} = plthandle(stat.xtabs{2}, grp);
        
        grp.data = {'nshiftplw', 'nshiftdot'};
        grp.fname = 'typeLSASShift';
        grp.txy = {'','知觉主导方向（反应类型）','知觉主导方向切换次数'};
        stat.xtabs{4} = grpstats(stat.ds, grp.name,{'mean','std'},'DataVars',grp.data);
        stat.plt{4} = plthandle(stat.xtabs{4}, grp);
        
        if mode.meanpic
        if mode.isline;prefix=['lines'];else;prefix=['bars'];end
        for ih=1:4
        h{ih}=grpLine(stat.plt{ih}.x, stat.plt{ih}.idx, stat.plt{ih}.gnames, stat.plt{ih}.txy, mode);
        if mode.write;
            picname = ['tmp/' prefix '_' stat.plt{ih}.fname];
            set(gcf,'PaperPositionMode','auto');
            print(h{ih},'-dpng','-r120',picname);
            Disp([picname 'image saved!'], mode.verbose);
        end
        end
        end

        
        stat.corr.name={'tplw','tdot','tnormplw', 'tnormdot', 'rplw', 'rdot', 'nshiftplw', 'nshiftdot', 'PT', 'EC', 'IRI', 'LSAS', 'fear', 'avoid'};
        [stat.corr.r, stat.corr.p]=corr(double(grpstats(stat.ds,{'id'},{'mean'},'DataVars',stat.corr.name)));
        if mode.meanpic;corrLayer(stat.corr.r, stat.corr.p, ['id' 'count' stat.corr.name], 0.05, ~mode.verbose);end
        
catch
    save buggy;
    rethrow(lasterror);
end
%% Method
%     玉尔麦：你好！我们的基本假设是考察是否高焦虑组将bistable的PLW知觉为更朝里走（即离开自己，facing away)
%     你目前需要做的几个分析如下：
%
%     1 被试在不同平均脸部表情知觉条件下，朝里与朝外运动知觉的绝对时间以及不确定的时间，朝里与朝外以及不确定知觉
%     的相对主导时间（比值）。音变量是时间或时间比值，自变量为平均表情知觉（正性、中性和负性）。比较散点与PLW的差异
%（绝对时间算三种的-朝里、朝外和不动作；相对时间算每个被试算所有朝里和朝外的平均数，然后本别将朝里和朝外的时间除以这个平均数）
%     2 用以上同样的方法，将被试分为焦虑高低得分组，比较不同组别的PLW成绩。
%
%     3 为以上两者服务，需要求得被试的焦虑得分以及对图片的平均情绪的评价。
%
%     如果你能列一个综合的表格，给出被试姓名、性别年龄、量表分，实验条件以及行为结果，
%     我们可以做一个相关分析。你能工作一下发给我吗？
%
%     最重要的，是看一下散点与PLW的差异；以及是否能重复别人的结果：高焦虑组将bistable的PLW知觉为更朝里走。
%     如果数据有趋势，但未达到统计显著，按照经验我估计需要补被试。
%
%     论文的前言和实验部分描述，请开始写起来，自己抓紧时间。
%
%
%玉尔麦：基本结果有了。 用GLM的univariate分析，PLW情形下，高焦虑组有更多的facing viewer bias (朝外）（resp和LSASgroup的交互显著，以tnormalPLW, tnormalDot为自变量）而Dot的条件下不存在这个偏差，说明焦虑调节的是高级认知加工的事件(PLW而非散点运动）。但是，未见平均情绪这一条件的影响。总体上，朝外的知觉(即facing bias)占主导，这和之前的很多研究一致，参见之前给你的文献2013-van de Cruys-An anxiety-induced bias in the perception of a bistable point-light walker，但我们焦虑组的结果和这个文献的发现相反，需要考虑一下是什么原因，还有未观察到情绪的影响。

%% Helper functions

    function [dur, g] = digest2(orig, origG, rulesC, func)
        % origG is { , }
        % rulesC is { , }
        % func: 'mean', 'sum'
        [dur, g] = grpstats(orig, origG, {func,'gname'}); %  cond: 4; resp: 0:no; 3-inward; 4-outward
        dur = [dur str2double(g)];
        
        for j=1:numel(rulesC)
            cond(j)=numel(rulesC{j});
        end
        dur = fillhole(dur, cond, rulesC);
    end

    function [ids, itds]= singleds(s, dur, durnorm, durr, nshift, i)
        % create dataset array
        
        N = numel(dur{i}.Octal(:,2));
        
        ds.id   = repmat(i,N,1);
        ds.name = repmat(cellstr(s.wrkspc.Octal.Subinfo{1}),N,1);
        ds.phone= repmat(cellstr(s.wrkspc.Octal.Subinfo{8}),N,1);
        ds.age  = repmat(str2double(s.wrkspc.Octal.Subinfo{2}),N,1);
        ds.gender=repmat(s.wrkspc.Octal.Subinfo{3},N,1);
        ds.isForced = repmat(s.isForced,N,1);
        ds.fear = repmat(s.ques.LSAS.encode.scale{1,3},N,1)-24;
        ds.avoid = repmat(s.ques.LSAS.encode.scale{2,3},N,1)-24;
        ds.LSAS = sum([ds.fear ds.avoid],2);
        ds.LSAShigh = ds.LSAS>29.1+17.3;
        ds.PT = repmat(s.ques.IRI.encode.scale{1,3},N,1);
        ds.FS = repmat(s.ques.IRI.encode.scale{2,3},N,1);
        ds.EC = repmat(s.ques.IRI.encode.scale{3,3},N,1);
        ds.PD = repmat(s.ques.IRI.encode.scale{4,3},N,1);
        ds.IRI = sum([ds.PT, ds.FS, ds.EC, ds.PD],2);
        ds.condition = dur{i}.Octal(:,2);
        ds.restype = dur{i}.Octal(:,3);
        ds.tplw = dur{i}.Octal(:,1);
        ds.tdot = dur{i}.DotRot(:,1);
        ds.tnormplw = durnorm{i}.Octal(:,1);
        ds.tnormdot = durnorm{i}.DotRot(:,1);
        ds.ratioplw = dur{i}.Octal(:,1)./reshape(repmat(dur{i}.Octal(dur{i}.Octal(:,3)==3,1),1,numel(unique(ds.restype)))',[],1);
        ds.ratiodot = dur{i}.DotRot(:,1)./reshape(repmat(dur{i}.DotRot(dur{i}.DotRot(:,3)==3,1),1,numel(unique(ds.restype)))',[],1);
        ds.rationormplw = durnorm{i}.Octal(:,1)./reshape(repmat(durnorm{i}.Octal(durnorm{i}.Octal(:,3)==3,1),1,numel(unique(ds.restype)))',[],1);
        ds.rationormdot = durnorm{i}.DotRot(:,1)./reshape(repmat(durnorm{i}.DotRot(durnorm{i}.DotRot(:,3)==3,1),1,numel(unique(ds.restype)))',[],1);
        ds.rplw = dur{i}.Octal(:,1)./repmat(durr{i}.Octal(:,1),numel(unique(ds.condition)),1);
        ds.rdot = dur{i}.DotRot(:,1)./repmat(durr{i}.DotRot(:,1),numel(unique(ds.condition)),1);
        ds.nshiftplw = nshift{i}.Octal(:,1);
        ds.nshiftdot = nshift{i}.DotRot(:,1);
        ds.eval = reshape(repmat(dur{i}.ImEval(:,1),1,numel(unique(ds.restype)))',[],1);
        ds.evalt= reshape(repmat(durnorm{i}.ImEval(:,1),1,numel(unique(ds.restype)))',[],1);
        
        tds.id=i;
        tds.name = cellstr(s.wrkspc.Octal.Subinfo{1});
        tds.phone= cellstr(s.wrkspc.Octal.Subinfo{8});
        tds.age  = str2double(s.wrkspc.Octal.Subinfo{2});
        tds.gender=s.wrkspc.Octal.Subinfo{3};
        tds.isForced = s.isForced;
        tds.fear = s.ques.LSAS.encode.scale{1,3}-24;
        tds.avoid = s.ques.LSAS.encode.scale{2,3}-24;
        tds.LSAS = sum([tds.fear tds.avoid],2);
        tds.LSAShigh = tds.LSAS>29.1+17.3;
        tds.PT = s.ques.IRI.encode.scale{1,3};
        tds.FS = s.ques.IRI.encode.scale{2,3};
        tds.EC = s.ques.IRI.encode.scale{3,3};
        tds.PD = s.ques.IRI.encode.scale{4,3};
        tds.IRI = sum([tds.PT, tds.FS, tds.EC, tds.PD],2)';
        tds.tplw=dur{i}.Octal(:,1)';
        tds.tdot=dur{i}.DotRot(:,1)';
        tds.tnormplw=durnorm{i}.Octal(:,1)';
        tds.tnormdot=durnorm{i}.DotRot(:,1)';
        tds.rdot=durr{i}.DotRot(:,1)';
        tds.rplw=durr{i}.Octal(:,1)';
        tds.nshiftplw=nshift{i}.Octal(:,1)';
        tds.nshiftdot=nshift{i}.DotRot(:,1)';
        tds.eval=dur{i}.ImEval(:,1)';
        tds.evalt=durnorm{i}.ImEval(:,1)';
        
        ids = struct2dataset(ds);
        itds = struct2dataset(tds);
    end

    function Disp(x, verbose)
        if verbose
            disp(x);
        else
            % do nothing
        end
    end

    function scale=correct(scale)
        % LSAS -24 correction
        for ij=1:size(scale,1)
            scale{ij,3}=scale{ij,3}-24;
        end
    end

    function writeDS(fname, mode, DS)
        if mode.write
            fname=['data/Group/Whole/' fname];
            if mode.keepnoresponse;
                fname=[fname '_keep_nores.csv'];
            else
                fname=[fname '_delete_nores.csv'];
            end
            export(DS,'file',fname,'Delimiter',',');
            Disp([fname ' saved.'],mode.verbose);
        end
    end

    function plt = plthandle(xtabs, grp)
        plt.idx = double(xtabs(:,1:numel(grp.name)));
        plt.idx = repmat(plt.idx, numel(grp.data),1);
        plt.idx = [plt.idx [1*ones(size(plt.idx,1)/2,1); 2*ones(size(plt.idx,1)/2,1)]];
        plt.x = [double(xtabs(:,[end-3 end-2]));double(xtabs(:,[end-1 end]))];
        plt.x(:,2) = plt.x(:,2)./repmat(sqrt(double(xtabs(:,4))),2,1); % sem, not std
        %  plt.gnames = {{'负性情绪','中性情绪','正性情绪','基线'},{'高焦虑组','低焦虑组'},{'朝里','朝外'},{'PLW群','散点群'}};
        plt.gnames = grp.level;
        plt.txy = grp.txy;
        plt.fname = grp.fname;
    end

end
