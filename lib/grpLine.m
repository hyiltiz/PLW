function h=grpLine(x, idx, gnames, txy, mode)
% plot different lines along with their errorbars
% inputs: [x std], idx, {[group],[names],[]}

% the first idx is x axis, or used for grouping for bar chart
% second is line type
% third is dot shape
% last is used color
% consider using LineWidth, MarkerSize etc.
% txy is: {'title' 'xlabel' 'ylabel'}

% mode.errbar = 0;
% mode.isline = 0; % barchart otherwise

line.tex = {'-','--','-.',':'};
line.shape = {'^','v','o','x','+','*','s','.','d','<','>','p','h'};
line.color = {'k', 'r', 'b', 'g', 'c', 'm', 'y', 'w'};


h=figure;
hold on;
linespec = [];
dotidx = [];
legtext=[];
ydat = [];
errdat = [];
y = x(:,1);
err = x(:,2);

for igrp=1:size(idx,2)
    grp{igrp}=unique(idx(:,igrp));
end

% TODO: these switches could also be capsuled in a control loop
switch numel(gnames)
    case 3
        icolor=1;
        for ispec = 1:numel(gnames{2})
            for ishape = 1:numel(gnames{3})
                linespec = [line.tex{ispec} line.shape{ishape} line.color{icolor}];
                legtext=[legtext; [gnames{2}(ispec) '-' gnames{3}(ishape)]];
                dotidx = idx(:,2)==grp{2}(ispec) & idx(:,3)==grp{3}(ishape);
                ydat = [ydat y(dotidx)];
                errdat = [errdat err(dotidx)];
                
                % now, plot!
                if mode.isline
                if mode.errbar
                    errorbar(1:numel(gnames{1}), y(dotidx), err(dotidx), linespec);
                else
                    plot(1:numel(gnames{1}), y(dotidx), linespec);
                end
                end
            end
        end
        
    case 4
        for ispec = 1:numel(gnames{2})
            for ishape = 1:numel(gnames{3})
                for icolor = 1:numel(gnames{4})
                    linespec = [line.tex{ispec} line.shape{ishape} line.color{icolor}];
                    legtext=[legtext; [gnames{2}(ispec) '-' gnames{4}(icolor) '-' gnames{3}(ishape)]];
                    dotidx = idx(:,2)==grp{2}(ispec) & idx(:,3)==grp{3}(ishape) & idx(:,4)==grp{4}(icolor);
                    ydat = [ydat y(dotidx)];
                    errdat = [errdat err(dotidx)];
                    
                    % now, plot!
                    if mode.isline
                    if mode.errbar
                        errorbar(1:numel(gnames{1}), y(dotidx), err(dotidx), linespec);
                    else
                        plot(1:numel(gnames{1}), y(dotidx), linespec);
                    end
                    end
                end
            end
        end
    otherwise
        error('how come?');
end

for iline=1:size((legtext),1)
    legends{iline}=strcat(legtext{iline,:});
end

% maybe we are just requested to draw bar charts
% first var as the grouping one
if mode.isline
    xticks = 1:numel(gnames{1});
else
    if mode.errbar
        barwitherr(errdat', ydat');
    else
        bar(ydat');
    end
    set(gca,'XTick', 1:numel(legends));
    xticks = legends;
    legends = gnames{1};
    colormap bone;
end

title(txy{1});
xlabel(txy{2});
ylabel(txy{3});
legend(legends,'Location','NEO')
legend('boxoff');
box off;
set(gca,'XTick', 1:numel(xticks));
set(gca,'XTickLabel', xticks);
set(gcf,'Units','normalized','Position',[0 0 1 1])
hold off;

end