This file describes the structure of the ./data directory, where lies all 
the files for experiments concerning PLW, acquired either running RL_PLW,
StaticChoice, *Baseline*.m directly or indirectly.

Each directory contains corresponding data files in .mat file Version 7, 
and the needed analysis program as a analysis*.m script, along with some
outputs of this analysis*.m script, such as png, doc, xls files.

mat files mostly saves data in a matrix called `Trials', except those saved
from *Baseline*.m; these saves data in `totaltrials'.
The meaning of each of its column can be learned from the analysis*.m file 
in the same directory, or by inspecting ./lib/getResponseU.m and *Baseline*
file correspondingly.

The following diagram illustrates the structure of this directory.

data
©À©¤Direction 
©¦  ©¦  analysis2012tactilerecode3DirectionTask.m 
©¦  ©¦  DirectionTask_Standard.png 
©¦  ©¦  <name>MirrorD<date>.mat 
©¦  ©¦  guoxinMirrorD02-Mar-2013.mat 
©¦  ©¦   
©¦  ©¸©¤Direction_baseline 
©¦          analysisDirection_baseline.m 
©¦          DirectionTaskBaseline_Standard.png 
©¦          <name>.mat 
©¦          hejiahuang.mat 
©¦           
©À©¤Group = StaticChoice('LSAS')->OctalTask/DotRotTask->ImEvalTask->StaticChoice('IRI')
©¦  ©¦  # contains data acquired by OctalTask, DotRotTask, ImEvalTask seperately
©¦  ©¦  # use ./Whole/*.mat directly, NOT this files
©¦  ©¦  <name>D_DotRot_13-Apr-2014.mat 
©¦  ©¦  <name>D_Octal_13-Apr-2014.mat 
©¦  ©¦  mominjanD_DotRot_13-Apr-2014.mat 
©¦  ©¦  mominjanD_Octal_13-Apr-2014.mat 
©¦  ©¦   
©¦  ©¸©¤Whole 
©¦           # contains data acquired by those 5 tasks
©¦           # use direcly and do NOT consider using ./data/Group/*.mat
©¦           analysisGroupTask.m
©¦           <name>_Whole1_13-Apr-2014.mat 
©¦           mominjan_Whole1_13-Apr-2014.mat 
©¦           
©À©¤InOut 
©¦  ©¦  analysis2012tactilerecode3InOut.m 
©¦  ©¦  InOutTask_Standard.png 
©¦  ©¦  <name>MirrorD_InOut_17-Sep-2013.mat 
©¦  ©¦  lilingyuMirrorD_InOut_15-Sep-2013.mat 
©¦  ©¦   
©¦  ©¸©¤InOut_baseline 
©¦          analysisInOut_baseline.m 
©¦          InOutTaskBaseline_Standard.png 
©¦          <name>.mat 
©¦          anshuai.mat 
©¦           
©¸©¤Simple 
    ©¦  analysis2012tactilerecode3Simple.m 
    ©¦  inventoryIRI.mat                     # IRI test scores as matfile
    ©¦  SimpleTaskÎÊ¾íÂ¼Èë.xls        # IRI test scores as xls file (full)
    ©¦  mean_standardized.EC.png 
    ©¦  mean_standardized_all.png 
    ©¦  mean_standardized_PT.png 
    ©¦  <name>MirrorD_simple_12-Oct-2013.mat 
    ©¦  penghuilinMirrorD_simple_12-Oct-2013.mat 
    ©¦   
    ©¸©¤Simple_baseline 
            analysisSimple_baseline.m 
            Simple_baseline_Standardized.png 
            # either matfiles with or without _Simple_ in this directory
            # are of the same format saved from the same single program
            # PLWTactileBaseInOutSimple.m, and are all used by their 
            # analysis file analysisSimple_baseline.m 
            # NOTE: nothing abnormal here, and I rechecked for confirmation
            <name>_Simple_.mat 
            <name>.mat 
            mesede_Simple_.mat 
            penghuilin.mat 