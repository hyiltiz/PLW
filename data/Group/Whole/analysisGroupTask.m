%% description
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
wrkspc.<octal>.data.imagePaths	images used for each Trials

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