

function RAR_compare_two_groups (csv_file, units)

	data = readtable(csv_file);
	means = mean(data.Variables, 'omitnan');
	SEM = RAR_sem (data.Variables);
	names = categorical(data.Properties.VariableNames);

	p = ranksum(data.(1), data.(2))

	fig = figure(); 
	ax = axes('linewidth',1, 'fontweight','bold', 'fontsize', 14);
	hold (ax, 'on');

	bar_chart = bar(ax, names, means, 'linewidth',1.5);
	ax.YLabel.String = units; 
	
	pbaspect([1,1.5,1]);

	errorbar(ax, names, means, SEM, 'k','linestyle','none','linewidth',1.5, 'HandleVisibility','off');

	hold (ax, 'off')

	output_file = strcat(csv_file(1:end-4), '.pdf');
	saveas(fig,output_file)
end