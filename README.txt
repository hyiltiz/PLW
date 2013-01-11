This is the a MATLAB/OCTAVE code using Psychtoolbox-3 about biological motion, for Multisensory Lab, PKU.

To use this demo:
1. Download all the files and folders (except .exe files, the demo does not depend on them) for your local drive.
2. Open your MATLAB and CD to the folder you have downloaded the code.
3. Run the main functions, such as RL_PLW. (you may need to change them for language support.)

##########################################################

DESCRIPTION

The main functions in the program are:
WARNING: MAIN FUNCTIONS OTHER THAN RL_PLW MAY BE OUT OF DATE!

RL_PLW: Bistable PLW Experiment's original code, and it uses RLonePLW() for displaying PLWs, and touchground() for finding the fott-ground-touching point. You may not want to run it if you are going to do the experiment. Run RL_PLW2() instead.

The main functions descrided below is NOT what you needed if you only NEED TO RUN THE PROGRAM FOR THE EXPERIMENT.
PLWviewer: Psychtoolbox is not needed. Stimuli created mainly by plot(), getframe().
------------------------
PLWviewerScr: Stimuli created by PTB Screen(). It mainly creates different types of stimuli by the Screen function. You may read the code to have a better understanding of the other main functions. They are based on this. It uses PLWread() to read raw data from .txt data-file, PLWtransform() to transform the raw data's formats (which actually uses some other functions such as rotx(), roty(), rotz(), orthocal() itself), PLWsound() for simple linear sound data transformation and onePLW() for displaying the PLW on the screen. UNLESS YOU ARE INTERESTED IN THE BASIC CODE SHARED BY OTHER MAIN FUNCTIONS AND JUST WANTED TO RUN THE DEMO, THIS FUNCTION IS NOT WHAT YOU WANTED.

RL_PLW_octave: (this function is out of date. RL_PLW() by itself, already supports OCTAVE now!) The same with RL_PLW, and it is adjusted for octave. So you can run this under Linux. It is MATLAB compatible, so you can run it under Windows by MATLAB as well.

RL_PLW2: (this function is out of date. RL_PLW() by itself) Bistable PLW Experiment. IN MOST CASES, THIS IS WHAT YOU WANT. RUN IT FOR THE EXPERIMENT.

ClockPLW: Visual detection for group property provided audio cue. PLWs placed in a circle. This code is under development. It uses ClockonePLW() for creating a PLW on the screen.
------------------------

Other .mat files in ./data directory are used for collecting experiment data and for debugging. Data for collecting experiment data has a prefix with the main function related to the experiment. You may NOT Need other .mat files unless you are debugging.



VARIABLES DEFINITION USED IN THE MAIN FUNCTION RL_PLW()
##########################################################
##   Assign variables below for your spesific needs!  ####
##########################################################
mode switch to control the mode of program should run in.
mode:

english_on
tactile_on
debug_on
audio_on
regenerate_on

##########################################################
configuration for changing experiment conditions
conf:

ntdurflp
nvterrflp
repetitions
scale1
imagex
waitBetweenTrials
waitFixationScreen
flpi


##########################################################
##  Variables below is not to be edited manually! ########
##########################################################
flow control variables:
flow:

theTrial
theFlip
isresponse
response
prestate
isquit
Trialsequence

##########################################################
control rendering visual and auditory stimuli:
render:

kb
screenNumber
screens
wsize
ifi
vlb
cx
cy
w
dstRect
dioIn
dioOut
iniTimer

##########################################################
data construction for rendering:
data:

filename
lefttouch
righttouch
moveDirection
paceRate
readData
Track
tTrack
vTrack
initPosition
dotx
dotx1
doty
doty1
T

##########################################################
data collected and intended to be analyzed later:
Subinfo
Trials
      Trials(:,1) is the trial type. Since all the conditions is purely randomized, this value is does not effect anything.
      Trials(:,2) is the response type of the participant; 1 indicating right, while 2 left, and 0 both or none.
      Trials(:,3) is duration time of the response in corresopnding Trials(:,2)
      Trials(:,4) is the heading of the red PLW, which can be used when comparing to the response type in Trials(:,2). 0 indicates heading (walking direction) is towards right, while 1 is left. The other PLW's heading is always in opposite direction.
      Trials(:,5) is the upright-inverse type of the red PLW. 0 means the red PLW is upright, while 1 is upside-down. The other PLW is in align with the red PLW.
      Trials(:,6) is the number of the trial, begins from 1
      Trials(:,7) is the initial tactile stimuli type. Definition is the same with response in Trials(:,2), 1 indicating right, while 2 left, and 0 is baseline, without tactile
      Trials(:,8) is the frame pitch, representing the walking speed. 1 is 130 frames per loop (which is full loop) while 2 is 130/2 frames per loop.
