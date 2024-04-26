function RAR_findpeaks_peritumoral_by_ch (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, peritumoral_file, excluded_minutes)

    % Parameters
    sample_rate = 2000; 
    threshold_std = 4;
    output_suffix = '_findpeaks_peritumoral_by_ch';

	% Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = readmatrix(artifact_file);
	bad_channels = readmatrix (bad_channels_file);
    offslice_channels = readmatrix (offslice_channels_file);
    inactive_channels = readmatrix (inactive_channels_file);
	peritumoral_channels = readmatrix (peritumoral_file);

	nonperitumoral_channels = [1:96];
	nonperitumoral_channels(peritumoral_channels) = [];

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

    % Define peritumoral data
    peritumoral_data = LFP_data;
    peri_excluded_channels = [bad_channels, offslice_channels, inactive_channels, nonperitumoral_channels];
    peri_excluded_channels = unique(peri_excluded_channels);
    peritumoral_data(peri_excluded_channels(:),:) = [] ;

    % Define non-peritumoral data
    nonperitumoral_data = LFP_data;
    nonperi_excluded_channels = [bad_channels, offslice_channels, inactive_channels, peritumoral_channels];
    nonperi_excluded_channels = unique(nonperi_excluded_channels);
    nonperitumoral_data(nonperi_excluded_channels(:),:) = [] ;

    % Run findpeaks analysis for peritumoral data
    peri_num_channels = length(peritumoral_data(:,1));
    LFP_samples = 1:length(peritumoral_data(1,:));
    LFP_seconds = length(peritumoral_data(1,:)) / sample_rate; 

    % iterates through channels and counts peaks
	for ch = 1:peri_num_channels
        peri_min_peak_height = mean(peritumoral_data(ch,:), 'omitnan') + (threshold_std * std(peritumoral_data(ch,:), 'omitnan'));

        % find local maxima
    	[max_amplitudes, max_indices] = findpeaks(peritumoral_data(ch,:),LFP_samples(:),'MinPeakHeight',peri_min_peak_height,'MinPeakDistance',1);
        max_amplitudes = abs(max_amplitudes);

        % find local minima by evaluating the inverse (negative) of the data
        [min_amplitudes, min_indices] = findpeaks(-peritumoral_data(ch,:),LFP_samples(:),'MinPeakHeight',peri_min_peak_height,'MinPeakDistance',1);
        min_amplitudes = abs(min_amplitudes);

        % concatenate data from maxima and minima
        amplitudes = [max_amplitudes, min_amplitudes];
        indices = [max_indices; min_indices]; 

        peri_freq_peaks(ch) = length(indices) / LFP_seconds;
        peri_amp_peaks(ch) = mean(amplitudes, 'omitnan');
    end

    % Run findpeaks analysis for nonperitumoral data
    non_num_channels = length(nonperitumoral_data(:,1));
    LFP_samples = 1:length(nonperitumoral_data(1,:));
    LFP_seconds = length(nonperitumoral_data(1,:)) / sample_rate; 

    % iterates through channels and counts peaks
	for ch = 1:non_num_channels
        non_min_peak_height = mean(nonperitumoral_data(ch,:), 'omitnan') + (threshold_std * std(nonperitumoral_data(ch,:), 'omitnan'));

        % find local maxima
    	[max_amplitudes, max_indices] = findpeaks(nonperitumoral_data(ch,:),LFP_samples(:),'MinPeakHeight',non_min_peak_height,'MinPeakDistance',1);
        max_amplitudes = abs(max_amplitudes);

        % find local minima by evaluating the inverse (negative) of the data
        [min_amplitudes, min_indices] = findpeaks(-nonperitumoral_data(ch,:),LFP_samples(:),'MinPeakHeight',non_min_peak_height,'MinPeakDistance',1);
        min_amplitudes = abs(min_amplitudes);

        % concatenate data from maxima and minima
        amplitudes = [max_amplitudes, min_amplitudes];
        indices = [max_indices; min_indices]; 

        non_freq_peaks(ch) = length(indices) / LFP_seconds;
        non_amp_peaks(ch) = mean(amplitudes, 'omitnan');
    end

    peri_freq_peaks_file = strcat(LFP_file(1:end-16), output_suffix,  excluded_min_string, '_freq_peaks_by_ch_peritumoral.csv');
    writematrix(peri_freq_peaks', peri_freq_peaks_file);
	non_freq_peaks_file = strcat(LFP_file(1:end-16), output_suffix,  excluded_min_string, '_freq_peaks_by_ch_nonperitumoral.csv');
    writematrix(non_freq_peaks', non_freq_peaks_file);

    peri_amp_peaks_file = strcat(LFP_file(1:end-16), output_suffix,  excluded_min_string, '_amp_peaks_by_ch_peritumoral.csv');
    writematrix(peri_amp_peaks', peri_amp_peaks_file);
	non_amp_peaks_file = strcat(LFP_file(1:end-16), output_suffix,  excluded_min_string, '_amp_peaks_by_ch_nonperitumoral.csv');
    writematrix(non_amp_peaks', non_amp_peaks_file);

end