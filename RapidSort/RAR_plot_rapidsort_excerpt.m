% plot rapidsort data excerpt

function RAR_plot_rapidsort_excerpt (firing_rates_file, timepoints)

	load (firing_rates_file, 'rapidINfr', 'rapidINt', 'rapidPCfr', 'rapidPCt');

	% parameters
	pad = 0.25; % padding around axes in inches
	seconds_per_inch = 60; % determines horizontal scale
	PC_Hz_per_inch = 50; % determines vertical scale for PC
	IN_Hz_per_inch = 10;
	seconds = timepoints(2) - timepoints(1); % total length of recording in seconds
	window = 20000; % number of data points centered around current value
	line_width = 1;

	% gaussian smoothing of data
	smoothINfr = smoothdata(rapidINfr, 'gaussian', window);
	smoothPCfr = smoothdata(rapidPCfr, 'gaussian', window);

	% find index values of arrays that are equivalent to start and end times
	indexIN = find(rapidINt > timepoints(1) & rapidINt < timepoints(2));
	indexPC = find(rapidPCt > timepoints(1) & rapidPCt < timepoints(2));

	% determine axis limits
	smoothPCfr_max = max(smoothPCfr);
	smoothINfr_max = max(smoothINfr);
	PC_y_maximum = smoothPCfr_max + 10;
	IN_y_maximum = smoothINfr_max + 2;
	PC_ax_height = PC_y_maximum / PC_Hz_per_inch;
	IN_ax_height = IN_y_maximum / IN_Hz_per_inch;
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
	yticks(0:10:PC_y_maximum);
	plot(rapidPCt(indexPC(:)), smoothPCfr(indexPC(:)), 'Color', 'blue', 'LineWidth', line_width);

	% make horizontal scalebar
	line([timepoints(1), timepoints(1) + 60],[0,0], 'Color', 'black');
	text(timepoints(1) + 2, -2, '1 minute', 'FontSize', 5);

	yyaxis right
	ylim([0,IN_y_maximum]);
	yticks(0:2:IN_y_maximum);
	plot(rapidINt(indexIN(:)), smoothINfr(indexIN(:)), 'Color', 'red', 'LineWidth', line_width);

	hold (ax, 'off');

	str_timepoints = string(timepoints);
	str_timepoints = strjoin(str_timepoints, '-');
	output_file = strcat (firing_rates_file(1:end-4), "_excerpt_sec_", str_timepoints, ".pdf");

	print('-painters', '-dpdf', fig, output_file);

end
