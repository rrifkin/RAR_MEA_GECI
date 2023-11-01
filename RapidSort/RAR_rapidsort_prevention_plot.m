% plot rapidsort data

function RAR_rapidsort_prevention_plot (exp, path)

	% parameters
	pad = 0.5; % padding around axes in inches
	minutes_per_inch = 1; % determines horizontal scale
	Hz_per_inch = 15; % determines vertical scale
	seconds = 600; % initialize with length of ACSF
	tick_interval = 300; % in seconds
	window = 20000; % number of data points centered around current value
	fontsize = 16;
	line_offset = 2;
	text_offset = 3;
	line_width = 3;

	% initialize arrays with data from ACSF baseline
	rapidINfr = exp(1).rapidINfr;
	rapidINt = exp(1).rapidINt;
	rapidPCfr = exp(1).rapidPCfr;
	rapidPCt = exp(1).rapidPCt;

	% add data from ZMG-GiGA1 and/or ZMG-DMSO to arrays
	for i = 2:length(exp)

		rapidINfr = [rapidINfr, exp(i).rapidINfr];

		% adjust for the exact starting time of the data
		exp(i).temp_rapidINt = exp(i).rapidINt + rapidINt(end); % - exp(i).rapidINt(1)  
		rapidINt = [rapidINt, exp(i).temp_rapidINt];
		
		rapidPCfr = [rapidPCfr, exp(i).rapidPCfr];

		% adjust for the exact starting time of the data
		exp(i).temp_rapidPCt = exp(i).rapidPCt + rapidPCt(end); % - exp(i).rapidPCt(1)  
		rapidPCt = [rapidPCt, exp(i).temp_rapidPCt];

		seconds = seconds + 1800
	end

	% gaussian smoothing of data
	smoothINfr = smoothdata(rapidINfr, 'gaussian', window);
	smoothPCfr = smoothdata(rapidPCfr, 'gaussian', window);

	% determine axis limits
	smoothPCfr_max = max(smoothPCfr);
	smoothINfr_max = max(smoothINfr);
	y_maximum = max(smoothPCfr_max, smoothINfr_max) + 10;
	ax_height = y_maximum / Hz_per_inch;
	minutes = seconds / 60;
	ax_width = minutes / minutes_per_inch;
	line_height = [y_maximum, y_maximum] - 5; 

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% set x-axis properties
	ax.XLim =[0, seconds];
	ax.XTick = 0:tick_interval:seconds ;
	ax.XTickLabel = 0:5:minutes;

	% set y-axis properties
	ax.YLim = [0,y_maximum];

	% set general axis properties
	ax.FontSize = fontsize;
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
		plot(rapidINt, smoothINfr, 'Color', 'red', 'LineWidth', line_width);
		plot(rapidPCt, smoothPCfr, 'Color', 'blue', 'LineWidth', line_width)

	hold (ax, 'off');

	pathparts = strsplit(path,filesep);
	file_stem = string(pathparts(end));
	output_path = strcat(path, '/', file_stem, '_rapidsort_gaussian_firing_rates.pdf');

	print('-painters', '-dpdf', fig, output_path);

end
