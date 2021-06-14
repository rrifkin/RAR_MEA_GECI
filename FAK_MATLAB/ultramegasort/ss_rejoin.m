function spikes = ss_rejoin(spikes)

waves = [spikes.waveforms; spikes.outliers.waveforms];
spiketimes = [spikes.spiketimes spikes.outliers.spiketimes];
trials = [spikes.trials spikes.outliers.trials];
unwrapped_times = [spikes.unwrapped_times spikes.outliers.unwrapped_times];
assigns = [spikes.assigns zeros(1,length(spikes.outliers.spiketimes))];

[~,inds] = sort(spiketimes);

waves = waves(inds,:);
spiketimes = spiketimes(inds);
trials = trials(inds);
unwrapped_times = unwrapped_times(inds);
assigns = assigns(inds);

spikes.waveforms = waves;
spikes.spiketimes = spiketimes;
spikes.trials = trials;
spikes.unwrapped_times = unwrapped_times;
spikes.assigns = assigns;

spikes = rmfield(spikes,'outliers');