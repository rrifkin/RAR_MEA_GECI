function spikes = ss_drop(spikes)

lims = spikes.info.detect.stds * spikes.params.maxThresh;
lims = [-lims lims];
if spikes.params.rawMaxThresh(1) < lims(1)
    lims(1) = spikes.params.rawMaxThresh(1);
end
if spikes.params.rawMaxThresh(2) > lims(2)
    lims(2) = spikes.params.rawMaxThresh(2);
end
[p,q] = ind2sub(size(spikes.waveforms),find(spikes.waveforms < lims(1) | spikes.waveforms > lims(2)));

spikes.waveforms(p,:) = [];
spikes.spiketimes(p) = [];
spikes.trials(p) = [];
spikes.unwrapped_times(p) = [];
spikes.info.detect.event_channel(p) = [];

[pca.u,pca.s,pca.v] = svd(detrend(spikes.waveforms(:,:),'constant'), 0); % SVD the data matrix
spikes.info.pca = pca;

spikes.info.detect.thresh_limits = lims;