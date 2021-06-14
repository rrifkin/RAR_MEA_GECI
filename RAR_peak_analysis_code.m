function [total_number_early_peaks, total_number_late_peaks] = RAR_peak_analysis_code (calc, times)

	total_number_early_peaks = 0;
    for ch = 1:96
        [~, locs] = findpeaks(calc(ch,1:45000),times(1:45000),'MinPeakHeight',1.1,'MinPeakDistance',1);
        total_number_early_peaks = total_number_early_peaks + length(locs); 
    end
    disp ('zmg peaks = ')
    disp (total_number_early_peaks)

	total_number_late_peaks = 0;
    for ch = 1:96
        [~, locs] = findpeaks(calc(ch,45001:90000),times(45001:90000),'MinPeakHeight',1.1,'MinPeakDistance',1);
        total_number_late_peaks = total_number_late_peaks + length(locs); 
    end
    disp ('zmg + GIGA1 peaks')
    disp (total_number_late_peaks)

end