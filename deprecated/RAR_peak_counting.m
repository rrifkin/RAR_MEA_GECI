function RAR_peak_counting (calc, times, first_start, first_end, second_start, second_end)

	% This function takes as input normalized calcium amplitudes ('calc') and time in seconds ('times'), 
	% counts the number of spikes above a threshold per channel, and calculates the mean and 95% CI.
	% This is performed for two different epochs within the recording (e.g. drug vs. non-drug)
	% The imaging data are recorded at 50 Hz, so there are 3000 pts per minute and 45000 per 15 minute epoch.
	% The start and end times for each epoch (e.g. 'first_start') are specified in data points (50 per second).

	% default values
	% first_start = 1;
	% first_end = 45000;
	% second_start = 45001;
	% second_end = 90000;

    % iterates through channels and counts peaks at least 1% higher than baseline during zmg only
	for ch = 1:96
		
    	[pks, locs] = findpeaks(calc(ch,first_start:first_end),times(first_start:first_end),'MinPeakHeight',1.01,'MinPeakDistance',1);
        pks_per_ch_early(ch) = length(locs);
    end

	% displays mean number of peaks per channel during zmg only
	mean_num_peaks_per_ch_zmg = mean(pks_per_ch_early);
	CI_num_peaks_per_ch_zmg = RAR_confidence_interval(pks_per_ch_early);
	disp("mean peaks per channel - zmg:");
	disp(mean_num_peaks_per_ch_zmg);
	disp("95% CI mean peaks per channel - zmg:");
	disp(CI_num_peaks_per_ch_zmg);

	% iterates through channels and counts peaks at least 1% higher than baseline during giga1 only
    for ch = 1:96
        [pks, locs] = findpeaks(calc(ch,second_start:second_end),times(second_start:second_end),'MinPeakHeight',1.01,'MinPeakDistance',1);
        pks_per_ch_late(ch) = length(locs);
        pk_amps_late{ch} = pks;
    end

	% displays mean number of peaks per channel during giga1 only
	mean_num_peaks_per_ch_giga1 = mean(pks_per_ch_late);
	CI_num_peaks_per_ch_giga1 = RAR_confidence_interval(pks_per_ch_late);
	disp("mean peaks per channel - giga1:")
	disp(mean_num_peaks_per_ch_giga1);
	disp("95% CI mean peaks per channel - giga1:")
	disp(CI_num_peaks_per_ch_giga1);

end