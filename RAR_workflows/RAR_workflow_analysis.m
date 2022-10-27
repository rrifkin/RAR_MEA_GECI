% Does LFP analyses on all files (that have had the appropriate manual steps
% performed) in a given directory.

function RAR_workflow_analysis (input_path)

	% Inclusion and exclusion criteria
	exclude_string = 'EXCLUDE';
	include_string = 'WT Non-Tumor MEA GiGA1 vs. Vehicle';

	% Recursively locate all '_artifact_samples.csv' files in the provided directory
	file_list = dir ([input_path, '/**/*_artifact_samples.csv']);
	num_files = length (file_list);

	% Iterate through all files, make sure they meet inclusion and exclusion
	% criteria, and assemble them into a list of file paths.
	file_paths = {};
	for i = 1:num_files
		current_path = [file_list(i).folder, '/', file_list(i).name];
		if ((contains (current_path, exclude_string) == 0) && (contains(current_path, include_string) == 1))
			file_paths = [file_paths; current_path];
		end
	end

	% Display the list of files to be processed
	disp (file_paths);

	% Iterate through all files and do LFP analyses
	for i = 1:length(file_paths)
		disp(i);
		artifact_file = file_paths{i};
		bad_channels_file = strcat(artifact_file(1:end-21), '_bad_channels.csv');
		offslice_channels_file = strcat(artifact_file(1:end-21), '_offslice_channels.csv');
		LFP_file = strcat(artifact_file(1:end-21), '_NSxFile_LFP.mat')
		%RAR_linelength (LFP_file, artifact_file, bad_channels_file, offslice_channels_file);
		RAR_findpeaks (LFP_file, artifact_file, bad_channels_file, offslice_channels_file);
	end

end