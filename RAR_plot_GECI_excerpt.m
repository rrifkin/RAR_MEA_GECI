% plots a subset of channels over a subset of time, for figure-making purposes
% makes a 0.5 fluorescence unit x 1 minute scale bar 
% (intended to be repositioned and labeled in a graphics program)
% 
% input_file = "normalized_intensity.mat" file containing data
% channels = vector of channels to plot, e.g. 1:4 (MEA channels, not GECI elecs)
% timepoints = start and end times to plot in seconds, e.g. [60, 180]
% vertical_scale = units per inch, e.g. 3 deltaF/F for GECI

function RAR_plot_GECI_excerpt (input_file, channels, timepoints)

	% parameters
	vertical_scale = 3; % units per inch, e.g. 3 deltaF/F for GECI
	sample_rate = 50; % frames per second
	offset = -1; % vertical offset, set to -1 for GECI (because it is a ratio)

	% convert channels (MEA data) to electrode locations (GECI data) so that
	% regions displayed are the same for LFP and GECI excerpts
	electrodes = RAR_convert_chan_to_elec(channels)
	
	RAR_plot_excerpt(input_file, sample_rate, electrodes, timepoints, vertical_scale, offset);

end