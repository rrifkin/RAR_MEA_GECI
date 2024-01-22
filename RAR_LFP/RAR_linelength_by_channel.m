% Determines channels with specific LFP linelength for making excerpts

function RAR_linelength_by_channel (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, excluded_minutes)

    % Parameters
    sample_rate = 2000; % in Hz
    output_suffix = '_linelength_v4_inactive_ch';

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = readmatrix(artifact_file);
	bad_channels = readmatrix (bad_channels_file);
    offslice_channels = readmatrix (offslice_channels_file);
    inactive_channels = readmatrix (inactive_channels_file);

    excluded_samples = [((excluded_minutes(1) * 60 * sample_rate) + 1):(excluded_minutes(end) * 60 * sample_rate)];
    excluded_min_string = strcat('_exclude_min_', num2str(excluded_minutes(1)), '-', num2str(excluded_minutes(end)));

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

	% makes an array of channel numbers to parallel LFP_data
	channel_numbers = reshape(1:96,[96,1]);

    % delete selected channels (rows) from LFP_data
    excluded_channels = [bad_channels, offslice_channels, inactive_channels];
    excluded_channels = unique(excluded_channels);
    LFP_data(excluded_channels(:),:) = [] ;
	channel_numbers(excluded_channels(:),:) = [];

    % Calculates linelength
    linelength = sum(abs(diff(LFP_data,[],2)'))./size(LFP_data,2);
    linelength = linelength * sample_rate;
    linelength = linelength';

	linelength_per_channel = [channel_numbers,linelength];

    % Output data by channel to .csv file
    output_file = strcat(LFP_file(1:end-16), output_suffix, excluded_min_string, '_linelength_per_channel_with_channel_number.csv');
	writematrix(linelength_per_channel, output_file);

   
end