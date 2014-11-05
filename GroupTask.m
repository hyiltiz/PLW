function GroupTask(isSingle)
% this wrapper runs serveral procedures:
% 1)    LSASTask
% 2.1)  OctalTask  (with PLW )
% 2.2)  DotRotTask (with dots)
% 3)    ImEvalTask
% 4)    IRITask

if nargin==0;isSingle = 0;else isSingle=1; end; % default is OctalTask
try
    startup;
    backdoor = '12345';
    
    % init static choice:begin
    mode.debug_on = 0;
    mode.constantInstr_on = 0;
    mode.english_on = 0;
    conf.instrWait = 20;
    conf.byetime = 3;
    mode.recordImage = 0;
    % init static choice:end
    
    isForced = 0;
    sques = struct();
    wrkspc= struct();

    Subinfo = getSubInfo();

    ques.LSAS = StaticChoice('test', mode, conf);

    if ~ques.LSAS.isOK
        % backdoor, manually continue
        grp.reply = input('Force proceed?\n', 's');
        if strcmp(grp.reply, backdoor)
            isForced =1;
            grp.suffix = '_Whole11_';
        end
    else
        % CANNOT go on to the following procedure
        grp.suffix = '_Whole0_';
    end

    if ques.LSAS.isOK || isForced
        grp.suffix = '_Whole1_';

        % decide the order of OctalTask and DotRotTask
        isPLWFirst = round(rand);

        if isPLWFirst
            wrkspc.Octal = OctalTask(0, Subinfo);
            wrkspc.DotRot= DotRotTask(0, Subinfo);
        else
            wrkspc.DotRot= DotRotTask(0, Subinfo);
            wrkspc.Octal = OctalTask(0, Subinfo);
        end
        wrkspc.ImEval = ImEvalTask(0, Subinfo);

        ques.IRI = StaticChoice('IRI', mode, conf);
    end

    save(['data/Group/Whole/', Subinfo{1}, grp.suffix, date, '.mat'],'wrkspc','ques', 'isPLWFirst','isForced');
    Display(['data/Group/Whole/', Subinfo{1}, grp.suffix, date, '.mat']);
catch
    psychrethrow(psychlasterror);
    sca;
    save(['data/Group/Whole/', Subinfo{1}, grp.suffix, date, '_buggy.mat'],'wrkspc','ques', 'isPLWFirst','isForced');
end
end
