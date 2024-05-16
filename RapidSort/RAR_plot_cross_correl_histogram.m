function RAR_plot_cross_correl_histogram (DMSO_bins_file, GiGA1_bins_file)

	window = 0.010; % time in seconds before and after spike
	bin_width = 0.002; % bin width in seconds

	DMSO_bins = load(DMSO_bins_file);
	GiGA1_bins = load(GiGA1_bins_file);

	DMSO_bin_means = mean(DMSO_bins);
	GiGA1_bin_means = mean(GiGA1_bins);

	x = -window:bin_width:window-bin_width;

	% create fig and axis
	fig = figure;
	ax = axes(fig);
	fig.Visible = 'off';

	y = [DMSO_bin_means' GiGA1_bin_means']
	b = bar(x,y);

	set(b, {'DisplayName'}, {'DMSO','GiGA1'}');
	legend();

	print('-painters', '-dpdf', fig);




end
