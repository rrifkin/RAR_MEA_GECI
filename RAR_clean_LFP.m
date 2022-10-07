% Accepts .mat file containing downsampled LFP data, plots the data,
% and allows the user to interactively select artifact regions. Outputs 
% .csv files containing artifact timepoints (assumes 2000 Hz) and bad
% channels, and saves a plot of the cleaned data for sanity checking.

function RAR_clean_LFP (input_file)

    % Import LFP data
    LFP_data = importdata (input_file);

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(LFP_data(1,:));
    LFP_samples = [1:LFP_length];
    num_channels = length(LFP_data(:,1));

	% Plot the data
	RAR_plot_for_ginput (LFP_samples, LFP_data, 2000, num_channels);

	% User selects timepoints containing artifacts. There must be an even 
	% number of clicks; each pair surrounds the artifacts. Only x values 
	% are used; y is ignored.  
    [artifact_samples, ~] = ginput;
    artifact_samples = reshape(artifact_samples,2,[]);
    artifact_samples = transpose(artifact_samples);
    artifact_samples = int64(artifact_samples);

	% User is asked which channels are bad, which will be deleted.
	bad_channels = input ("What are the bad channels? ");
	close;

	artifact_file = strcat(input_file, '_artifact_samples.csv');
	writematrix(artifact_samples, artifact_file);

	bad_channels_file = strcat(input_file, '_bad_channels.csv');
	writematrix(bad_channels, bad_channels_file);

    % delete selected time ranges (columns) from LFP_data
    for i=1:length(artifact_samples(:,1))
        LFP_data(:,artifact_samples(i,1):artifact_samples(i,2)) = NaN;
    end

    % delete selected channels (rows) from LFP_data
    LFP_data(bad_channels(:),:) = [] ; 
    num_channels = length(LFP_data(:,1));

    % plot the cleaned data as a sanity check
    clean_plot_file = strcat(input_file, "_clean.pdf");
	RAR_plot_traces (LFP_samples, LFP_data, 2000, num_channels, clean_plot_file);

end

function RAR_plot_for_ginput(samples, amplitudes, sample_rate, channels)

	% parameters
	vertical_increment = 1000;

	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);

	% plot sequential traces in ascending order
	hold (ax, 'on'); 
    plot(samples,amplitudes(1,:))
    offset = 0 ; % is incremented to make channels appear above each other
	for index = 1:channels
		y_offset = amplitudes(index,:) + offset ;
		plot(samples, y_offset);
        offset = offset + vertical_increment ; 
    end
	hold (ax, 'off'); 

	% calculate x-axis properties
	tick_interval = (sample_rate * 60); % set a tick mark every 1 minute 
	num_samples = length (samples);
	minutes = num_samples / sample_rate / 60 ;

	% calculate y-axis properties
	y_minimum = -1 * vertical_increment;
	y_maximum = (channels * vertical_increment); 
	y_maximum_tick = y_maximum - vertical_increment;

	% set x-axis properties
	ax.XLim =[0, num_samples];
	ax.XTick = 0:tick_interval:num_samples ;
	ax.XTickLabel = 0:minutes;

	% set y-axis properties
	ax.YLim = [y_minimum,y_maximum];
	ax.YTick = 0:vertical_increment:y_maximum_tick;
	ax.YTickLabel = 1:channels;

	% set axis and figure properties
	ax.FontSize = 6;
	fig.Position = [0, 0, 8000, 100000];

end