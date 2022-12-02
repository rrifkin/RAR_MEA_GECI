% Main script for processing a calcium imaging experiment

function RAR_calcium_washin_workflow (eleclocs_file, ACSF_image_directory, DMSO_image_directory, GiGA1_image_directory, DMSO_metadata_file)

	% Process ACSF raw calcium data
	ACSF_list_of_tifs = dir ([ACSF_image_directory, '/*.tif']) ; % get all the filenames 
	RAR_caproc_parloop (eleclocs_file, ACSF_list_of_tifs) ; 

	% Process DMSO raw calcium data
	DMSO_list_of_tifs = dir ([DMSO_image_directory, '/*.tif']) ; % get all the filenames 
	RAR_caproc_parloop (eleclocs_file, DMSO_list_of_tifs) ; 

	% Process GiGA1 raw calcium data
	%GiGA1_list_of_tifs = dir ([GiGA1_image_directory, '*.tif']) ; % get all the filenames 
	%RAR_caproc_parloop (eleclocs_file, GiGA1_list_of_tifs) ; 

	% Pearson correlation of of Calcium ROIs
	%cd (current_path);
	%RAR_normalization_ROI_only (ZMG_metadata_file, ACSF_output_filename, ZMG_output_filename);
	%RAR_Pearson_correlation_wilcoxon ("normalized_ROI.mat");

end