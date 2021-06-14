function spikes = ss_from_spikes(spikes,waveforms,spiketimes)

spikes.info.detect.stds = single(std(waveforms(:))); % bit of a dodge workaround
spikes.info.detect.dur = single((max(spiketimes)+1)/spikes.params.Fs); % just add a second to last spike, not important

