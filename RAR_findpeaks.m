function RAR_findpeaks (LFP_file, artifact_file, bad_channels_file)

	% parameters 
	min_peak_height = 1.25

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = importdata(artifact_file)
	bad_channels = importdata (bad_channels_file)

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

    % iterates through channels and counts peaks (as defined by min_peak_height)
	for ch = 1:num_channels
		disp (ch);
    	[amplitudes, indices] = findpeaks(LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        num_peaks_per_ch(ch) = length(indices);
        mean_amp_per_ch(ch) = mean(amplitudes);
    end

	% write out the data to CSV files
	num_peaks_file = strcat(LFP_file, '_num_peaks.csv');
	writematrix(num_peaks_per_ch, num_peaks_file);

	mean_amps_file = strcat(LFP_file, '_mean_amps.csv');
	writematrix(mean_amp_per_ch, mean_amps_file);

end