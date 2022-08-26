
function RAR_process_directory (input_path)

	file_list = dir ([input_path, '/**/*.ns5']);
	num_files = length (file_list);

	file_paths = {};
	for i = 1:num_files
		current_path = [file_list(i).folder, '/', file_list(i).name];
		file_paths = [file_paths; current_path];
	end

	disp (file_paths);

	for i = 1:length(file_paths)
		RAR_NSxFile_filter(file_paths(i));
	end
end