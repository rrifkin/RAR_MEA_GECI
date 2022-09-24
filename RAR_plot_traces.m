% plots multiple channels over a period of time

function RAR_plot_traces(samples, amplitudes, sample_rate, channels, output_file)

	% parameters
	vertical_increment = 200;

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% calculate x-axis properties
	tick_interval = (sample_rate * 60); % set a tick mark every 1 minute 
	num_samples = length (samples);
	minutes = num_samples / (sample_rate * 60);

	% calculate y-axis properties
	y_minimum = -1 * vertical_increment;
	y_maximum = (channels * vertical_increment); 
	y_maximum_tick = y_maximum - vertical_increment;

	% set x-axis properties
	ax.XLim =[0, num_samples];
	ax.XTick = 0:tick_interval:num_samples ;
	ax.XTickLabel = 0:minutes;

	% set y-axis properties
	ax.YLim = [y_minimum,y_maximum];
	ax.YTick = 0:vertical_increment:y_maximum_tick;
	ax.YTickLabel = 1:channels;
	ax.FontSize = 6;
	fig_ratio = (channels / 10 ) / minutes
	ax.PlotBoxAspectRatio = [1, fig_ratio, 1];

	% set figure properties
	fig.Visible = 'on';
	fig.Renderer = 'painters';
	fig.Units = 'normalized'; 
	fig.Position = [0, 0, 1, fig_ratio];
	
	% set 'paper' properties
	fig.PaperPositionMode = 'manual';
	fig.PaperUnits = 'centimeters';
	fig.PaperPosition = [0, 0, minutes / 3, channels / 10];
	fig.PaperSize = [minutes /3 , channels / 10];

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


	