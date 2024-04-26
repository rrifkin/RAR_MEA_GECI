% Does LFP analyses on all files (that have had the appropriate manual steps
% performed) in a given directory.

function RAR_workflow_peritumoral (DMSO_file, excluded_minutes)

	file_stem = DMSO_file(1:end-24);
	epochs = {' ZMG-DMSO',' ZMG-GiGA1'};

	for i = 1:numel(epochs)
		epoch_name = epochs{i};
		LFP_file = strcat(file_stem, epoch_name, '_NSxFile_LFP.mat')
		artifact_file = strcat(file_stem, epoch_name, '_artifact_samples.csv');
		bad_channels_file = strcat(file_stem, epoch_name, '_bad_channels.csv');
		offslice_channels_file = strcat(file_stem, epoch_name, '_offslice_channels.csv');
		inactive_channels_file = strcat(file_stem, epoch_name, '_inactive_channels.csv');
		peritumoral_file = strcat(file_stem, ' peritumoral channels.csv');
		% RAR_linelength_peritumoral (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, peritumoral_file, excluded_minutes);
		% RAR_linelength_peritumoral_by_ch (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, peritumoral_file, excluded_minutes);
		RAR_findpeaks_peritumoral_by_ch (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, peritumoral_file, excluded_minutes);


	end

end