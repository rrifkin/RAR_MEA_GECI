function RAR_findpeaks (LFP_file, artifact_file, bad_channels_file, offslice_channels_file)

    % Import LFP data
    LFP_data = importdata (LFP_file);
    artifact_samples = readmatrix(artifact_file);
    bad_channels = readmatrix (bad_channels_file)
    offslice_channels = readmatrix (offslice_channels_file)

    % Delete selected time ranges (columns) from LFP_data. 
    % artifact_samples is a N x 2 array where N is the number of
    % artifact intervals. These interval ranges are concatenated 
    % into artifact_range, which is then deleted from LFP_data.
    artifact_range = [];
    for i=1:length(artifact_samples(:,1))
        current_range = artifact_samples(i,1):artifact_samples(i,2);
        artifact_range = [artifact_range, current_range];
    end
    LFP_data(:,artifact_range) = [];

    % delete selected channels (rows) from LFP_data
    excluded_channels = [bad_channels, offslice_channels];
    excluded_channels = unique(excluded_channels);
    excluded_channels(:)
    LFP_data(excluded_channels(:),:) = [] ;

    % Run findpeaks analysis
    num_channels = length(LFP_data(:,1));
    LFP_samples = 1:length(LFP_data(1,:));

    % iterates through channels and counts peaks
	for ch = 1:num_channels
		ch
        min_peak_height = mean(LFP_data(ch,:), 'omitnan') + (3 * std(LFP_data(ch,:), 'omitnan'));
    	[amplitudes, indices] = findpeaks(LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        num_peaks(ch) = length(indices);
        amp_peaks(ch) = mean(amplitudes, 'omitnan');
    end


    % calculates mean number of peaks per channel
	mean_num_peaks = mean(num_peaks, 'omitnan');
    mean_amp_peaks = mean(amp_peaks, 'omitnan');
	output_array = ["mean number of peaks per channel", mean_num_peaks; "mean amplitude of peaks", mean_amp_peaks];
    output_file = strcat(LFP_file(1:end-16), '_findpeaks.csv');
    writematrix(output_array, output_file);

end