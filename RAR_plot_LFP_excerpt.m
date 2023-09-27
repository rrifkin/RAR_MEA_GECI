% plots a subset of channels over a subset of time, for figure-making purposes
% makes a 1 mV x 1 minute scale bar (intended to be repositioned and labeled in 
% a graphics program)
% 
% input_file = .mat file containing data
% sample_rate = usually downsampled to 2000 Hz
% channels = vector of channels to plot, e.g. 1:4 
% timepoints = start and end times to plot in seconds, e.g. [60, 180]
% vertical_scale = units per inch, e.g. 10,000 uV per inch

function RAR_plot_LFP_excerpt (input_file, channels, timepoints)

	% parameters
	vertical_scale = 10000; % units per inch, e.g. 10,000 uV per inch
	sample_rate = 2000; % LFP usually downsampled to 2000 Hz
	offset = 0; % vertical offset, set to 0 for LFP
	
	RAR_plot_excerpt(input_file, sample_rate, channels, timepoints, vertical_scale, offset);

end