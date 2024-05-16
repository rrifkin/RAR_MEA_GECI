function RAR_plot_cross_correl_histogram_per_channel (DMSO_bins_file, GiGA1_bins_file)

	window = 0.020; % time in seconds before and after spike
	bin_width = 0.001; % bin width in seconds
	y_minimum = 0;
	y_maximum = 3;

	DMSO_bins = load(DMSO_bins_file);
	GiGA1_bins = load(GiGA1_bins_file);

	DMSO_bin_means = mean(DMSO_bins);
	GiGA1_bin_means = mean(GiGA1_bins);

	x = -window:bin_width:window-bin_width;
	x = x*1000;

	% create fig and axis
	fig = figure;
	ax = axes(fig);
	fig.Visible = 'off';

	ax.YLim = [y_minimum,y_maximum];

	hold on

	y = [DMSO_bin_means' GiGA1_bin_means']
	b = bar(x,y);

	set(b, {'DisplayName'}, {'DMSO','GiGA1'}');
	legend();

	print('-painters', '-dpdf', fig);

	hold off




end
