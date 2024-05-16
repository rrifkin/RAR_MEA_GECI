function RAR_rapidsort_cross_correl_workflow_per_channel(epoch)

	experiments = {
		'/Volumes/Research/Electrophysiology/2022.11.07 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.07 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.11.07 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.07 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 2',
		'/Volumes/Research/Electrophysiology/2022.11.07 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.07 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 3',
		'/Volumes/Research/Electrophysiology/2022.11.08 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.08 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.11.08 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.08 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 4',
		'/Volumes/Research/Electrophysiology/2022.11.09 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.09 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.11.09 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.09 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 3',
		'/Volumes/Research/Electrophysiology/2022.11.09 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle/2022.11.09 Thy1-GCaMP Tumor MEA-GECI GiGA1 vs. Vehicle, slice 4',
	};

	all_DMSO_bins = [];
	all_GiGA1_bins = [];

	for i = 1:numel(experiments)
		cd (experiments{i})
		DMSO_processed_spikes = dir('**/*DMSO_NSxFile_MUA_spikes_rapidsort_processed_spikes.mat');
		DMSO_processed_spikes_file = strcat(DMSO_processed_spikes.folder, '/', DMSO_processed_spikes.name);
		DMSO_normalized_PC_bins = RAR_rapidsort_cross_correl_per_channel (DMSO_processed_spikes_file, epoch);
		all_DMSO_bins = [all_DMSO_bins; DMSO_normalized_PC_bins];

		GiGA1_processed_spikes = dir('**/*GiGA1_NSxFile_MUA_spikes_rapidsort_processed_spikes.mat');
		GiGA1_processed_spikes_file = strcat(GiGA1_processed_spikes.folder, '/', GiGA1_processed_spikes.name);
		GiGA1_normalized_PC_bins = RAR_rapidsort_cross_correl_per_channel (GiGA1_processed_spikes_file, epoch);
		all_GiGA1_bins = [all_GiGA1_bins; GiGA1_normalized_PC_bins];

	end

	cd ~;
	DMSO_output_file = 'DMSO_IN-triggered_PC_bins_per_channel.csv';
	writematrix(all_DMSO_bins, DMSO_output_file);
	GiGA1_output_file = 'GiGA1_IN-triggered_PC_bins_per_channel.csv';
	writematrix(all_GiGA1_bins, GiGA1_output_file);

end