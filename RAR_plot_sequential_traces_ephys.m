function RAR_plot_sequential_traces_ephys(x, y, bar_height, output_file)

	offset = 0 ;
    hold on;
	for channel = 1:96
		y_offset = y(channel,:) + offset ;
		plot(x, y_offset);
		offset = offset - 100 ; 
    end

	%if bar_height ~= 0
	%	line([901,1800],[bar_height,bar_height]);
	%end

	xlim([0, 3600000]);
    ylim([-10000,100]);

    set(gcf, 'Position', [10, 10, 4000, 20000])
	%set(gcf, 'units','centimeters','PaperSize', [100,100]);
	exportgraphics(gcf,output_file, 'ContentType', 'vector');
    hold off;