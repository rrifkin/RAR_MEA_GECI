function RAR_two_groups_violinplot_arrays_paired (csv_file, units, remoutliers)

	raw_data = readtable(csv_file)
	names = categorical(raw_data.Properties.VariableNames);

	% remove NaN and optionally outliers (3 scaled median absolute deviations)
	if remoutliers == true
		raw_data = rmoutliers(raw_data); % removes as row, for paired analysis
	end
	raw_data = rmmissing(raw_data); % removes any row containing NaN or missing data

	data1 = raw_data.(1);
	data2 = raw_data.(2);

	% capture basic descriptive statistics
	n = [length(data1), length(data2)]
	means = [mean(data1), mean(data2)]
	SEM = [RAR_sem(data1), RAR_sem(data2)]

	test = 'Wilcoxon Signed-Rank'
	[p,h,stats] = signrank (data1, data2)
	
	% create figure and axes
	fig = figure(); 
	ax = axes('linewidth',1, 'fontweight','bold', 'fontsize', 14);
	pbaspect([1,1.5,1]);
	fig.Visible = 'off';

	% add data and labels to axes
	hold (ax, 'on');

	plot1 = Violin({data1}, 1, ...                                                                        
    'DataStyle', 'scatter',...
	'QuartileStyle','none',...
    'ShowMedian', true); 

	plot2 = Violin({data2}, 2, ...                                                                        
    'DataStyle', 'scatter',...
	'QuartileStyle','none',...
    'ShowMedian', true); 

	ax.YLabel.String = units; 
	ax.XTick = [1,2];
	ax.XTickLabel = names;
	p = round(p,4,'significant');

	p_t = num2str(p);
	p_text = strcat ("p = ", p_t);
	text(0.5, 0.95, p_text, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'fontweight','bold', 'fontsize', 12);
	

	n1 = num2str(n(1));
	n1_text = strcat ("n = ", n1);
	text(0.25, 0.025, n1_text, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'fontweight','bold', 'fontsize', 12);

	n2 = num2str(n(2));
	n2_text = strcat ("n = ", n2);	
	text(0.75, 0.025, n2_text, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'fontweight','bold', 'fontsize', 12);

	box on;
	axis padded;

	hold (ax, 'off');

	% save plot to PDF file
	output_file = strcat(csv_file(1:end-4), '_violinplot.pdf'); %'_violinplot_rmoutlier_n.pdf');
	saveas(fig,output_file);

	% log output to text file
	text_filename = strcat(csv_file(1:end-4), '_violinplot.txt');
	text_file = fopen(text_filename, 'wt');
	fprintf(text_file,'input file = %s\n', csv_file);
	fprintf(text_file,'groups = %s, %s\n', names(1), names(2));
	fprintf(text_file,'n = %d, %d\n', n(1), n(2));
	fprintf(text_file,'outliers removed? = %d\n', remoutliers);
	fprintf(text_file,'means = %.4f, %.4f\n', means(1), means(2));
	fprintf(text_file,'SEM = %.4f, %.4f\n', SEM(1), SEM(2));

	signrank_text = num2str(stats.signedrank);

	zval_text = "";
	if exist ('stats.zval','var')
		zval_text = num2str(stats.zval);
	end

	description_string = strcat(test, ", W = ", signrank_text, ", z = ", zval_text, ", n1 = ", n1, ", n2 = ", n2, ", p = ", p_t);
	fprintf(text_file,'%s\n', description_string);

end