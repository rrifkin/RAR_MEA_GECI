function ss_full_pca_plot(spikes,units,upto)
% SS_FULL_PCA_PLOT(spikestruct,units,upto)
% Plots all principal components of specified units (defaults to all), or
% the principal components up to as specified (upto)
%
% E M Merricks 2015

base_unq = unique(spikes.assigns);
if nargin > 1 && ~isempty(units)
    unq = units;
    % Need to remove unit numbers from the input that aren't in the base
    % list here.
else
    unq = base_unq;
end

cols = distinguishable_colors(length(unq));


d = diag(spikes.info.pca.s);
r = find( cumsum(d)/sum(d) >.95,1);
waves = spikes.waveforms(:,:) * spikes.info.pca.v(:,1:r);

if nargin > 2 && ~isempty(upto) && upto < r
    r = upto;
end

figure('units','normalized','position',[.05 .05 .9 .9]);
subsize = 1/r;
for s = 1:(r-1)
    for ss = (s+1):r
        subplot('position',[(s-1)*subsize 1-(ss*subsize) subsize subsize]);
        hold on
        for u = 1:length(unq)
            subset = find(spikes.assigns == unq(u));
            plot(waves(subset,s),waves(subset,ss),'.','color',cols(u,:));
        end
        set(gca,'xtick',[],'ytick',[])
        box on
    end
end