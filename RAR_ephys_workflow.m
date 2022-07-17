% Main script for processing a multielectrode recording experiment

function RAR_ephys_workflow (ACSF_file, ZMG_file)

	RAR_downsample(ACSF_file, ZMG_file);
	time = [1:3600000] % creates an array of time in seconds corresponding to 1800 second ZMG file
    load('LFPDownSampledoutput_zmg.mat');
	[output_file_path, output_file_name, output_file_extension] = fileparts(ZMG_file);
	output_file_name = output_file_path + output_file_name ; 
	RAR_plot_sequential_traces_ephys (time,seizure_downsampled, 10, output_file_name);

end