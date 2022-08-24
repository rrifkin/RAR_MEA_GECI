function RAR_clean_and_linelength_workflow

	[input_file, input_path] = uigetfile();

	input_file = [input_path, input_file];

	RAR_clean_LFP (input_file);

	artifact_file = strcat(input_file, '_artifact_samples.csv');

	bad_channels_file = strcat(input_file, '_bad_channels.csv');

	RAR_linelength(input_file, artifact_file, bad_channels_file);

end