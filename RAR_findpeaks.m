function RAR_findpeaks (LFP_file, artifact_file, bad_channels_file)

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = importdata(artifact_file)
	bad_channels = importdata (bad_channels_file)

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(LFP_data(1,:));
    LFP_samples = [1:LFP_length];
    num_channels = length(LFP_data(:,1));

    % delete selected time ranges (columns) from LFP_data
    for i=1:length(artifact_samples(:,1))
        LFP_data(:,artifact_samples(i,1):artifact_samples(i,2)) = NaN;
    end

    % delete selected channels (rows) from LFP_data
    LFP_data(bad_channels(:),:) = [] ; 
    num_channels = length(LFP_data(:,1));

    % iterates through channels and counts peaks at least 10% higher than baseline
	for ch = 1:num_channels
    	[amplitudes, indices] = findpeaks(LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',1.1,'MinPeakDistance',1);
        num_peaks_per_ch(ch) = length(indices)
        mean_amp_per_ch(ch) = mean(amplitudes)
		ch
    end

	% write out the data to CSV files
	num_peaks_file = strcat(LFP_file, '_num_peaks.csv');
	writematrix(num_peaks_per_ch, num_peaks_file);

	mean_amps_file = strcat(LFP_file, '_mean_amps.csv');
	writematrix(mean_amp_per_ch, mean_amps_file);

	% displays mean number of peaks per channel
	mean_num_peaks_per_ch = mean(num_peaks_per_ch);
	sem_num_peaks_per_ch = RAR_sem(num_peaks_per_ch);
	disp("mean number of peaks per channel:")
	disp(mean_num_peaks_per_ch)
	disp("SEM number of peaks per channel:")
	disp(sem_num_peaks_per_ch)

	% displays mean amplitude of peaks per channel
	mean_amp_all_ch = mean(mean_amp_per_ch);
	sem_amp_all_ch = RAR_sem(mean_amp_per_ch);
	disp("mean amplitude of peaks per channel:")
	disp(mean_amp_all_ch)
	disp("SEM amplitude of peaks per channel:")
	disp(sem_amp_all_ch)

end