% plot rapidsort data

function RAR_rapidsort_plot_structured (exp, path)

	% parameters
	pad = 0.5; % padding around axes in inches
	minutes_per_inch = 1; % determines horizontal scale
	Hz_per_inch = 15; % determines vertical scale
	seconds = 3000; % total length of recording in seconds
	minutes = seconds / 60;
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

	% add data from ZMG-DMSO and ZMG-GiGA1 to arrays
	for i = 2:length(exp)
		
		rapidINfr = [rapidINfr, exp(i).rapidINfr];

		% adjust for the exact starting time of the data
		exp(i).temp_rapidINt = exp(i).rapidINt + rapidINt(end); % - exp(i).rapidINt(1)  
		rapidINt = [rapidINt, exp(i).temp_rapidINt];
		
		rapidPCfr = [rapidPCfr, exp(i).rapidPCfr];

		% adjust for the exact starting time of the data
		exp(i).temp_rapidPCt = exp(i).rapidPCt + rapidPCt(end); % - exp(i).rapidPCt(1)  
		rapidPCt = [rapidPCt, exp(i).temp_rapidPCt];
	end

	% gaussian smoothing of data
	smoothINfr = smoothdata(rapidINfr, 'gaussian', window);
	smoothPCfr = smoothdata(rapidPCfr, 'gaussian', window);

	% set timing of drug lines
	ZMG_times = [exp(2).temp_rapidINt(1) , exp(2).temp_rapidINt(end) ];
	GiGA1_times = [exp(3).temp_rapidINt(1) , exp(3).temp_rapidINt(end) ];

	% determine axis limits
	smoothPCfr_max = max(smoothPCfr);
	smoothINfr_max = max(smoothINfr);
	y_maximum = max(smoothPCfr_max, smoothINfr_max) + 10;
	ax_height = y_maximum / Hz_per_inch;
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
		line(ZMG_times,line_height, 'Color', 'black', 'LineWidth', line_width);
		text(mean(ZMG_times), line_height(1) + text_offset, "DMSO", 'FontSize', fontsize);
		line(GiGA1_times, line_height - line_offset, 'Color', 'black', 'LineWidth', line_width);
		text(mean(GiGA1_times), line_height(1) - line_offset + text_offset, "GiGA1", 'FontSize', fontsize);

	hold (ax, 'off');

	pathparts = strsplit(path,filesep);
	file_stem = string(pathparts(end));
	output_path = strcat(path, '/', file_stem, '_rapidsort_gaussian_firing_rates.pdf');

	print('-painters', '-dpdf', fig, output_path);

end
