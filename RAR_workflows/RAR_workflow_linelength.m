
function RAR_workflow_linelength (LFP_file)

	artifact_file = strcat(LFP_file(1:end-16), '_artifact_samples.csv');
	bad_channels_file = strcat(LFP_file(1:end-16), '_bad_channels.csv');
	offslice_channels_file = strcat(LFP_file(1:end-16), '_offslice_channels.csv');
	RAR_linelength (LFP_file, artifact_file, bad_channels_file, offslice_channels_file);

end