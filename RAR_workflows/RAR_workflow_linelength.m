
function RAR_workflow_linelength (input_path)

	file_list = dir ([input_path, '/**/*_artifact_samples.csv']);
	num_files = length (file_list);

	file_paths = {};
	for i = 1:num_files
		current_path = [file_list(i).folder, '/', file_list(i).name];
		if ((contains (current_path, 'EXCLUDE') == 0) && (contains(current_path, 'WT Non-Tumor MEA GiGA1 vs. Vehicle') == 1))
			file_paths = [file_paths; current_path];
		end
	end

	disp (file_paths);

	for i = 1:length(file_paths)
		disp(i);
		artifact_file = file_paths{i};
		bad_channels_file = strcat(artifact_file(1:end-21), '_bad_channels.csv');
		offslice_channels_file = strcat(artifact_file(1:end-21), '_offslice_channels.csv');
		LFP_file = strcat(artifact_file(1:end-21), '_NSxFile_LFP.mat')
		RAR_linelength (LFP_file, artifact_file, bad_channels_file, offslice_channels_file);

	end


	

end