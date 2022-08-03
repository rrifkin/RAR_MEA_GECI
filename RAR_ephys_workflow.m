% Main script for processing a multielectrode recording experiment

function RAR_ephys_workflow (ACSF_file, ZMG_file)

	[ ~ , ZMG_output_filename, ~ ] = fileparts(ZMG_file);
	[ ~ , ACSF_output_filename, ~ ] = fileparts(ACSF_file);

	[ACSF_MUA, ACSF_LFP] = DownSamplingAndDetectMUA('seizure_recording', ACSF_file, 'baseline_recording', ACSF_file,'T', [0 600],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', ACSF_output_filename);
	[ZMG_MUA, ZMG_LFP] = DownSamplingAndDetectMUA('seizure_recording', ZMG_file, 'baseline_recording', ACSF_file,'T', [0 1800],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', ZMG_output_filename);

	time = [1:3600000] ;  % creates an array of time in seconds corresponding to 1800 second ZMG file

	PDF_output_filename = strcat(ZMG_output_filename, '.pdf');

	RAR_plot_traces (time, ZMG_LFP, 2000, 96, PDF_output_filename);

end