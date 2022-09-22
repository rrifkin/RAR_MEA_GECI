% Processes all .ns5 files in a directory tree using RAR_NSxFile_filter
% to extract LFP and MUA data. The LFP data is saved for later plotting.
% The MUA data is spike-detected and aligned using NSxFile 
% (in RAR_NSxFile_filter). Then, the spikes are sorted using UMS2K 
% (in RAR_spike_sort).

function RAR_process_directory (input_path)

	% Inclusion and exclusion criteria
	exclude_string = 'EXCLUDE';
	include_string = 'WT Non-Tumor MEA GiGA1 vs. Vehicle';

	% Recursively locate all .ns5 files in the provided directory
	file_list = dir ([input_path, '/**/*.ns5']);
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

	% Iterate through all files and do first-pass processing
	for i = 1:length(file_paths)
		current_file = file_paths{i}

		% Filter raw .ns5 file into LFP and MUA-band data and detect spikes
		RAR_NSxFile_filter(current_file);

		% Sort spikes using UMS2K
		MUA_file = strcat(current_file(1:end-4), '_NSxFile_MUA_spikes.mat');
		RAR_spike_sort (MUA_file);
	end

	% Additional manual steps:
	% 1. Plot LFP data using RAR_plot_LFP (need to pass all .mat LFP files
	% from the experiment in the correct order to RAR_plot_LFP (e.g.
	% RAR_plot_LFP('ACSF.mat', 'GiGA1.mat', 'DMSO.mat')
	% 2. Clean LFP data using RAR_clean_LFP for each file to be analyzed, 
	% producing an '_artifact_samples.csv' file for each file.
	% 3. Visually inspect "post" image and make "_offslice_channels.csv" file
	% for each slice.
	% 4. Run RAR_workflow_analysis on the whole directory, which will find 
	% '_artifact_samples.csv' files signifying processed files, and will 
	% perform linelength and findpeaks analyses on them.
	% 5. Use SplitMerge to do quality control on individual channel files.



end