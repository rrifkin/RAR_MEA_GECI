function RAR_linelength (LFP_file, artifact_file, bad_channels_file)

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = importdata(artifact_file);
	bad_channels = importdata (bad_channels_file);

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(LFP_data(1,:));
    LFP_samples = [1:LFP_length];
    num_channels = length(LFP_data(:,1));

    % delete selected time ranges (columns) from LFP_data
    for i=1:length(artifact_samples(:,1))
        LFP_data(:,artifact_samples(i,1):artifact_samples(i,2)) = NaN;
    end

    % delete selected channels (rows) from LFP_data
    LFP_data(bad_channels(:),:) = [] ; 
    num_channels = length(LFP_data(:,1));

    % iterates through channels and determines line length
	linelength = zeros(num_channels, 1);
	for ch = 1:num_channels
		initial_amplitude = LFP_data(ch,1);
		for sample = LFP_samples(2:end)
    		current_amplitude = LFP_data(ch,sample);
            if isnan(current_amplitude) == 0
			    diff = abs(current_amplitude - initial_amplitude);
			    linelength(ch) = linelength(ch) + diff;
			    initial_amplitude = current_amplitude;
            end
        end
    end

    % calculates mean number of peaks per channel
	mean_linelength = mean(linelength);
	output_array = ["mean linelength per channel", mean_linelength];
	output_file = strcat(LFP_file, '_linelength.csv');
	writematrix(output_array, output_file);

end