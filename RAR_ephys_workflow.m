% Main script for processing a multielectrode recording experiment

function RAR_ephys_workflow (ACSF_file, ZMG_files)

	[ ~ , ACSF_output_filename, ~ ] = fileparts(ACSF_file);
	ACSF_file = char (ACSF_file);
	ACSF_output_filename = char(ACSF_output_filename);
	[ACSF_MUA, ACSF_LFP] = DownSamplingAndDetectMUA('seizure_recording', ACSF_file, 'baseline_recording', ACSF_file,'T', [0 600],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', ACSF_output_filename);

	LFP_data = [ACSF_LFP];
	for current_ZMG_file = ZMG_files
		[ ~ , current_ZMG_output_filename, ~ ] = fileparts(current_ZMG_file);
		current_ZMG_file = char (current_ZMG_file);
		current_ZMG_output_filename = char (current_ZMG_output_filename);
		[current_ZMG_MUA, current_ZMG_LFP] = DownSamplingAndDetectMUA('seizure_recording', current_ZMG_file, 'baseline_recording', ACSF_file,'T', [0 1800],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', current_ZMG_output_filename);
		LFP_data = [LFP_data, current_ZMG_LFP];
	end

	LFP_length = length(LFP_data);

	% PDF_output_filename = strcat(ZMG_output_filename, '.pdf');

	RAR_plot_traces (LFP_length, LFP_data, 2000, 96, "output.pdf");

end