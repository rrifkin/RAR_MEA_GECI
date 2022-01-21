function RAR_peak_counting_wilcoxon (calc, times)

    % iterates through channels and counts peaks at least 1% higher than baseline during zmg only
	for ch = 1:96
    	[pks, locs] = findpeaks(calc(ch,1:45000),times(1:45000),'MinPeakHeight',1.01,'MinPeakDistance',1);
        pks_per_ch_early(ch) = length(locs);
        pk_amps_early{ch} = pks;
    end

	% displays mean number of peaks per channel during zmg only
	mean_num_peaks_per_ch_zmg = mean(pks_per_ch_early);
	sem_num_peaks_per_ch_zmg = RAR_sem(pks_per_ch_early);
	disp("mean number of peaks per channel - zmg:")
	disp(mean_num_peaks_per_ch_zmg);
	disp("SEM number of peaks per channel - zmg:")
	disp(sem_num_peaks_per_ch_zmg);
	%%%%%%%%%%%%%%%%%%%%


	% iterates through channels and counts peaks at least 1% higher than baseline during giga1 only
    for ch = 1:96
        [pks, locs] = findpeaks(calc(ch,45001:90000),times(45001:90000),'MinPeakHeight',1.01,'MinPeakDistance',1);
        pks_per_ch_late(ch) = length(locs);
        pk_amps_late{ch} = pks;
    end




	% displays mean number of peaks per channel during giga1 only
	mean_num_peaks_per_ch_giga1 = mean(pks_per_ch_late);
	disp("mean number of peaks per channel - giga1:")
	disp(mean_num_peaks_per_ch_giga1);

	%%%%%%%%%%%%%%%%%%%%

	% iterates through channels to calculate a ratio of amplitudes after / before giga1
    for ch = 1:96
        temp_early = pk_amps_early{ch};
        temp_late = pk_amps_late{ch};
    	amplitude_ratio(ch) = mean(temp_late, 'omitnan')/mean(temp_early, 'omitnan');
    end

	mean_amplitude_ratio = mean(amplitude_ratio,'omitnan');
	disp("Mean amplitude after GiGA1 / before GiGA1:");
	disp(mean_amplitude_ratio);

end