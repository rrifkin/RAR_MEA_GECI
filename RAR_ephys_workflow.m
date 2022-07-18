% Main script for processing a multielectrode recording experiment

function RAR_ephys_workflow (ACSF_file, ZMG_file)

	[output_file_path, output_file_name, output_file_extension] = fileparts(ZMG_file);

	[ACSF_MUA, ACSF_LFP] = DownSamplingAndDetectMUA('seizure_recording', ACSF_file, 'baseline_recording', ACSF_file,'T', [0 600],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', 'output_acsf');
	[ZMG_MUA, ZMG_LFP] = DownSamplingAndDetectMUA('seizure_recording', ZMG_file, 'baseline_recording', ACSF_file,'T', [0 1800],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', 'output_zmg');

	time = [1:3600000] % creates an array of time in seconds corresponding to 1800 second ZMG file
    load('LFPDownSampledoutput_zmg.mat');
	output_file_name = output_file_path + output_file_name ; 
	RAR_plot_sequential_traces_ephys (time,ZMG_LFP, 10, output_file_name);

end