function RAR_two_groups_violinplot (csv_file, units, type)

	raw_data = readtable(csv_file);
	names = categorical(raw_data.Properties.VariableNames);

	% remove outliers from data using default method (3 scaled median absolute deviations
	data = rmoutliers(raw_data);

	% capture basic descriptive statistics
	n_raw = [length(raw_data.(1)), length(raw_data.(2))]
	n = [length(data.(1)), length(data.(2))]
	means = mean(data.Variables, 'omitnan')
	SEM = RAR_sem (data.Variables)

	% hypothesis testing depending on type of data
	if strcmp(type, 'unpaired')
		test = 'Wilcoxon Rank-Sum (Unpaired)'
		p = ranksum(data.(1), data.(2))
	end
	if strcmp(type, 'paired')
		test = 'Wilcoxon Signed-Rank (Paired)'
		p = signrank (data.(1), data.(2))
	end
	
	% create figure and axes
	fig = figure(); 
	ax = axes('linewidth',1, 'fontweight','bold', 'fontsize', 14);
	pbaspect([1,1.5,1]);

	% add data and labels to axes
	hold (ax, 'on');

	plot = violinplot(data, names, 'ShowMean', true);  
	ax.YLabel.String = units; 
	p_text = strcat ("p = ", num2str(p));
	text(0.5, 0.95, p_text, 'HorizontalAlignment', 'center', 'Units', 'normalized');
	
	hold (ax, 'off');

	% save plot to PDF file
	output_file = strcat(csv_file(1:end-4), '_rmoutliers_violinplot.pdf');
	saveas(fig,output_file);

	% log output to text file
	text_filename = strcat(csv_file(1:end-4), '_rmoutliers.txt');
	text_file = fopen(text_filename, 'wt');
	fprintf(text_file,'input file = %s\n', csv_file);
	fprintf(text_file,'groups = %s, %s\n', names(1), names(2));
	fprintf(text_file,'n (raw) = %d, %d\n', n_raw(1), n_raw(2));
	fprintf(text_file,'n (outliers removed) = %d, %d\n', n(1), n(2));
	fprintf(text_file,'means = %.4f, %.4f\n', means(1), means(2));
	fprintf(text_file,'SEM = %.4f, %.4f\n', SEM(1), SEM(2));
	fprintf(text_file,'test = %s\n', test);
	fprintf(text_file,'%s\n', p_text);

end