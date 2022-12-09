function RAR_calcium_findpeaks (normalized_intensity_file, included_minutes, eleclocs_file)

    % Parameters
    frame_rate = 50; 
    min_peak_height = 1.01;
    output_suffix = '_calcium_findpeaks_v1';

    % Import LFP data
    normalized_intensity = importdata (normalized_intensity_file);

    eleclocs = readmatrix(eleclocs_file);
	excluded_electrodes = find(eleclocs(:,1) == -1) % Finds electrodes marked as offslice

    start_frame = included_minutes(1) * 60 * frame_rate;
    end_frame = included_minutes(end) * 60 * frame_rate;

    if end_frame > length(normalized_intensity)
        end_frame = length(normalized_intensity);
        included_minutes(end) = (end_frame / frame_rate) / 60 ;
    end

    included_min_string = strcat('_include_min_', num2str(included_minutes(1),4), '-', num2str(included_minutes(end),4));       

    % delete selected electrodes (rows) from normalized_intensity
    normalized_intensity(excluded_electrodes(:),:) = [] ;

    % delete excluded frames (columns) from normalized_intensity
    normalized_intensity = normalized_intensity(:,start_frame:end_frame);

    % Run findpeaks analysis
    num_elecs = length(normalized_intensity(:,1));
    num_frames = 1:length(normalized_intensity(1,:));
    num_seconds = length(normalized_intensity(1,:)) / sample_rate; 

    % iterates through electrodes and counts peaks
	for ch = 1:num_elecs

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

    freq_peaks_file = strcat(normalized_intensity_file(1:end-24), output_suffix,  excluded_min_string, '_Ca_freq_peaks_by_elec.csv');
    writematrix(freq_peaks', freq_peaks_file);

    amp_peaks_file = strcat(normalized_intensity_file(1:end-24), output_suffix,  excluded_min_string, '_Ca_amp_peaks_by_elec.csv');
    writematrix(amp_peaks', amp_peaks_file);

end