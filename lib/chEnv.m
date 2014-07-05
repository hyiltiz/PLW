function chEnv(env, val)
% conveniently substitude lines of code in specified files

% ABUSE OF THIS FUNCTION CAN SERIOUSLY BREAK YOUR CODEBASE
% USE WITH CAUTION

% only provide strings for input, both env and val
% use only one of these calls:
% 
% calls                     purpose
% chEnv('debug', '1');      %set the environment for debugging:mode.debug_on
% chEnv('flpi', '0.02');    %sets flip interval to 50Hz, for LCD; this does does not change whole env to debug=1, differing from above
% chEnv('debug', '0');      %for normal experiment, also sets conf.flpi=0.02 automatically
% chEnv('flpi', '0.01');    %this can only be used for experiment with CRT


libfiles = ls('lib/*Task.m');
Taskfiles = [cellstr(ls('*Task.m')); cellstr([repmat(['lib', filesep], size(libfiles,1),1) libfiles])];


s_debug_mode = '(mode.debug_on\s*=\s*)(\d)(\s*;)';
s_flpi = '(conf.flpi\s*=\s*)(\d\.\d\d)(\s*;)';
s_eng = '(mode.english_on\s*=\s*)(\d)(\s*;)';

switch env
    case 'debug'
        s_rep = s_debug_mode;
    case 'd'
        s_rep = s_debug_mode;
    case 'flpi'
        s_rep = s_flpi;
    case 'f'
        s_rep = s_flpi;
    case 'english'
        s_rep = s_eng;
    case 'e'
        s_rep = s_eng;
    otherwise
        s_rep = s_flpi;
end

s_val = ['$1' val '$3'];

for i=1:size(Taskfiles,1)
    SearchReplace(pwd, Taskfiles{i}, s_rep, s_val)
end

disp(Taskfiles);
end