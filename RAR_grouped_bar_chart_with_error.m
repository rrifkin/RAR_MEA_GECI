function RAR_grouped_bar_chart_with_error(data_array, error_array, xlabel_text, ylabel_text, legend_text, output_file)

	grouped_bar_chart = bar(data_array, 'grouped', 'linewidth',1.5, 'barwidth',1);

	hold on 
	xlabel(xlabel_text);
	ylabel(ylabel_text);
	legend(legend_text);
	set(gca,'linewidth',2,'fontweight','bold', 'fontsize', 14);
	pbaspect([1,1.5,1]);
	
	[ngroups,nbars] = size(data_array);
	x = nan(nbars, ngroups);
	for i = 1:nbars
		x(i,:) = grouped_bar_chart(i).XEndPoints;
	end

	errorbar(x',data_array,error_array,'k','linestyle','none','linewidth',1.5, 'HandleVisibility','off');

	hold off

	saveas(gcf,output_file)
end