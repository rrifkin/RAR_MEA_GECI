% Main script for processing a calcium imaging experiment

function RAR_calcium_workflow (radius, eleclocs_file, ACSF_image_directory, ZMG_image_directory)

	% define constants
	radius = '';
	eleclocs_file = '';
	ACSF_image_directory = '';
	ZMG_image_directory = '';

	% Process raw calcium data
	RAR_caproc_parloop (radius, eleclocs_file, number_of_tifs, tif_filename_prefix, tif_filename_suffix, last_tif_frames, output_filename)

	% Pearson correlation of of Calcium ROIs
	RAR_normalization_ROI_only (metadata_file, raw_acsf, raw_zmg)
	RAR_Pearson_correlation_wilcoxon (data)

end