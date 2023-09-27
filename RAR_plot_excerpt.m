% plots a subset of channels over a subset of time, for figure-making purposes
% general purpose; can be used for LFP or GECI; use wrapper function
%
% makes a 0.1 vertical_scale x 1 minute scale bar (intended to be 
% repositioned and labeled in a graphics program)
% 
% input_file = .mat file containing data
% sample_rate = usually 2000
% channels = vector of channels to plot, e.g. 1:4 
% timepoints = start and end times to plot in seconds, e.g. [60, 180]
% vertical_scale = units per inch, e.g. 10,000 uV per inch, or 0.5 deltaF/F for GECI
% offset = vertical offset; 0 for LFP; -1 for GECI (because it is a ratio)

function RAR_plot_excerpt (input_file, sample_rate, channels, timepoints, vertical_scale, offset)

	start_sample = timepoints(1) * sample_rate;
	end_sample = timepoints(end) * sample_rate;

	all_data = importdata(input_file);
	excerpt = all_data(channels, start_sample:end_sample);

	% Determine the length of the excerpted LFP data and make an array
	% representing each sample
	[num_channels , num_samples] = size(excerpt);
	samples = [1:num_samples];

	% parameters
	minutes_per_inch = 1; % determines horizontal scale
	channels_per_inch = 10; % determines vertical increment
	vertical_increment = vertical_scale / channels_per_inch
	pad = 0.25; % padding around axes in inches

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% calculate x-axis properties
	minutes = num_samples / (sample_rate * 60) ;
	ax_width = minutes / minutes_per_inch; 

	% calculate y-axis properties
	y_minimum = -1 * vertical_increment
	y_maximum = (num_channels * vertical_increment)
	ax_height = num_channels / channels_per_inch 

	% set x-axis properties
	ax.XLim =[0, num_samples];
	ax.XAxis.Visible = 'off';

	% set y-axis properties
	ax.YLim = [y_minimum,y_maximum];
	ax.YAxis.Visible = 'off';

	% set general axis properties
	ax.FontSize = 6;
	ax.Units = 'inches';
	ax.Position = [pad, pad, ax_width, ax_height]; % location of axes within figure, and size of axes

	% set figure properties
	fig.Visible = 'off';
	fig.Renderer = 'painters';
	fig.Units = 'inches'; 
	fig.Position = [0, 0, ax_width + (2 * pad), ax_height + (2 * pad)]; % location and size of figure
	
	% set 'paper' properties
	fig.PaperPositionMode = 'manual';
	fig.PaperUnits = 'inches';
	fig.PaperPosition = [0, 0, ax_width + (2 * pad), ax_height + (2 * pad)]; % location and size of figure within paper
	fig.PaperSize = [ax_width + (2 * pad), ax_height + (2 * pad)]; % size of paper

	hold (ax, 'on'); 

	% plot sequential traces in ascending order
	for index = 1:num_channels 
		y_offset = excerpt(index,:) + offset ;
		plot(samples, y_offset);
        offset = offset + vertical_increment;
    end

	% make scalebar
	vertical_scalebar = 0.1 * vertical_scale 
	line([0, (sample_rate * 60)],[0,0], 'Color', 'black');
	line([0, 0],[0, vertical_scalebar], 'Color', 'black');
	text(3 * sample_rate, 0.5 * vertical_increment, string(vertical_scalebar), 'FontSize', 5);
	text(3 * sample_rate, -0.5 * vertical_increment, '1 minute', 'FontSize', 5);

	hold (ax, 'off'); 

	% determine output_file name
	str_channels = string(channels);
	str_channels = strcat(str_channels(1), '-', str_channels(end));
	str_timepoints = string(timepoints);
	str_timepoints = strjoin(str_timepoints, '-');
	output_file = strcat (input_file(1:end-4), "_excerpt_ch_", str_channels, "_min_", str_timepoints, ".pdf");

	% output to PDF
	if exist ('output_file','var') == 1
		print('-painters', '-dpdf', fig, output_file);
	end

end