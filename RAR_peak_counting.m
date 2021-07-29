function RAR_peak_counting (calc, times)

    % iterates through channels and counts peaks at least 1% higher than baseline during zmg only
	for ch = 1:96
		
    	[pks, locs] = findpeaks(calc(ch,1:45000),times(1:45000),'MinPeakHeight',1.01,'MinPeakDistance',1);
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
        [pks, locs] = findpeaks(calc(ch,45001:90000),times(45001:90000),'MinPeakHeight',1.01,'MinPeakDistance',1);
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