function [paths, imnames]= imList(condition, isFull, issinglePLW)
% choose images based on the condition
isSkip = 1;
if ~isSkip
    isFull = 1;
end

 %weight of each type of images
 %gender is normalized, only control emotion
 %for now, no neutral face used
 if ~issinglePLW
 switch condition
     case 1
         % anger
         weight = [6 0 2 0];
     case 2
         % balanced
         % SHOULD WE USE NEUTRAL FACES INSTEAD?
         %             weight = [4 0 4];
         weight = [0 8 0 0];
     case 3
         % happy
         weight = [2 0 6 0];
     case 4
         % no image here; return blank image path
         weight = [0 0 0 8];
     otherwise
         error ('invalid condition!');
 end

else
switch condition
    case 1
        % anger
        weight = [1 0 0 0];
    case 2
        % balanced
        % SHOULD WE USE NEUTRAL FACES INSTEAD?
        %             weight = [4 0 4];
        weight = [0 1 0 0];
    case 3
        % happy
        weight = [1 0 0 0];
    case 4
        % no image here; return blank image path
        weight = [0 0 0 1];
    otherwise
        error ('invalid condition!');
end
end

storage = reshape([37 37 113 109 123 125]', [2 3]);
imidx = cell(size(storage));
% idmidx: number of images we have for each type
%            anger     neu     happy
% 1:male     37        113     123
% 2:female   37        109     125
if isFull
    for gender=1:size(storage,1)
        for emo=1:size(storage,2)
            imidx(gender, emo) = 1:storage(gender, emo);
        end
    end

else
    % some of the images are quite poor
    % provide them manually by setting a threshould of 85

    imidx = {[10, 11, 17, 18, 2, 20, 3, 30, 31, 34, 37, 4, 6, 7, 8], [10, 100, 101, 102, 103, 104, 107, 108, 109, 11, 110, 111, 113, 14, 15, 16, 18, 21, 24, 27, 29, 30, 31, 32, 33, 34, 35, 39, 43, 44, 46, 48, 49, 5, 51, 52, 55, 56, 57, 60, 61, 63, 65, 8, 80, 85, 86, 88, 89, 90, 91, 92, 93, 95, 98, 99], [1, 10, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 11, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 12, 120, 121, 122, 123, 13, 14, 15, 17, 19, 2, 21, 22, 23, 25, 26, 27, 29, 3, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 45, 46, 47, 48, 49, 5, 50, 51, 52, 53, 55, 56, 58, 59, 6, 60, 61, 62, 66, 67, 68, 69, 7, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 8, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 9, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]; [14, 15, 21, 27, 28, 3, 34], [1, 101, 102, 104, 105, 107, 12, 13, 14, 15, 16, 18, 20, 22, 23, 27, 28, 3, 30, 31, 33, 35, 39, 4, 40, 42, 43, 46, 52, 53, 54, 57, 59, 6, 60, 62, 63, 64, 66, 67, 7, 70, 72, 73, 74, 75, 76, 77, 8, 81, 83, 85, 86, 87, 88, 91, 93, 94, 95, 96, 99], [1, 10, 100, 101, 102, 103, 104, 105, 106, 108, 109, 11, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 12, 120, 121, 122, 123, 124, 125, 14, 15, 16, 18, 19, 2, 20, 21, 23, 24, 25, 26, 27, 29, 3, 30, 32, 33, 34, 35, 36, 38, 39, 4, 40, 41, 42, 43, 44, 45, 46, 47, 48, 5, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 6, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 7, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 8, 80, 81, 82, 83, 84, 85, 86, 88, 89, 9, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]};

end

emotions = {'1anger', '6neutral', '7happy'};
eemm = {'A' 'NE' 'H'};
genders = {'male', 'female'};
ggee = {'M' 'F'};

path = './resources/facestimuli/';
paths = cell(sum(weight),1);
imnames = cell(sum(weight),1);

if ~sum(weight(1:3))
    % return blank page
    imname = 'BLANK';
    path = [path imname];
    path = [path '.BMP'];
    for iim=1:8
        paths{iim}=path;
        imnames{iim}=imname;
    end
else
    iim = 0;
    for iemotion=1:3
        if weight(iemotion)
            for irep=1:weight(iemotion)
                path = './resources/facestimuli/';
                igender=round(rand)+1;
                imlist = imidx{igender, iemotion};
                %                     keyboard
                randNumbers = randperm(numel(imlist));
                imid = num2str(imlist(randNumbers(1)));
                imname = [eemm{iemotion} ggee{igender} imid];
                path = [path emotions{iemotion} '/' genders{igender} '/' imname];
                path = [path '.BMP'];
                iim = iim+1;
                %                     keyboard
                paths{iim}=path;
                imnames{iim}=imname;
            end
        else
            % do not need this emotion, do nothing
        end
    end

    % now shuffle the paths
    idxrand = randperm(numel(paths));
    paths = paths(idxrand);
    imnames = imnames(idxrand);
end
