function RAR_plot(times, amps, bar, output_file)

	plot(times, amps);
	xlim([0 1800]);
	ylim([1 2]);
	y = bar;
	if y ~= 0
		line([901,1800],[y,y]);
	end
	saveas(gcf,output_file)
end