function grpLine(x, idx, gnames, txy)
% plot different lines along with their errorbars
% inputs: [x std], idx, {[group],[names],[]}

% the first idx is x axis
% second is line type
% third is dot shape
% last is used color
% consider using LineWidth, MarkerSize etc.
% txy is: {'title' 'xlabel' 'ylabel'}

mode.errbar = 0;

line.tex = {'-',':','-.','--'};
line.shape = {'^','v','o','x','+','*','s','.','d','<','>','p','h'};
line.color = {'k', 'r', 'b', 'g', 'c', 'm', 'y', 'w'};


h=figure;
hold on;
linespec = [];
dotidx = [];
legtext=[];
y = x(:,1);
err = x(:,2);

for igrp=1:size(idx,2)
    grp{igrp}=unique(idx(:,igrp));
end

for ispec = 1:numel(gnames{2})
    for ishape = 1:numel(gnames{3})
        for icolor = 1:numel(gnames{4})
            linespec = [line.tex{ispec} line.shape{ishape} line.color{icolor}];
            legtext=[legtext; [gnames{2}(ispec) '-' gnames{4}(icolor) '-' gnames{3}(ishape)]];
            dotidx = idx(:,2)==grp{2}(ispec) & idx(:,3)==grp{3}(ishape) & idx(:,4)==grp{4}(icolor);
            
            % now, plot!
            if mode.errbar
                errorbar(1:numel(gnames{1}), y(dotidx), err(dotidx), linespec);
            else
                plot(1:numel(gnames{1}), y(dotidx), linespec);
            end
        end
    end
    
end

for iline=1:size((legtext),1)
    legends{iline}=strcat(legtext{iline,:});
end

title(txy{1});
xlabel(txy{2});
ylabel(txy{3});
legend(legends,'Location','NEO')
legend('boxoff');
box off;
set(gca,'XTick', 1:numel(gnames{1}));
set(gca,'XTickLabel', gnames{1});
set(gcf,'Units','normalized','Position',[0 0 1 1])


end