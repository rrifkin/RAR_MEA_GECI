function RAR_calcium_findpeaks (normalized_intensity_file, offslice_channels_file)

    % Parameters
    frame_rate = 50; 
    min_peak_height = 1.01;
    output_suffix = '_calcium_findpeaks_v1';

    % Import LFP data
    normalized_intensity = importdata (normalized_intensity_file);

	offslice_electrodes = RAR_convert_chan_to_elec(offslice_channels_file);

    % delete selected electrodes (rows) from normalized_intensity
    normalized_intensity(offslice_electrodes(:),:) = [] ;

    % Run findpeaks analysis
    num_channels = length(normalized_intensity(:,1));
    num_frames = 1:length(normalized_intensity(1,:));
    num_seconds = length(normalized_intensity(1,:)) / sample_rate; 

    % iterates through electrodes and counts peaks
	for ch = 1:num_channels

        % find local maxima
    	[max_amplitudes, max_indices] = findpeaks(normalized_intensity(ch,:),num_frames(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        max_amplitudes = abs(max_amplitudes);

        % find local minima by evaluating the inverse (negative) of the data
        [min_amplitudes, min_indices] = findpeaks(-normalized_intensity(ch,:),num_frames(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        min_amplitudes = abs(min_amplitudes);

        % concatenate data from maxima and minima
        amplitudes = [max_amplitudes, min_amplitudes];
        indices = [max_indices; min_indices]; 

        freq_peaks(ch) = length(indices) / num_seconds;
        amp_peaks(ch) = mean(amplitudes, 'omitnan');
    end

    freq_peaks_file = strcat(normalized_intensity_file(1:end-16), output_suffix,  excluded_min_string, '_Ca_freq_peaks_by_elec.csv');
    writematrix(freq_peaks', freq_peaks_file);

    amp_peaks_file = strcat(normalized_intensity_file(1:end-16), output_suffix,  excluded_min_string, '_Ca_amp_peaks_by_elec.csv');
    writematrix(amp_peaks', amp_peaks_file);

    % calculates mean number of peaks per channel
	mean_freq_peaks = mean(freq_peaks, 'omitnan');
    mean_amp_peaks = mean(amp_peaks, 'omitnan');
	output_array = ["mean number of Ca peaks per second per electrode", mean_freq_peaks; "mean amplitude of peaks", mean_amp_peaks];
    output_file = strcat(normalized_intensity_file(1:end-16), output_suffix, excluded_min_string, '_Ca_findpeaks_means.csv');
    writematrix(output_array, output_file);

end