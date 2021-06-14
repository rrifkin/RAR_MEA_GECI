function [early, late] = FAK_analysis_code (calc, times)

    for ch = 1:96
        [pks, locs] = findpeaks(calc(ch,1:45000),times(1:45000),'MinPeakHeight',1.01,'MinPeakDistance',1);
        pks_per_ch_early(ch) = length(locs);
        pk_amps_early{ch} = pks;
    end

    early = cell2mat(pk_amps_early);

    for ch = 1:96
        [pks, locs] = findpeaks(calc(ch,45001:90000),times(45001:90000),'MinPeakHeight',1.01,'MinPeakDistance',1);
        pks_per_ch_late(ch) = length(locs);
        pk_amps_late{ch} = pks;
    end

    late = cell2mat(pk_amps_late);

    for ch = 1:96
        temp_early = pk_amps_early{ch};
        temp_late = pk_amps_late{ch};
        div_factor(ch) = max(temp_early)/max(temp_late);
    end

end