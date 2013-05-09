function readData = PLWread(path)
%data is a struct with fields: jointspos framenum thet jointsnum dotnum.
% this is for CMU motion data set!
jointsnum = 13;   % number of joints
dotnum = 1:jointsnum;%[17  19 20 21  26 27 28  3 4 5  8 9 10];

%finalized version done on 8/20
%it appears the joint numbers are arranged in a series like 26 27 28.
%Order of joints: head; l shoulder; l elbow, l hand; r shoulder; r elbow; r
%hand; l hip; l knee; l foot; r hip; r knee; r foot;
thet= 0;  %viewpoint

%% read in 3d output file
% fp3d = fopen(sprintf('%s.data3d.txt',filename),'r');
fp3d = fopen(sprintf(path),'r');
s=fscanf(fp3d,'%f %f %f %f %f %f %f %f %f %f %f %f %f ');%,[1029 jointsnum]textread(fp3d,'delimiter', ' ');% %fscanf(fp3d,inputformat,[1029 jointsnum]);
fclose(fp3d);
framenum = size(s,1)/jointsnum/3;
data = reshape(s,jointsnum,framenum*3)';

%%
% in the 3ddata.txt, all frames of one joint will be in one row, the seq in one row will be f1x, f1y, f1z, f2x, f2y, f2z, f3x, f3y, f3z,....
xyzseq=[1 3 2];
jointspos = zeros(framenum, jointsnum, 3);
for frames = 1:framenum
        for xyzind=1:3
                frameind = (frames-1)*3+xyzind;
                jointspos(frames, 1:jointsnum,xyzind)=data(frameind,:);
        end
end
readData = struct('jointspos', jointspos, 'framenum', framenum, 'thet', thet, 'dotnum', dotnum, 'jointsnum', jointsnum, 'xyzseq', xyzseq);
end