function RAR_findpeaks (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, excluded_minutes)

    % Parameters
    sample_rate = 2000; 
    threshold_std = 4;
    output_suffix = '_findpeaks_v4_inactive_ch';

    % Import LFP data
    LFP_data = importdata (LFP_file);
    artifact_samples = readmatrix(artifact_file);
    bad_channels = readmatrix (bad_channels_file);
    offslice_channels = readmatrix (offslice_channels_file);
    inactive_channels = readmatrix (inactive_channels_file);

    excluded_samples = [((excluded_minutes(1) * 60 * sample_rate) + 1):(excluded_minutes(end) * 60 * sample_rate)];
    excluded_min_string = strcat('_exclude_min_', num2str(excluded_minutes(1)), '-', num2str(excluded_minutes(end)));

    % Delete selected time ranges (columns) from LFP_data. 
    % artifact_samples is a N x 2 array where N is the number of
    % artifact intervals. These interval ranges are concatenated 
    % into excluded_samples, which is then deleted from LFP_data.
    for i=1:length(artifact_samples(:,1))
        current_range = artifact_samples(i,1):artifact_samples(i,2);
        excluded_samples = [excluded_samples, current_range];
    end
    excluded_samples = unique (excluded_samples);
    LFP_data(:,excluded_samples) = [];

    % delete selected channels (rows) from LFP_data
    excluded_channels = [bad_channels, offslice_channels, inactive_channels];
    excluded_channels = unique(excluded_channels);
    LFP_data(excluded_channels(:),:) = [] ;

    % Run findpeaks analysis
    num_channels = length(LFP_data(:,1));
    LFP_samples = 1:length(LFP_data(1,:));
    LFP_seconds = length(LFP_data(1,:)) / sample_rate; 

    % iterates through channels and counts peaks
	for ch = 1:num_channels
        min_peak_height = mean(LFP_data(ch,:), 'omitnan') + (threshold_std * std(LFP_data(ch,:), 'omitnan'));

        % find local maxima
    	[max_amplitudes, max_indices] = findpeaks(LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        max_amplitudes = abs(max_amplitudes);

        % find local minima by evaluating the inverse (negative) of the data
        [min_amplitudes, min_indices] = findpeaks(-LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        min_amplitudes = abs(min_amplitudes);

        % concatenate data from maxima and minima
        amplitudes = [max_amplitudes, min_amplitudes];
        indices = [max_indices; min_indices]; 

        freq_peaks(ch) = length(indices) / LFP_seconds;
        amp_peaks(ch) = mean(amplitudes, 'omitnan');
    end

    freq_peaks_file = strcat(LFP_file(1:end-16), output_suffix,  excluded_min_string, '_freq_peaks_by_ch.csv');
    writematrix(freq_peaks', freq_peaks_file);

    amp_peaks_file = strcat(LFP_file(1:end-16), output_suffix,  excluded_min_string, '_amp_peaks_by_ch.csv');
    writematrix(amp_peaks', amp_peaks_file);

    % calculates mean number of peaks per channel
	mean_freq_peaks = mean(freq_peaks, 'omitnan');
    mean_amp_peaks = mean(amp_peaks, 'omitnan');
	output_array = ["mean number of peaks per second per channel", mean_freq_peaks; "mean amplitude of peaks", mean_amp_peaks];
    output_file = strcat(LFP_file(1:end-16), output_suffix, excluded_min_string, '_means.csv');
    writematrix(output_array, output_file);

end