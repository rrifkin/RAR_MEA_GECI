% plots a subset of channels over a subset of time, for figure-making purposes
% input_file = .mat file containing data
% sample_rate = usually 2000
% channels = vector of channels to plot, e.g. 1:4 
% timepoints = start and end times to plot in seconds, e.g. [60, 180]

function RAR_plot_LFP_excerpt (input_file, sample_rate, channels, timepoints, output_file)

	start_sample = timepoints(1) * sample_rate;
	end_sample = timepoints(end) * sample_rate;

	all_data = importdata(input_file);
	excerpt = all_data(channels, start_sample:end_sample);

	% Determine the length of the excerpted LFP data and make an array
	% representing each sample
	[num_channels , num_samples] = size(excerpt);
	samples = [1:num_samples];

	% parameters
	vertical_increment = 1000; % vertical separation between channels in microvolts
	minutes_per_inch = 1; % determines horizontal scale
	channels_per_inch = 10; % determines vertical scale
	pad = 0.25; % padding around axes in inches

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% calculate x-axis properties
	minutes = num_samples / (sample_rate * 60) ;
	ax_width = minutes / minutes_per_inch; 

	% calculate y-axis properties
	y_minimum = -1 * vertical_increment;
	y_maximum = (num_channels * vertical_increment); 
	ax_height = num_channels / channels_per_inch; 

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

	% plot sequential traces in ascending order
	hold (ax, 'on'); 
    offset = 0 ; % is incremented to make channels appear above each other
	for index = 1:num_channels 
		y_offset = excerpt(index,:) + offset ;
		plot(samples, y_offset);
        offset = offset + vertical_increment ; 
    end

	% make scalebar
	line([0, (sample_rate * 60)],[-1000,-1000], 'Color', 'black');
	text(((sample_rate * 60) / 2), -1000, "1 minute")

	line([0, 0],[-1000,vertical_increment - 1000], 'Color', 'black') %'LineWidth', line_width);

	hold (ax, 'off'); 

	if exist ('output_file','var') == 1
		print('-painters', '-dpdf', fig, output_file);
	end