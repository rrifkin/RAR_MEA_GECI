function RAR_plot_sequential_traces_ephys(times, amps, bar, output_file)

	for channel = 1:96
		plot(times, amps(channel,:));
		xlim([0 1800]);
		ylim([1 50]);
		y = bar;
		if y ~= 0
			line([901,1800],[y,y]);
        end
        set(gcf,'units','centimeters','position',[10,10,1800,2])
		set(gcf, 'units','centimeters','PaperSize', [1800,100]);
		sequential_output_file = output_file + string(channel);
		saveas(gcf,sequential_output_file);
end