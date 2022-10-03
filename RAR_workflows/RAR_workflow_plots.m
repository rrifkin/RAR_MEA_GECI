% Recursively searches for .ns5 files and assembles their corresponding filtered and downsampled
% .mat files into the order of the experiment. Then, makes LFP plots.

function RAR_workflow_plots (input_path)

	% Inclusion and exclusion criteria
	exclude_string = 'EXCLUDE';
	include_string = 'WT Non-Tumor MEA GiGA1 vs. Vehicle';

	% Recursively locate all .ns5 files in the provided directory
	file_list = dir ([input_path, '/**/*.ns5']);
	num_files = length (file_list);

	% Iterate through all files, make sure they meet inclusion and exclusion
	% criteria, and assemble them into a list of unique folders that contain .ns5 files.
	file_paths = {};
	for i = 1:num_files
		file_stem = split(file_list(i).name, ',');
		file_stem = char(strcat(file_stem(1), ',', file_stem(2)));
		current_path = [file_list(i).folder, '/', file_stem];
		if ((contains (current_path, exclude_string) == 0) && (contains(current_path, include_string) == 1))
			file_paths = [file_paths; current_path];
		end
	end
	file_paths = unique(file_paths);

	% Display the list of files to be processed
	disp (file_paths);

	% Iterate through all files and do LFP plots
	for i = 1:length(file_paths)
		disp(i);
		folder = file_paths{i};

		ACSF_file = strcat(folder, ', ACSF_NSxFile_LFP.mat');
		GiGA1_file = strcat(folder, ', ZMG-GiGA1_NSxFile_LFP.mat');
		DMSO_file = strcat(folder, ', ZMG-DMSO_NSxFile_LFP.mat');

		files_to_plot = {ACSF_file};
		if exist (GiGA1_file,'file') == 2
			files_to_plot = [files_to_plot; GiGA1_file];
		end
		if exist (DMSO_file,'file') == 2
			files_to_plot = [files_to_plot; DMSO_file];
		end
		disp (files_to_plot);
		RAR_plot_LFP (files_to_plot{:});
	end

	% Iterate through all files and do individual MUA plots
	for i = 1:length(file_paths)
		disp(i);
		folder = file_paths{i};

		ACSF_file = strcat(folder, ', ACSF.ns5');
		GiGA1_file = strcat(folder, ', ZMG-GiGA1.ns5');
		DMSO_file = strcat(folder, ', ZMG-DMSO.ns5');

		RAR_plot_MUA (ACSF_file);
		if exist (GiGA1_file,'file') == 2
			files_to_plot = [files_to_plot; GiGA1_file];
		end
		if exist (DMSO_file,'file') == 2
			files_to_plot = [files_to_plot; DMSO_file];
		end
		RAR_plot_MUA(files_to_plot);
	end
end