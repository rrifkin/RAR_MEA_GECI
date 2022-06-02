% Main script for processing a calcium imaging experiment

function RAR_calcium_workflow (radius, eleclocs_file, ACSF_image_directory, ZMG_image_directory, ZMG_metadata_file)

	% number of frames in last tif file for each experiment phase
	ACSF_last_tif_frames = 720 ;
	ZMG_last_tif_frames = 240 ;

	% current path
	current_path = '~/Desktop';

	% Process ACSF raw calcium data
	cd (ACSF_image_directory) ; % navigate to ACSF image directory
	ACSF_list_of_tifs = dir ("*.tif") ; % get all the filenames 
	ACSF_number_of_tifs =  length (ACSF_list_of_tifs) ; % count number of tifs in the directory
	ACSF_filename_prefix = erase(ACSF_list_of_tifs(1,1).name,".ome.tif"); % extract filename prefix from first element of list of tifs
	ACSF_output_filename = strcat(current_path, "/", ACSF_filename_prefix, ".mat"); 
	disp(ACSF_output_filename)
	RAR_caproc_parloop (radius, eleclocs_file, ACSF_number_of_tifs, ACSF_filename_prefix, ".ome.tif", ACSF_last_tif_frames, ACSF_output_filename) ; 

	% Process ZMG raw calcium data
	cd (ZMG_image_directory) ; % navigate to ZMG image directory
	ZMG_list_of_tifs = dir ("*.tif") ; % get all the filenames 
	ZMG_number_of_tifs =  length (ZMG_list_of_tifs) ; % count number of tifs in the directory
	ZMG_filename_prefix = erase(ZMG_list_of_tifs(1,1).name,".ome.tif"); % extract filename prefix from first element of list of tifs
	ZMG_output_filename = strcat(current_path, "/", ZMG_filename_prefix, ".mat"); 
	RAR_caproc_parloop (radius, eleclocs_file, ZMG_number_of_tifs, ZMG_filename_prefix, ".ome.tif", ZMG_last_tif_frames, ZMG_output_filename) ; 

	% Pearson correlation of of Calcium ROIs
	RAR_normalization_ROI_only (ZMG_metadata_file, ACSF_output_filename, ZMG_output_filename);
	RAR_Pearson_correlation_wilcoxon ("normalized_ROI.mat");

end