% Main function for doing RapidSort

function RAR_rapidsort_workflow (path)

	pathparts = strsplit(path,filesep);
	file_stem = string(pathparts(end));

	combined_spikes = RAR_spike_combiner (path);
	combined_spikes_file = strcat(path, '/', file_stem, '_rapidsort_combined_spikes.mat')
	save(combined_spikes_file, 'combined_spikes', '-v7.3');

	L1_processed_spikes = L1_spikePreprocessing(combined_spikes);
	Library_processed_spikes = TheLibraryTM(L1_processed_spikes);
	processed_spikes_file = strcat(path, '/', file_stem, '_rapidsort_processed_spikes.mat')
	save(processed_spikes_file, 'Library_processed_spikes', '-v7.3');

    [rapidINfr, rapidINt, rapidPCfr, rapidPCt] = RAR_rapidsort (Library_processed_spikes);
	firing_rates_file = strcat(path, '/', file_stem, '_rapidsort_gaussian_firing_rates.mat')
	save(firing_rates_file, 'rapidINfr', 'rapidINt', 'rapidPCfr', 'rapidPCt', '-v7.3');

end