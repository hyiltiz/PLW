This is the shared drive for Multisensory Lab, PKU. Currently it is a host for Point Light Walker Visual-Audio-Tactile Demo.

To use this demo:
1. Download all the files (except .exe files, the demo does not depend on them) for your local drive.
2. Open your MATLAB and CD to the folder you have downloaded the code.
3. Run the main functions, such as RL_PLW. (you may need to change them for language support.)

WARNING: main functions other that RL_PLW may be out of date!

The main functions described above are:
PLWviewer: Psychtoolbox is not needed. Stimuli created mainly by plot(), getframe().
PLWviewerScr: Stimuli created by PTB Screen(). It mainly creates different types of stimuli by the Screen function. You may read the code to have a better understanding of the other main functions. They are based on this. It uses PLWread() to read raw data from .txt data-file, PLWtransform() to transform the raw data's formats (which actually uses some other functions such as rotx(), roty(), rotz(), orthocal() itself), PLWsound() for simple linear sound data transformation and onePLW() for displaying the PLW on the screen. UNLESS YOU ARE INTERESTED IN THE BASIC CODE SHARED BY OTHER MAIN FUNCTIONS AND JUST WANTED TO RUN THE DEMO, THIS FUNCTION IS NOT WHAT YOU WANTED.
RL_PLW: Bistable PLW Experiment's original code, and it uses RLonePLW() for displaying PLWs, and touchground() for finding the fott-ground-touching point. You may not want to run it if you are going to do the experiment. Run RL_PLW2() instead.
RL_PLW_octave: The same with RL_PLW, and it is adjusted for octave. So you can run this under Linux. It is MATLAB compatible, so you can run it under Windows by MATLAB as well.
RL_PLW2: Bistable PLW Experiment. IN MOST CASES, THIS IS WHAT YOU WANT. RUN IT FOR THE EXPERIMENT.
ClockPLW: Visual detection for group property provided audio cue. PLWs placed in a circle. This code is under development. It uses ClockonePLW() for creating a PLW on the screen.

Other .mat files are used for collecting experiment data and for debugging.Data for collecting experiment data has a prefix with the main function related to the experiment. You may not need other .mat files unless you are debugging.

