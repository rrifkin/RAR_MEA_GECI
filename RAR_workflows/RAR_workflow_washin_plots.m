% Recursively searches for .ns5 files and assembles their corresponding filtered
% and downsampled .mat files into the order of the experiment, then makes
% LFP plots.

function RAR_workflow_washin_plots (input_path, include_string, exclude_string)

	% Recursively locate all .ns5 files in the provided directory
	file_list = dir ([input_path, '/**/*.ns5']);
	num_files = length (file_list);

	% Iterate through all files, make sure they meet inclusion and exclusion
	% criteria, and assemble them into a list of unique folders that contain .ns5 files.
	file_stems = {};
	for i = 1:num_files
		current_path = [file_list(i).folder, '/', file_list(i).name];
		if ((contains (current_path, exclude_string) == 0) && (contains(current_path, include_string) == 1))
			file_stem = split(file_list(i).name, ',');
			file_stem = char(strcat(file_stem(1), ',', file_stem(2)));
			current_stem = [file_list(i).folder, '/', file_stem];
			file_stems = [file_stems; current_stem];
		end
	end
	file_stems = unique(file_stems);

	% Display the list of files to be processed
	disp (file_stems);

	% Iterate through all files and do LFP plots
	for i = 1:length(file_stems)
		disp(i);
		folder = file_stems{i};

		ACSF_file = strcat(folder, ', ACSF_NSxFile_LFP.mat');
		DMSO_file = strcat(folder, ', ZMG-DMSO_NSxFile_LFP.mat');
		GiGA1_file = strcat(folder, ', ZMG-GiGA1_NSxFile_LFP.mat');

		files_to_plot = {ACSF_file};
		if exist (DMSO_file,'file') == 2
			files_to_plot = [files_to_plot; DMSO_file];
		end
		if exist (GiGA1_file,'file') == 2
			files_to_plot = [files_to_plot; GiGA1_file];
		end
		disp (files_to_plot);
		RAR_plot_LFP (files_to_plot{:});
	end
end