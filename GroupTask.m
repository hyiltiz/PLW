function GroupTask
% this wrapper runs serveral procedures:
% 1)    STAITask
% 2.1)  OctalTask  (with PLW )
% 2.2)  DotRotTask (with dots)
% 3)    ImEvalTask
% 4)    IRITask

try
    backdoor = '12345';
    
    Subinfo = getSubInfo();
    
    ques.STAI = STAITask();
    
    if ~ques.STAI.isOK
        % backdoor, manually continue
        tmp.reply = input('Force proceed?\n', 's');
        if strcmp(tmp.reply, backdoor)
            isForced =1;
            tmp.suffix = '_Whole11_';
        end
    else
        % CANNOT go on to the following procedure
        tmp.suffix = '_Whole0_';
    end
    
    if ques.STAI.isOK || isForced
        tmp.suffix = '_Whole1_';
        
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
    
    save(['data/Group/Whole/', Subinfo{1}, tmp.suffix, date, '.mat'],'wrkspc','ques', 'isPLWFirst','isForced');
catch
    save(['data/Group/Whole/', Subinfo{1}, tmp.suffix, date, '_buggy.mat'],'wrkspc','ques', 'isPLWFirst','isForced');
end
end