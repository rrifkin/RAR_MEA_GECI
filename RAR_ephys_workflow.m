% Main script for processing a multielectrode recording experiment

function RAR_ephys_workflow (ACSF_file, ZMG_files)

	ACSF_file = char (ACSF_file);
	[ ~ , ACSF_filename, ~ ] = fileparts(ACSF_file);
	[ACSF_MUA, ACSF_LFP] = DownSamplingAndDetectMUA('seizure_recording', ACSF_file, 'baseline_recording', ACSF_file,'T', [0 600],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', ACSF_filename);
	current_length = length(ACSF_LFP)
	split_products = split(ACSF_filename,",");
	current_label = split_products(end)
	labels = {};
	current_label_array = {current_label{:}, current_length};
	labels = {current_label_array}
	LFP_data = [ACSF_LFP];

	for current_ZMG_file = ZMG_files
		current_ZMG_file = char(current_ZMG_file);
		[ ~ , current_ZMG_filename, ~ ] = fileparts(current_ZMG_file);
		[current_ZMG_MUA, current_ZMG_LFP] = DownSamplingAndDetectMUA('seizure_recording', current_ZMG_file, 'baseline_recording', ACSF_file,'T', [0 1800],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', current_ZMG_filename);
		LFP_data = [LFP_data, current_ZMG_LFP]
		current_length = length(current_ZMG_LFP)
		split_products = split(current_ZMG_filename,",");
		current_label = split_products(end)
		current_label_array = {current_label{:}, current_length};
		labels = {labels; current_label_array}
    end

    LFP_data = RAR_plot_LFP (filenames{:})

	LFP_length = length(LFP_data);
    LFP_samples = [1:LFP_length];

	% PDF_output_filename = strcat(ZMG_output_filename, '.pdf');

	RAR_plot_traces (LFP_samples, LFP_data, 2000, 96, "output.pdf");

end