function GroupTask
% this wrapper runs serveral procedures:
% 1)    STAITask
% 2.1)  OctalTask  (with PLW )
% 2.2)  DotRotTask (with dots)
% 3)    ImEvalTask
% 4)    IRITask

try
    startup;
    backdoor = '12345';
    isForced = 0;
    sques = struct();
    wrkspc= struct();
    
    Subinfo = getSubInfo();
    
%     ques.STAI = STAITask();
    ques.STAI.isOK=1;
    
    if ~ques.STAI.isOK
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
    
    if ques.STAI.isOK || isForced
        grp.suffix = '_Whole1_';
        
        % decide the order of OctalTask and DotRotTask
        isPLWFirst = round(rand);
        
        if isPLWFirst
            wrkspc.Octal = OctalTask(0, Subinfo);
            wrkspc.DotRot= DotRotTask(0, Subinfo);
        else
            wrkspc.Octal = OctalTask(0, Subinfo);
            wrkspc.DotRot= DotRotTask(0, Subinfo);
        end
        
        ques.IRI = IRITask();
    end

    save(['data/Group/Whole/', Subinfo{1}, grp.suffix, date, '.mat'],'wrkspc','ques', 'isPLWFirst','isForced');
catch
    psychrethrow(psychlasterror);
    sca;
    save(['data/Group/Whole/', Subinfo{1}, grp.suffix, date, '_buggy.mat'],'wrkspc','ques', 'isPLWFirst','isForced');
end
end