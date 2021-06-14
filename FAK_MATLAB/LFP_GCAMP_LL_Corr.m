lfp_structures = load('/mnt/mfs/home/NIMASTER/fak2121/Processed MUA and LFP/Filtered_LFP.mat');
slice = {'t1s1','t1s3','t2s1','t2s3','eg1s1','eg1s3','eg2s1','eg2s3','eg5s1','eg5s3','t3s1','t3s3','t5s1','t5s3','eg3s1','eg3s3','eg4s1','eg4s3','eg6s1','eg6s3'};
peak_window = .5;

for a = 1:length(slice)
    disp([9 'Working on Slice ' num2str(a) ' of ' num2str(length(slice))])

    %load in the lfp
    lfp = lfp_structures.([slice{a} '_lfp']);
    lc = linspace(0,size(lfp,2)/2000,size(lfp,2));

    %load in the calcium data and resample it
    temp_times = load(['/mnt/mfs/home/NIMASTER/fak2121/FinalCalcData/Adjusted Calcium Times/' slice{a} '_zmg_times.mat']);
    temp_calc = load(['/mnt/mfs/home/NIMASTER/fak2121/FinalCalcData/Converted/' slice{a} '_zmg_final.mat']);
    times = temp_times.(['adj_' slice{a} '_zmg_times']);
    calc = temp_calc.(['adj_slid_trans_' slice{a} '_zmg']);
    clear temp_times temp_calc

    for ch = 1:96
        [calc_resampled(ch,:), times_resampled] = resample(calc(ch,:), times, 50);
    end
    clear calc times

    calc = calc_resampled;
    times = times_resampled;
    clear calc_resampled times_resampled

    %isolate channels of interest
    for e = 1:96
        for_percs(e) = mean(abs(lfp(e,:)));
    end
    
    [~,chans] = find(for_percs > mean(for_percs));

    for ch = 1:length(chans)
        [pks,locs] = findpeaks(calc(chans(ch),:),times,'MinPeakHeight',1.01,'MinPeakDistance',1);

        for d = 1:length(locs)
            lfp_ch = lfp(chans(ch),:);
            interval_lfp = lfp_ch(:,lc>=(locs(d) - peak_window) & lc<=(locs(d)+peak_window));
            interval_lc = lc(:,lc>=(locs(d) - peak_window) & lc<=(locs(d)+peak_window));
            di = diff([interval_lc(:) interval_lfp(:)]);
            interval_length(d,1) = sum(sqrt(sum(di.*di,2)));
        end
        
        sum_length = sum(interval_length(:));
        int_length_per_time = sum_length/(length(locs)*2*peak_window);
        
        lfp_1800 = lfp_ch(:,lc>=0 & lc<=1800);
        lc_1800 = lc(:,lc>=0 & lc<=1800);
        dx = diff([lc_1800(:) lfp_1800(:)]);
        total_length = sum(sqrt(sum(dx.*dx,2)));
        diff_length = total_length - sum_length;
        diff_length_per_time = diff_length/(1800 - length(locs)*2*peak_window);
        
        avg_results(ch,1) = int_length_per_time;
        avg_results(ch,2) = diff_length_per_time;
    end
results{a} = avg_results;
avg_results = [];
end