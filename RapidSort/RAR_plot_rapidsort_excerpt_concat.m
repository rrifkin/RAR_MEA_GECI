% plot rapidsort concatenated files

function RAR_plot_rapidsort_excerpt_concat (DMSO_firing_rates_file, GiGA1_firing_rates_file, timepoints, seconds_per_inch, PC_Hz_per_inch)

	DMSO_data = load (DMSO_firing_rates_file, 'rapidINfr', 'rapidINt', 'rapidPCfr', 'rapidPCt');
	GiGA1_data = load (GiGA1_firing_rates_file, 'rapidINfr', 'rapidINt', 'rapidPCfr', 'rapidPCt');

	% initialize arrays with data from DMSO
	rapidINfr = DMSO_data.rapidINfr;
	rapidINt = DMSO_data.rapidINt;
	rapidPCfr = DMSO_data.rapidPCfr;
	rapidPCt = DMSO_data.rapidPCt;

	rapidINfr = [rapidINfr, GiGA1_data.rapidINfr];

	% adjust for the exact starting time of the data
	GiGA1_data.temp_rapidINt = GiGA1_data.rapidINt + rapidINt(end);   
	rapidINt = [rapidINt, GiGA1_data.temp_rapidINt];
		
	rapidPCfr = [rapidPCfr, GiGA1_data.rapidPCfr];

	% adjust for the exact starting time of the data
	GiGA1_data.temp_rapidPCt = GiGA1_data.rapidPCt + rapidPCt(end);
	rapidPCt = [rapidPCt, GiGA1_data.temp_rapidPCt];

	% parameters
	pad = 0.25; % padding around axes in inches
	%seconds_per_inch = 300; % determines horizontal scale
	%PC_Hz_per_inch = 200 %100; % determines vertical scale for PC
	PC_to_IN_ratio = 5; % determines vertical scale for IN
	PC_y_ticks = PC_Hz_per_inch / 10;
	IN_y_ticks = PC_y_ticks / PC_to_IN_ratio;
	seconds = timepoints(2) - timepoints(1); % total length of recording in seconds
	window = 10000; % number of data points centered around current value
	line_width = 0.5;

	% gaussian smoothing of data
	smoothINfr = smoothdata(rapidINfr, 'gaussian', window);
	smoothPCfr = smoothdata(rapidPCfr, 'gaussian', window);

	% find index values of arrays that are equivalent to start and end times
	indexIN = find(rapidINt > timepoints(1) & rapidINt < timepoints(2));
	indexPC = find(rapidPCt > timepoints(1) & rapidPCt < timepoints(2));

	% determine axis limits
	smoothPCfr_max = max(smoothPCfr);
	PC_y_maximum = smoothPCfr_max + 20;
	IN_y_maximum = PC_y_maximum / PC_to_IN_ratio; 
	PC_ax_height = PC_y_maximum / PC_Hz_per_inch;
	ax_width = seconds / seconds_per_inch;

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% set x-axis properties
	ax.XLim =[timepoints(1), timepoints(2)];
	ax.XAxis.Visible = 'off';

	% set general axis properties
	ax.Units = 'inches';
	ax.Position = [pad, pad, ax_width, PC_ax_height]; % location of axes within figure, and size of axes
	ax.FontSize = 6;

	% set figure properties
	fig.Visible = 'off';
	fig.Renderer = 'painters';
	fig.Units = 'inches'; 
	fig.Position = [0, 0, ax_width + (2 * pad), PC_ax_height + (2 * pad)]; % location and size of figure
	
	% set 'paper' properties
	fig.PaperPositionMode = 'manual';
	fig.PaperUnits = 'inches';
	fig.PaperPosition = [0, 0, ax_width + (2 * pad), PC_ax_height + (2 * pad)]; % location and size of figure within paper
	fig.PaperSize = [ax_width + (2 * pad), PC_ax_height + (2 * pad)]; % size of paper

	hold (ax, 'on');
	yyaxis left
	ylim([0,PC_y_maximum]);
	yticks(0:PC_y_ticks:PC_y_maximum);
	plot(rapidPCt(indexPC(:)), smoothPCfr(indexPC(:)), 'Color', 'blue', 'LineWidth', line_width);

	% make horizontal scalebar
	line([timepoints(1), timepoints(1) + 60],[0,0], 'Color', 'black');
	text(timepoints(1) + 2, -2, '1 minute', 'FontSize', 5);

	yyaxis right
	ylim([0,IN_y_maximum]);
	yticks(0:IN_y_ticks:IN_y_maximum);
	plot(rapidINt(indexIN(:)), smoothINfr(indexIN(:)), 'Color', 'red', 'LineWidth', line_width);

	hold (ax, 'off');

	output_file = strcat (DMSO_firing_rates_file(1:end-4), "DMSO_GiGA1_concatenated_firing rates.pdf");

	print('-painters', '-dpdf', fig, output_file);

end
