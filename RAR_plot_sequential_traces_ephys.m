% plots multiple channels over a period of time

function RAR_plot_traces(samples, amplitudes, sample_rate, channels, bar_height, output_file)

	offset = 0 ;
    hold on;
	for index = 1:channels
		y_offset = amplitudes(index,:) + offset ;
		plot(samples, y_offset);
		offset = offset - 100 ; 
    end

	tick_interval = (sample_rate * 60); % set a tick mark every 1 minute 
	minutes = length(samples) / sample_rate / 60 ;

	xlim([0, samples]);
    ylim([-10000,100]);
	xticks(0:tick_interval:samples);
	xticklabels(0:minutes);

	%if bar_height ~= 0
	%	line([901,1800],[bar_height,bar_height]);
	%end

    set(gcf, 'Position', [10, 10, 4000, 20000])
	%set(gcf, 'units','centimeters','PaperSize', [100,100]);
	exportgraphics(gcf,output_file, 'ContentType', 'vector');
    hold off;