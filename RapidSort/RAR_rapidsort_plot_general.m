% plot rapidsort data

function RAR_rapidsort_plot_general (exp, path, timepoints, seconds_per_inch, PC_Hz_per_inch)


	% initialize arrays with data from ACSF baseline
	rapidINfr = exp(1).rapidINfr;
	rapidINt = exp(1).rapidINt;
	rapidPCfr = exp(1).rapidPCfr;
	rapidPCt = exp(1).rapidPCt;

	% add data from ZMG-DMSO and ZMG-GiGA1 to arrays
	for i = 2:length(exp)
		
		rapidINfr = [rapidINfr, exp(i).rapidINfr];

		% adjust for the exact starting time of the data
		exp(i).temp_rapidINt = exp(i).rapidINt + rapidINt(end);  
		rapidINt = [rapidINt, exp(i).temp_rapidINt];
		
		rapidPCfr = [rapidPCfr, exp(i).rapidPCfr];

		% adjust for the exact starting time of the data
		exp(i).temp_rapidPCt = exp(i).rapidPCt + rapidPCt(end);  
		rapidPCt = [rapidPCt, exp(i).temp_rapidPCt];
	end

	% parameters
	pad = 0.25; % padding around axes in inches
	PC_to_IN_ratio = 5; % determines vertical scale for IN
	PC_y_ticks = PC_Hz_per_inch / 10;
	IN_y_ticks = PC_y_ticks / PC_to_IN_ratio;
	seconds = timepoints(2) - timepoints(1); % total length of recording in seconds
	window = 10000; % number of data points centered around current value
	line_width = 0.5;

	% gaussian smoothing of data
	smoothINfr = smoothdata(rapidINfr, 'gaussian', window);
	smoothPCfr = smoothdata(rapidPCfr, 'gaussian', window);

	% determine axis limits
	smoothPCfr_max = max(smoothPCfr);
	PC_y_maximum = smoothPCfr_max + 10;
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
	plot(rapidPCt, smoothPCfr, 'Color', 'blue', 'LineWidth', line_width);

	% make horizontal scalebar
	line([timepoints(1), timepoints(1) + 60],[0,0], 'Color', 'black');
	text(timepoints(1) + 2, -2, '1 minute', 'FontSize', 5);

	yyaxis right
	ylim([0,IN_y_maximum]);
	yticks(0:IN_y_ticks:IN_y_maximum);
	plot(rapidINt, smoothINfr, 'Color', 'red', 'LineWidth', line_width);

	hold (ax, 'off');

	pathparts = strsplit(path,filesep);
	file_stem = string(pathparts(end));
	output_path = strcat(path, '/', file_stem, '_rapidsort_gaussian_firing_rates_general.pdf');

	print('-painters', '-dpdf', fig, output_path);

end
