% plots multiple channels over a period of time

function RAR_plot_traces(samples, amplitudes, sample_rate, channels, output_file)

	% parameters
	vertical_increment = 200;
	y_minimum = -200;

	% plot sequential traces in ascending order
	hold on;
	offset = 0 ; % is incremented to make channels appear above each other
	for index = 1:channels
		y_offset = amplitudes(index,:) + offset ;
		plot(samples, y_offset);
		offset = offset + vertical_increment ; 
    end

	fig = gcf;
	ax = gca;

	% determine parameters for axes
	tick_interval = (sample_rate * 60); % set a tick mark every 1 minute 
	num_samples = length (samples);
	minutes = num_samples / sample_rate / 60 ;
	y_maximum = (channels * vertical_increment); 

	% set parameters of axes
	ax.XLim =[0, num_samples];
    ax.YLim = [y_minimum,y_maximum];

	ax.XTick = 0:tick_interval:num_samples ;
	ax.XTickLabel = 0:minutes;

	ax.YTick = 0:vertical_increment:y_maximum;
	ax.YTickLabel = 1:channels;

	ax.FontSize = 6;

    set(gcf, 'Position', [100, 100, 8000, 40000])
	exportgraphics(gcf,output_file, 'ContentType', 'vector');
    hold off;