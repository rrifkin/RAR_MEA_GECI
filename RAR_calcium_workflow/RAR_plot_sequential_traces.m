function RAR_plot_sequential_traces(times, amps, bar, output_file)

	for channel = 1:96
		plot(times, amps(channel,:));
		xlim([0 1800]);
		ylim([1 2]);
		y = bar;
		if y ~= 0
			line([901,1800],[y,y]);
		end
		sequential_output_file = output_file + string(channel) + ".pdf";
		saveas(gcf,sequential_output_file);
end