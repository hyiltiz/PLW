function h=grpLine(x, idx, gnames, txy, mode)
% plot different lines or groups of bar charts along with their errorbars
%
% inputs: [y sem], idx, {{VAR1-LEVELS}, {VAR2-LEVELS},...}, {'title' 'xlabel' 'ylabel'}, mode.[isline,errbar]
% input X is of data format long, with single observation per row
% the spesification of those observations can be givien via input IDX
% Thus, each column of IDX is one variable controlled for X. The first
% column of IDX is plotted as horizontal axis of plot for lines, or grouped
% together as one group for bar charts. For lines, the second, third and
% last column is distinguished via line type (solid, dashed etc.), marker
% shape (rectangles, squares etc.) and color.
% Name of each level for each variable defined by IDX is specified via cell
% GNAMES. Number of names for all levels for each variable should agree
% with unique values in corresponding IDX column.
% For each X, Standard Error of Sample Means, SEM, could be also given in
% order to plot error bars for either lines or bar charts.
%
% input X can also be of short data format, where rows represent major
% variable, which then is to be plotted as horizontal axis for lines, or
% grouped tohether for bar charts. IDX in this case defaults to another
% variable, or can be specified via vector [V1 V2 ...] where prod(V1,V2...)
% equals to columns of X, size(X,2). If errorbars are required (via mode),
% SEM values are also needed as the _third_ dimention of matrix X, thus X
% is of form CAT(3, Y, SEM). In IDX, the variable that rotates quickest
% comes first.
% mode.isline = 1 to plot line [default], or 0 for bar chart
% mode.errbar = 1 to plot errbars [default], which requires SEM as second
% column of X

% TODO: consider using LineWidth, MarkerSize etc. for more line plotting variables

%% input control
if nargin < 1 || ~(exist('x', 'var') && isnumeric(x))
    % no input givin; use demo
    factors = [4 2 3];
    idx = fullfact(factors);
    x = [4+randn(size(idx,1),1) 0.3*randn(size(idx,1),1)];
end

if nargin > 1 && exist('x', 'var') && isnumeric(x)
    % X provided, check if it is of short data format
    if size(x, 2) > 2
        % too long to be long data format :-D
        % this is of short data format
        warning('Treating as short data format!');
        y = x(:,:,1);
        if size(x,3) == 2
            % SEM provided
            err = x(:,:,2);
            if ~(exist('mode', 'var') && isfield(mode, 'errbar'));mode.errbar = 1;end
        elseif size(x,3) ~= 2 && exist('mode', 'var') && isfield(mode, 'errbar') && mode.errbar
            % errorbars requested, without providing SEMs
            % now you are being naughty!
            warning('SEM not provided. Not plotting errorbars!');
            mode.errbar = 0;
        end
        if exist('idx', 'var') && prod(idx) == size(x,2)
            % vars for columns are already specified
            idx = fullfact([size(x,1), idx(:)']);
        else
            % IDX not provided
            % generate with row and columns as two variables
            warning('IDX for variable levels are not provided. Deeming rows of X as different levels for a one variable, and columns as different levels for a second variable.');
            idx = fullfact([size(x,1) size(x,2)]);
        end
        
        % recreate x as long data format
        if size(x,3) == 2
            x = [y(:) err(:)];
        else
            x = [y(:)];
        end
        % now we need no guess if it is of short data
    elseif size(x,2) == 2
        % X with SEM without grouping, or two Xs without SEM?
        if exist('mode', 'var') && isfield(mode, 'errbar')
            % errorbar asked spesifically, GUESSING X with SEM
            % this is no different from long data format
        else
            % errorbar not requested, treat as two groups
            % this may be not what you wanted, in which case, explicitly
            % specify if SEMs are provided using mode.errbar
            warning('IDX for variable levels are not provided. Deeming rows of X as different levels for the first variable, and columns as different levels for a second variable.');
            idx = fullfact([size(x,1) size(x,2)]);
            x = x(:);
        end
    elseif size(x,2) == 1
        % linear data provided, just plot it as horizontal axis
        % this is no different from long data format
    else
        % data is most possibly of long data format
        % if NOT, you are on your own!
        % HINT: use grouping methods such as grpstats, tabulate etc. to get
        % group statistics (mean or median, sem via std) along with
        % variable identifiers, which can be used as IDX here
    end
end

if ~(exist('idx', 'var') && isnumeric(idx) && size(x,1) == prod(arrayfun(@(x)(length(unique(idx(:,x)))),[1:size(idx,2)],'Uniformoutput',true)))
    % with no variables as IDX provided, input X is seen on different
    % levels of first variable
    warning('IDX for variable levels are not provided. Deeming rows of X as different levels, for a single variable.');
    idx = [1:size(x,1)]';
end

if nargin < 3 || ~(exist('gnames', 'var') && iscell(gnames) && all(arrayfun(@(x)(length(gnames{x})),[1:numel(gnames)],'Uniformoutput',true) == arrayfun(@(x)(length(unique(idx(:,x)))),[1:size(idx,2)],'Uniformoutput',true)) )
    % generate names for each levels in every variables represented in IDX
    % columns
    warning('GNAMES for variable level names are not consistent with data provided. Auto-generating...');
    gnames = arrayfun(@(x)(cellstr(num2str(unique(idx(:,x))))'),[1:size(idx,2)],'Uniformoutput',false);
end

if nargin < 4 || ~(exist('txy', 'var') && iscell(txy) && numel(txy)==3 )
    warning('TXY for figure title and axes names not provided. Auto-generating...');
    txy = {'', 'x', 'y'};
end

if nargin < 5 || ~exist('mode', 'var')
    if ~(exist('mode','var') && isfield(mode, 'errbar') && isnumeric(mode.errbar) )
        switch size(x,2)
            case 1
                mode.errbar = 0;
            case 2
                mode.errbar = 1; % default: with errorbar
            otherwise
                error('You found a unicorn!');
        end
        
    end
    if ~(exist('mode','var') && isfield(mode, 'isline') && isnumeric(mode.isline) )
        mode.isline = 0; % default plot: bar chart, not lines
    end
end

if  mode.isline && size(idx,2)>4
    error('For now, only a maximum of 4 variables is supported for lines.');
end


%% begin parsing

fontsize = 28;
colmap = 'bone';
line.tex = {'-','--','-.',':'};
line.shape = {'^','v','o','s','x','+','*','.','d','<','>','p','h'};
line.color = {'k', 'r', 'b', 'g', 'c', 'm', 'y', 'w'};
if exist('mode','var') && isfield(mode, 'fontsize')
    fontsize = mode.fontsize;
end
if exist('mode','var') && isfield(mode, 'colmap')
    colmap = mode.colmap;
end
if exist('mode','var') && isfield(mode, 'linespec')
    line = mode.linespec;
end

line.cell = struct2cell(line); % adjust this order according to IDX levels
if max(arrayfun(@(x)(length(unique(idx(:,x)))),[2:size(idx,2)],'Uniformoutput',true)) > max(arrayfun(@(x)(length(line.cell{x})),[1:numel(line.cell)],'Uniformoutput',true))
    % we could still plot bar charts though
    error('Too many levels present! Unable to plot!')
end
for ivar = 2:size(idx,2)
    if length(unique(idx(:,ivar))) > numel(line.cell{ivar-1})
        % asked for specifications more than that could be provided
        tmp=line.cell(ivar);
        line.cell(ivar)=line.cell(ivar-1);
        line.cell(ivar-1)=tmp;
    end
end


y = x(:,1);
if mode.errbar;err = x(:,2);else err = zeros(size(y));end

% used for factor name <-> factor level mapping
for igrp=1:size(idx,2)
    grp{1,igrp}=unique(idx(:,igrp));
    grp{2,igrp}=[1:numel(grp{1,igrp})]';
end

[ydat, errdat, legtext, linespec, id_data] = directparse(y,err,idx, gnames, line, grp, mode);

h=figure;
hold on;

% this method is not good!
% [ydat, errdat, legtext] = layerparse(gnames, line, mode, grp, y, err, idx, dotidx, linespec, legtext, ydat, errdat);


% maybe we are just requested to draw bar charts
% first var as the grouping one
if mode.isline
    if mode.errbar
        arrayfun(@(x)(errorbar(ydat(x,:), errdat(x,:),linespec{x})),[1:size(linespec,1)],'Uniformoutput',false);
    else
        arrayfun(@(x)(plot(ydat(x,:), linespec{x})),[1:size(linespec,1)],'Uniformoutput',false);
    end
    xticks = 1:numel(gnames{1});
else
    if mode.errbar
        barwitherr(errdat, ydat);
    else
        bar(ydat);
    end
    set(gca,'XTick', 1:numel(legtext));
    
    xticks = legtext;
    legtext = gnames{1};
    
    colormap(colmap);
end

if numel(gnames)==1
    % only single variable is present
    xticks = gnames{1};
    legtext = [];
end

title(txy{1});
xlabel(txy{2},'FontSize',fontsize);
ylabel(txy{3},'FontSize',fontsize);
if ~isempty(legtext)
    legend(legtext,'Location','NEO');
    legend('boxoff');
end
box off;
set(gca,'XTick', 1:numel(xticks));
set(gca,'XTickLabel', xticks);
set(gcf, 'Position', get(0, 'ScreenSize'));
set(gca,'FontSize',fontsize);
hold off;

if exist('mode','var') && isfield(mode, 'barnote') && mode.barnote
    if numel(gnames)==4 && mode.errbar && ~mode.isline
        % the variables are too much, when presented on horizontal axes
        % ticks; put the second variable in the plot itself.
        for i=1:numel(xticks);
            var2level = gnames{2}(grp{2,2}(grp{1,2}==id_data(i,1)));
            var2level = var2level{:};
            xticks{i}=xticks{i}(numel(var2level)+2:end);
        end
        set(gca,'XTickLabel', xticks);
        if exist('err', 'var');ymax = max(y+err);else ymax = max(y);end
        sepinterval = prod(arrayfun(@(x)(length(unique(idx(:,x)))),[3:size(idx,2)],'Uniformoutput',true));
        for ivar2 = 0:numel(gnames{2})-1
        text_h{ivar2+1}=text(0.5 + ivar2*sepinterval ,ymax + std(y)/5,gnames{2}(ivar2+1),'FontSize', 24);
        end
        [tmp, ymax] = ginput;
        ymax = ymax(end);
        if ~isempty(ymax)
            for ivar2 = 0:numel(gnames{2})-1
                delete(text_h{ivar2+1});
                text_h{ivar2+1}=text(0.5 + ivar2*sepinterval ,ymax ,gnames{2}(ivar2+1),'FontSize', 24);
            end
        end
    end
end

%% helper functions
    function [ydat, errdat, legtext, linespec, id_data] = directparse(y,err,idx, gnames, line, grp, mode)
        % melt long data to short data format
        % do it via matrix manipulation
        linespec = [];
        legtext=[];
        
        idxpure = idx(:,2:end);
        
        if isempty(idxpure)
            % if only one variable is present, it is IDXPURE
            % just plot a single variable
            ydat = y';
            errdat = err';
            legtext = {''};
            if mode.isline;linespec = {cell2mat(arrayfun(@(x)line.cell{x}(1),[1:numel(line.cell)],'Uniformoutput',true))};end
        else
            [srt_idxpure, lst_idxpure] = sortrows(idxpure);
            id_data = unique(srt_idxpure,'rows'); % observation identifier
            % size(srt_idxpure,1)/size(unique(srt_idxpure,'rows') = numel(gnames{1})
            % use the former so that we can check this assumption, which should always
            % be true as long as data is from full factorial design
            ydat = reshape(y(lst_idxpure), size(srt_idxpure,1)/size(id_data,1),[])';
            errdat = reshape(err(lst_idxpure), size(srt_idxpure,1)/size(id_data,1),[])';
            
            
            for ifactor = 1:size(id_data,2) % should be same with numel(gnames)-1
                if mode.isline;linespec = [linespec, line.cell{ifactor}(Replace(id_data(:,ifactor), grp{1, ifactor+1}, grp{2, ifactor+1}))'];end
                legtext = [legtext, gnames{ifactor+1}(Replace(id_data(:,ifactor), grp{1, ifactor+1}, grp{2, ifactor+1}))'];
            end
            
            % for all other line specs, use the first as default
            for ileftspecs = size(id_data,2)+1:3
                if mode.isline;linespec = [linespec, line.cell{ileftspecs}(ones(size(id_data,1),1))'];end
            end
            
            Legtext(:, 1:2:2*size(legtext,2)-1) = legtext;
            Legtext(:, 2:2:2*size(legtext,2)-1) = repmat(cellstr(repmat('-',size(legtext,1),1)),1, size(legtext,2)-1);
            if mode.isline;linespec = arrayfun(@(x)(char(cell2mat(linespec(x,:)))),[1:size(linespec,1)],'Uniformoutput',false)';end
            legtext = arrayfun(@(x)(char(cell2mat(Legtext(x,:)))),[1:size(Legtext,1)],'Uniformoutput',false)';
        end
    end
%     function [ydat, errdat, legtext] = layerparse(gnames, line, mode, grp, y, err, idx, dotidx, linespec, legtext, ydat, errdat)
%         % TODO: these switches could also be capsuled in a control loop
%         % this can be recursive
%         % or can be written via matrix manipulation
%         switch numel(gnames)
%             case 3
%                 icolor=1;
%                 for ispec = 1:numel(gnames{2})
%                     for ishape = 1:numel(gnames{3})
%                         linespec = [line.tex{ispec} line.shape{ishape} line.color{icolor}];
%                         legtext=[legtext; [gnames{2}(ispec) '-' gnames{3}(ishape)]];
%                         dotidx = idx(:,2)==grp{1,2}(ispec) & idx(:,3)==grp{1,3}(ishape);
%                         ydat = [ydat y(dotidx)];
%                         errdat = [errdat err(dotidx)];
%
%                         % now, plot!
%                         if mode.isline
%                             if mode.errbar
%                                 errorbar(1:numel(gnames{1}), y(dotidx), err(dotidx), linespec);
%                             else
%                                 plot(1:numel(gnames{1}), y(dotidx), linespec);
%                             end
%                         end
%                     end
%                 end
%
%             case 4
%                 for ispec = 1:numel(gnames{2})
%                     for ishape = 1:numel(gnames{3})
%                         for icolor = 1:numel(gnames{4})
%                             linespec = [line.tex{ispec} line.shape{ishape} line.color{icolor}];
%                             legtext=[legtext; [gnames{2}(ispec) '-' gnames{4}(icolor) '-' gnames{3}(ishape)]];
%                             dotidx = idx(:,2)==grp{1,2}(ispec) & idx(:,3)==grp{1,3}(ishape) & idx(:,4)==grp{1,4}(icolor);
%                             ydat = [ydat y(dotidx)];
%                             errdat = [errdat err(dotidx)];
%
%                             % now, plot!
%                             if mode.isline
%                                 if mode.errbar
%                                     errorbar(1:numel(gnames{1}), y(dotidx), err(dotidx), linespec);
%                                 else
%                                     plot(1:numel(gnames{1}), y(dotidx), linespec);
%                                 end
%                             end
%                         end
%                     end
%                 end
%             otherwise
%                 error('how come?');
%         end
%
%         for iline=1:size((legtext),1)
%             Legtext{iline}=strcat(legtext{iline,:});
%         end
%         legtext = Legtext;
%         ydat=ydat';
%         errdat=errdat';
%     end

%     function prs = psrinit(x, idx, gnames, line, txy)
%         out.linespec = [];
%         out.dotidx = [];
%         out.legtext=[];
%         out.ydat = [];
%         out.errdat = [];
%         out.txy = txy;
%
%         y = x(:,1);
%         err = x(:,2);
%
%         % used for factor name <-> factor level mapping
%         for igrp=1:size(idx,2)
%             grp{1,igrp}=unique(idx(:,igrp));
%             grp{2,igrp}=[1:numel(grp{1,igrp})]';
%             grpsize(igrp) = numel(grp{igrp});
%         end
%
%         mid.y   = y;
%         mid.err = err;
%         mid.chosen = ones(size(idx,1),1);
%         mid.idx = [idx mid.chosen];
%         mid.grp = grp;
%         mid.grpsize = grpsize;
%         mid.gnames=gnames;
%         mid.legtext = [];
%         mid.linespec = [];
%         mid.dotidx = [];
%         mid.line = struct2cell(line);
%
%         prs.out = out;
%         prs.mid = mid;
%
%         prs.layer = 0;
%         prs.cursor=zeros(1, numel(gnames));
%     end

%     function downlayer = recurparse(layer)
%         % recursively parse by depth first
%         if layer.layer == numel(layer.mid.gnames)-1
%             % just finish
%             %     linespec = [line.tex{ispec} line.shape{ishape} line.color{icolor}];
%             % strcat(layer.mid.legtext{1:end-1})
%             layer.out.legtext= [layer.out.legtext; layer.mid.legtext];
%             layer.out.dotidx = logical([layer.out.dotidx, prod(layer.mid.chosen,2)]);
%             layer.out.ydat = [layer.out.ydat layer.mid.y(layer.out.dotidx(:,end))];
%             layer.out.errdat = [layer.out.errdat layer.mid.err(layer.out.dotidx(:,end))];
%
%             if all(layer.cursor == layer.mid.grpsize)
%                 % all case traversed, time to return
%             else
%                 % go up one level, not down though
%                 layer.layer = layer.layer - 1;
%                 layer.mid.linespec(end)=[];
%                 layer.mid.legtext(end)=[];
%                 downlayer = recurparse(layer);
%             end
%         else
%             % one layer down
%             layer.layer = layer.layer + 1;
%             for i=1:numel(layer.mid.gnames{layer.layer})
%                 layer.cursor(layer.layer) = i;
%                 layer.mid.linespec = [layer.mid.linespec layer.mid.line{layer.layer}(layer.cursor(layer.layer))];
%                 layer.mid.legtext = [layer.mid.legtext, layer.mid.gnames{layer.layer}(layer.cursor(layer.layer)) '-' ];
%                 layer.mid.chosen = [layer.mid.chosen, layer.mid.idx(:,layer.layer+1)==layer.mid.grp{layer.layer+1}(layer.cursor(layer.layer))];
%                 downlayer = recurparse(layer);
%             end
%         end
%     end
end

% [EOF]
