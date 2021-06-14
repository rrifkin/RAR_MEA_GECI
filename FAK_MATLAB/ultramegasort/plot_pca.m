function plot_pca(spikes,grey,noGarb)
if nargin < 2 || isempty(grey)
    grey = .7;
end
if nargin < 3 || isempty(noGarb)
    noGarb = 0;
end
h = figure('units','pixels','position',[100 100 900 800]);
[~,pc] = princomp(spikes.waveforms);

if isfield(spikes.info,'kmeans')
    hold on
    unq = unique(spikes.assigns);
    if isempty(which('distinguishable_colors'))
        cols = hsv(length(unq));
    else
        cols = distinguishable_colors(length(unq));
    end
    ledge = cell(1,length(unq));
    count = 1;
    for u = 1:length(unq)
        id = unq(u);
        inds = spikes.assigns == id;
        thisCol = cols(u,:);
        isNoise = 0;
        if isfield(spikes,'mostlyNoise')
            if spikes.mostlyNoise(id)
                thisCol = [1 1 1]*grey;
                isNoise = 1;
            end
        end
        if noGarb
            if spikes.labels(spikes.labels(:,1) == unq(u),2) == 4
                isNoise = 1;
            end
        end
        if ~(grey == 1 && isNoise)
            plot3(pc(inds,1),pc(inds,2),pc(inds,3),'.','color',thisCol);
            ledge{count} = num2str(spikes.labels(u,1));
            count = count + 1;
        end
    end
    ledge(count:end) = [];
    legend(ledge);
else
    plot3(pc(:,1),pc(:,2),pc(:,3),'k.')
end
rotate3d(h,'on')
set(h,'Name','PCA data','NumberTitle','off')