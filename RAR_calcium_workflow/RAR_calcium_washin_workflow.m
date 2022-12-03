% Main script for processing a calcium imaging experiment

function RAR_calcium_washin_workflow (eleclocs_file, varargin)
	
	raw_intensity_filenames = {};
	num_files = length(varargin);
	for i = 1:num_files
		image_directory = varargin{i};
		list_of_tifs = dir ([image_directory, '/*.tif']) ; % get all the filenames 
		raw_intensity_filenames{i} = RAR_caproc_parloop (eleclocs_file, list_of_tifs) ; 

	end

	normalized_filenames = RAR_normalization(raw_intensity_filenames{:});
	RAR_calcium_plot (normalized_filenames);

end