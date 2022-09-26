% plots multiple channels over a period of time

function RAR_plot_traces(samples, amplitudes, sample_rate, channels, output_file)

	% parameters
	vertical_increment = 1000; % vertical separation between channels in microvolts
	minutes_per_inch = 1; % determines horizontal scale
	channels_per_inch = 10; % determines vertical scale
	pad = 0.25; % padding around axes in inches

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% calculate x-axis properties
	tick_interval = (sample_rate * 60); % set a tick mark every 1 minute 
	num_samples = length (samples);
	minutes = num_samples / (sample_rate * 60) ;
	ax_width = minutes / minutes_per_inch; 

	% calculate y-axis properties
	y_minimum = -1 * vertical_increment;
	y_maximum = (channels * vertical_increment); 
	y_maximum_tick = y_maximum - vertical_increment;
	ax_height = channels / channels_per_inch; 

	% set x-axis properties
	ax.XLim =[0, num_samples];
	ax.XTick = 0:tick_interval:num_samples ;
	ax.XTickLabel = 0:minutes;

	% set y-axis properties
	ax.YLim = [y_minimum,y_maximum];
	ax.YTick = 0:vertical_increment:y_maximum_tick;
	ax.YTickLabel = 1:channels;

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
    plot(samples,amplitudes(1,:))
    offset = 0 ; % is incremented to make channels appear above each other
	for index = 1:channels
		y_offset = amplitudes(index,:) + offset ;
		plot(samples, y_offset);
        offset = offset + vertical_increment ; 
    end
	hold (ax, 'off'); 

	if exist ('output_file','var') == 1
		print('-painters', '-dpdf', fig, output_file);
	end