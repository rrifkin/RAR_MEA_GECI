% Determines which channels are "inactive" in the sense that findpeaks
% detects no peaks according to same criteria used by RAR_findpeaks.
% The output from all epochs of the experiment should be reconciled;
% if a channel exists in only one file it should be deleted from all,
% because it was active at some point in the experiment.

function RAR_inactive_ch (LFP_file, artifact_file)

    % Parameters
    sample_rate = 2000; 
    threshold_std = 4;
    output_suffix = '_inactive_channels.csv';

    % Import LFP data
    LFP_data = importdata (LFP_file);
    artifact_samples = readmatrix(artifact_file);

    excluded_samples = [];

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

    % Run findpeaks analysis
    num_channels = length(LFP_data(:,1));
    LFP_samples = 1:length(LFP_data(1,:));
    LFP_seconds = length(LFP_data(1,:)) / sample_rate; 

	inactive_channels = [];

    % iterates through channels and counts peaks
	for ch = 1:num_channels
        min_peak_height = mean(LFP_data(ch,:), 'omitnan') + (threshold_std * std(LFP_data(ch,:), 'omitnan'));

        % find local maxima
    	[max_amplitudes, max_indices] = findpeaks(LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        max_amplitudes = abs(max_amplitudes);

        % find local minima by evaluating the inverse (negative) of the data
        [min_amplitudes, min_indices] = findpeaks(-LFP_data(ch,:),LFP_samples(:),'MinPeakHeight',min_peak_height,'MinPeakDistance',1);
        min_amplitudes = abs(min_amplitudes);

        % concatenate data from maxima and minima
        amplitudes = [max_amplitudes, min_amplitudes];
        indices = [max_indices; min_indices]; 

		if isempty(indices)
			inactive_channels = [inactive_channels, ch];
    end

    % outputs inactive channels
    output_file = strcat(LFP_file(1:end-16), output_suffix);
    writematrix(inactive_channels, output_file);

end