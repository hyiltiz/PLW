function h=corrLayer(r, p, tick, crit, iscumulate)
% visualize image matrix and correlation
% mode.cumulate = 0; % set to 1 to do layer by later; or cumulative
% crit=0.01; 0.01 every step of layer, or cumulation

h=figure;
idx0=zeros(size(r));
for crit=0:crit:0.1;
    idx=(p<crit);
    
    if iscumulate
        imdat = idx.*r; % this is r that we wanted to plot
    else
        imdat = (idx-idx0).*r; % this is r that we wanted to plot
    end
    
    imdat(isnan(imdat))=0;
    [x,y,v] = find(imdat);
    imagesc(imdat);
    text(x-0.5,y,num2str(v,2));
    colorbar;
    set(gca,'XTick',1:size(r,1));
    set(gca,'YTick',1:size(r,1));
    set(gca,'XTickLabel',tick);
    set(gca,'YTickLabel',tick);
    title(crit);
    pause;
    idx0=idx;
end
if ~iscumulate
    % this is layer by layer
    % last layer is meaningless, without all others
    close;
end
    
end