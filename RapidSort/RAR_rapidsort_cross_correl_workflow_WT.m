function RAR_rapidsort_cross_correl_workflow_WT(epoch, window, bin_width)

	experiments = {
		'/Volumes/Research/Electrophysiology/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
		'/Volumes/Research/Electrophysiology/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
		'/Volumes/Research/Electrophysiology/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
		'/Volumes/Research/Electrophysiology/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
		'/Volumes/Research/Electrophysiology/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
		'/Volumes/Research/Electrophysiology/2022.08.05 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.05 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
	};

	all_DMSO_bins = [];

	for i = 1:numel(experiments)
		cd (experiments{i})
		DMSO_processed_spikes = dir('**/*DMSO_NSxFile_MUA_spikes_rapidsort_processed_spikes.mat');
		DMSO_processed_spikes_file = strcat(DMSO_processed_spikes.folder, '/', DMSO_processed_spikes.name);
		DMSO_normalized_PC_bins = RAR_rapidsort_cross_correl (DMSO_processed_spikes_file, epoch, window, bin_width);
		all_DMSO_bins = [all_DMSO_bins; DMSO_normalized_PC_bins];

	end

	cd ~;
	DMSO_output_file = strcat('WT_Non-Tumor_DMSO_IN-triggered_PC_bins_window_', num2str(window), '_bin_width_', num2str(bin_width), '.csv');
	writematrix(all_DMSO_bins, DMSO_output_file);

end