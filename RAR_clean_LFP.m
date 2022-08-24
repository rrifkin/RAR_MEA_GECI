% Accepts variable number of .mat files containing downsampled LFP data,
% and concatenates and analyzes them. The files are assumed to be in
% chronological order.

function RAR_clean_LFP (input_file)

    % Import LFP data
    LFP_data = importdata (input_file);

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(LFP_data(1,:));
    LFP_samples = [1:LFP_length];
    num_channels = length(LFP_data(:,1));

	% Plot the data
	RAR_plot_traces (LFP_samples, LFP_data, 2000, num_channels);

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