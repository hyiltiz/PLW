%%% BEGIN CODE %%%
%%% Main fuction + 2 subfunctions %%%

function result = SearchReplace( TopDirectory , FileExtension , expr, repstr )
%SEARCHREPLACE Search and Replace recursively using Regular Expressions
%
% TopDirectory c:\matlabcode
%
% FileExtension *.m or m for example
%
% expr is a regular expression
%
% repstr is the string to replace when expr is found


% filenames = FindFiles( TopDirectory , FileExtension );

% Do NOT use FindFiles, it act strangely
% only provide one file each time

filenames = [TopDirectory filesep FileExtension];

for ii = 1:size(filenames,1)
    result = DoSearchReplace( filenames(ii,:) , expr , repstr );
end

return;

%--------------------------------------------------------------------%

function filenames = FindFiles( TopDirectory , FileExtension )

% Remove trailing slash
if TopDirectory(end) == '/' || TopDirectory(end) == '/'
    TopDirectory(end) ='';
end

% Manipulate FileExtension
% We need it in the form *.x
if length(FileExtension) < 3
    FileExtension = [ '*.m' FileExtension ];
end

filenames = []; %Preallocate
r = (genpath(TopDirectory));
while r
    [pt,r] = strtok( r , pathsep );
    r=r(2:end); % Remove leading ;
    mf = dir( [ pt filesep FileExtension ] );
    if ~isempty(mf)
        fpath = repmat( [pt filesep] , size(mf) , 1 );
        files = strvcat( mf.name );
        filenames = strvcat( filenames , [fpath files] );
    end
end
return;

%--------------------------------------------------------------------%

function result = DoSearchReplace( filename , expr , repstr )
%DOSEARCHREPLACE

% Read in file
try
    FileReadIn = textread( filename,'%s','delimiter','\n','whitespace','');
catch
    errmsg = lasterr;
    disp(errmsg)
    result = 0;
    return
end

% Use Regular Expressions to search and replace
try
    s = regexprep( FileReadIn , expr , repstr );
catch
    errmsg = lasterr;
    disp(errmsg)
    result = 0;
    return
end

% Write out cell array to file
try
    fich=fopen( filename , 'wt' );
    fprintf( fich ,'%s\n', s{:} );
    fclose( fich );
catch
    errmsg = lasterr;
    disp(errmsg)
    result = 0;
    return
end

result = 1; % Success
return;