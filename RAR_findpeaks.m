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
		ch
    	[amplitudes, indices] = findpeaks(LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        num_peaks(ch) = length(indices);
        amp_peaks(ch) = mean(amplitudes);
    end

    % calculates mean number of peaks per channel
	mean_num_peaks = mean(num_peaks);
    mean_amp_peaks = mean(amp_peaks);
	output_array = ["mean number of peaks per channel", mean_num_peaks; "mean amplitude of peaks", mean_amp_peaks];
	output_file = strcat(LFP_file, '_findpeaks.csv');
	writematrix(output_array, output_file);

end