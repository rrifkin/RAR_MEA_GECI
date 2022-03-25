% Main script for processing a calcium imaging experiment

function RAR_calcium_workflow (radius, eleclocs_file, ACSF_image_directory, ZMG_image_directory)

	% number of frames in last tif file for each experiment phase
	ACSF_last_tif_frames = 720 ;
	ZMG_last_tif_frames = 240 ;

	cd (ACSF_image_directory) ; % navigate to ACSF image directory
	ACSF_list_of_tifs = dir ("*.tif") ; % get all the filenames 
	ACSF_number_of_tifs =  length (ACSF_list_of_tifs) ; % count number of tifs in the directory
	ACSF_filename_prefix = erase(ACSF_list_of_tifs(1,1).name,".tif"); % extract filename prefix from first element of list of tifs
	ACSF_output_filename = strcat(ACSF_filename_prefix, ".mat"); 

	% Process raw calcium data
	RAR_caproc_parloop (radius, eleclocs_file, ACSF_number_of_tifs, ACSF_filename_prefix, ".tif", ACSF_last_tif_frames, ACSF_output_filename) ; 

	% Pearson correlation of of Calcium ROIs
	% RAR_normalization_ROI_only (metadata_file, raw_acsf, raw_zmg)
	% RAR_Pearson_correlation_wilcoxon (data)

end