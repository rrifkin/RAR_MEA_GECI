function RAR_rapidsort_cross_correl_histogram (DMSO_bins_file, GiGA1_bins_file, window, bin_width)

	bar_width = 1;
	group_width = 0.8;
	x_label = "Time since IN spike (ms)";
	y_label = "Normalized PC spikes";
	fontsize = 14;
	xtick_fontsize = 10;

	window = window * 1000; % convert from seconds to ms
	bin_width = bin_width * 1000;

	DMSO_bins = load(DMSO_bins_file);
	GiGA1_bins = load(GiGA1_bins_file);

	DMSO_bin_means = mean(DMSO_bins);
	GiGA1_bin_means = mean(GiGA1_bins);

	DMSO_bin_sem = RAR_sem(DMSO_bins);
	GiGA1_bin_sem = RAR_sem(GiGA1_bins);

	x = -window:bin_width:window-bin_width;
	bar_locations = (-window + (bin_width/2)):bin_width:(window - (bin_width /2));

	y = [DMSO_bin_means' GiGA1_bin_means'];
	error = [DMSO_bin_sem' GiGA1_bin_sem'];

	% create fig and axis
	fig = figure;
	ax = axes(fig);
	fig.Visible = 'off';
	ax.FontSize = fontsize;

	% set x-axis properties
	ax.XLim =[-window,window];
	ax.XTick = -window:bin_width:window ;
	xtick_labels = -window:bin_width:window;
	xtick_labels = string(xtick_labels)
	ax.XTickLabel = xtick_labels;
	ax.XLabel.String = x_label;
	ax.XTickLabelRotation = 0; 
	ax.XAxis.FontSize = xtick_fontsize;
	ax.XLabel.FontSize = fontsize;

	% set y-axis properties
	ax.YLabel.String = y_label; 

	hold (ax,'on')

	b = bar(x, y, 'BarWidth', bar_width, 'XData', bar_locations, 'GroupWidth',group_width);

	[ngroups,nbars] = size(y);
	errorbar_locations = nan(nbars,ngroups);
	for i = 1:nbars
		errorbar_locations(i,:) = b(i).XEndPoints;
	end

	errorbar_locations = errorbar_locations';
	errorbar(errorbar_locations,y,error,'k','linestyle','none','HandleVisibility','off');

	set(b, {'DisplayName'}, {'DMSO','GiGA1'}');
	legend();

	hold (ax,'off')


	[path,~,~] = fileparts(DMSO_bins_file);
	output_path = strcat(path, "/IN_triggered_PC_spikes.pdf");

	print('-painters', '-dpdf', fig, output_path);




end
