function [DS, dur, durnorm, durr, alldata] = analysisGroupTask
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

mode.verbose = 0;
mode.interactive = 0;

if mode.interactive
    mode.verbose = 1;
end

try
    matfiles = cellstr(ls('data/Group/Whole/*.mat'));
    % matfiles = {'liuyang_Whole1_19-Apr-2014.mat'};
    alldata = cell(numel(matfiles),1);
    DS = dataset();
    for i=1:numel(matfiles)
        % check if all data is with the same structure as described above
        % already done, and YES
        s=load(matfiles{i});
        s.wrkspc = orderfields(s.wrkspc, {'Octal','DotRot','ImEval'});
        s.ques = orderfields(s.ques, {'LSAS','IRI'});
        tasks = fieldnames(s.wrkspc);
        
        if mode.verbose
            disp(matfiles{i});
            disp(size(fieldnames(wrkspc)));
            disp(size(fieldnames(ques)));
        end
        
        if mode.verbose
            figure;
            set(gcf,'Units','normalized','Position',[0 0 1 1])
            pn = 2;
            pidx = reshape(1:numel(tasks)*pn,[],pn);
        end
        
        for ii = 1:numel(tasks)
            disp(tasks{ii});
            Trials = s.wrkspc.(tasks{ii}).Trials;
            switch tasks{ii}
                case 'ImEval'
                    validres = [1:7];
                    Trials(:,2) = Trials(:,2)/7;
                    dur{i}.(tasks{ii}) = digest1(Trials(:,2),{Trials(:,1)}, validres);
                    durnorm{i}.(tasks{ii}) = digest1(Trials(:,3),{Trials(:,1)}, validres); % RT stored here
                    
                case {'Octal','DotRot'}
                    validres = [0 3 4];
                    fltr = ismember(Trials(:,2),validres);
                    Trials=Trials(fltr,:);
                    Trials(:,end+1) = Trials(:,3) / mean(Trials(:,3));
                    dur{i}.(tasks{ii}) = digest2(Trials(:,3),{Trials(:,1), Trials(:,2)}, validres);
                    durnorm{i}.(tasks{ii}) = digest2(Trials(:,end),{Trials(:,1), Trials(:,2)}, validres);
                    durr{i}.(tasks{ii}) = digest1(Trials(:,3),{Trials(:,2)}, validres);
                otherwise
                    error('what task is this?');
            end
            
            if mode.verbose
                subplot(pn,numel(tasks),pidx(ii,1));
                histfit(Trials(:,3));
                subplot(pn,numel(tasks),pidx(ii,2));
                boxplot(Trials(:,3),[Trials(:,2) Trials(:,1)]);
                % boxplot(Trials(:,3),[Trials(:,2)]);
                xlabel(tasks{ii});
            end
            tabulate(Trials(:,2));
            
        end
        
        if mode.verbose
            title(['LSAShigh=' num2str(s.isForced==0) ':' matfiles{i}]);
        end
        
        if mode.interactive
            iswanted = input('wanted?\n');
        else
            iswanted = 1;
        end
        
        if iswanted
            ids = singleds(s, dur, durnorm, durr, i);
            DS = [DS; ids];
            disp([matfiles{i} ' added!']);
        else
            disp([matfiles{i} ' skipped!']);
        end
        disp('-------------------');
        
        alldata{i} = s;
        
    end
    
    export(DS,'file','data/Group/Whole/PLWGroup.csv','Delimiter',',');
    disp('dataframe data/Group/Whole/PLWGroup.csv saved.');
    
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

%% Helper functions

    function [dur g] = digest2(orig, origG, validres)
        % origG is { , }
        [dur g] = grpstats(orig, origG, {'mean','gname'}); %  cond: 4; resp: 0:no; 3-inward; 4-outward
        for j=1:length(g)
            dur(j,2)=str2num(g{j,1});
            dur(j,3)=str2num(g{j,2});
        end
        
        for j=1:4 % cond
            idxtemp=find(dur(:,2)==j); % which cond
            if isempty(idxtemp)
                dur(size(dur,1)+1,:) = [eps j validres(1)];
            end
            
            durtemp=dur(idxtemp,:);
            for resp=validres % for four conditions-"congruent","incongruent","bistable","baseline";
                idxresp = find(durtemp(:,3)==resp);
                if isempty(idxresp)
                    dur(size(dur,1)+1,:) = [eps j resp];
                end
            end
        end
        dur = sortrows(dur,[2 3]);
    end

    function [dur g] = digest1(orig, origG, validres)
        % origG is { , }
        [dur g] = grpstats(orig, origG, {'mean','gname'}); %  cond: 4; resp: 0:no; 3-inward; 4-outward
        for j=1:length(g)
            dur(j,2)=str2num(g{j,1});
        end
        
        % actually this is not needed; only single response can be made
        %         for j=1:4 % cond
        %             idxtemp=find(dur(:,2)==j); % which cond
        %             if isempty(idxtemp)
        %                 dur(size(dur,1)+1,:) = [eps j validres(1)];
        %             end
        %         end
    end

    function ids = singleds(s, dur, durnorm, durr, i)
        % create dataset array
        
        N = numel(dur{i}.Octal(:,2));
        
        ds.id   = repmat(i,N,1);
        ds.name = repmat(cellstr(s.wrkspc.Octal.Subinfo{1}),N,1);
        ds.phone= repmat(cellstr(s.wrkspc.Octal.Subinfo{8}),N,1);
        ds.age  = repmat(str2double(s.wrkspc.Octal.Subinfo{2}),N,1);
        ds.gender=repmat(s.wrkspc.Octal.Subinfo{3},N,1);
        ds.fear = repmat(s.ques.LSAS.encode.scale{1,3},N,1);
        ds.avoid = repmat(s.ques.LSAS.encode.scale{2,3},N,1);
        ds.PT = repmat(s.ques.IRI.encode.scale{1,3},N,1);
        ds.FS = repmat(s.ques.IRI.encode.scale{2,3},N,1);
        ds.EC = repmat(s.ques.IRI.encode.scale{3,3},N,1);
        ds.PD = repmat(s.ques.IRI.encode.scale{4,3},N,1);
        ds.LSAShigh = repmat(s.isForced==0,N,1);
        ds.condition = dur{i}.Octal(:,2);
        ds.restype = dur{i}.Octal(:,3);
        ds.tplw = dur{i}.Octal(:,1);
        ds.tdot = dur{i}.DotRot(:,1);
        ds.tnormplw = durnorm{i}.Octal(:,1);
        ds.tnormdot = durnorm{i}.DotRot(:,1);
        ds.ratioplw = dur{i}.Octal(:,1)./reshape(repmat(dur{i}.Octal(dur{i}.Octal(:,3)==3,1),1,3)',[],1);
        ds.ratiodot = dur{i}.DotRot(:,1)./reshape(repmat(dur{i}.DotRot(dur{i}.DotRot(:,3)==3,1),1,3)',[],1);
        ds.rationormplw = durnorm{i}.Octal(:,1)./reshape(repmat(durnorm{i}.Octal(durnorm{i}.Octal(:,3)==3,1),1,3)',[],1);
        ds.rationormdot = durnorm{i}.DotRot(:,1)./reshape(repmat(durnorm{i}.DotRot(durnorm{i}.DotRot(:,3)==3,1),1,3)',[],1);
        ds.rplw = dur{i}.Octal(:,1)./repmat(durr{i}.Octal(:,1),4,1);
        ds.rdot = dur{i}.DotRot(:,1)./repmat(durr{i}.DotRot(:,1),4,1);
        ds.eval = reshape(repmat(dur{i}.ImEval(:,1),1,3)',[],1);
        ds.evalt= reshape(repmat(durnorm{i}.ImEval(:,1),1,3)',[],1);
        
        ids = struct2dataset(ds);
    end

end
