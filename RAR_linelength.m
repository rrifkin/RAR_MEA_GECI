function RAR_linelength (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, excluded_minutes)

    % Parameters
    sample_rate = 2000; % in Hz
    output_suffix = '_linelength_v4_inactive_ch';

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = readmatrix(artifact_file);
	bad_channels = readmatrix (bad_channels_file)
    offslice_channels = readmatrix (offslice_channels_file)
    inactive_channels = readmatrix (inactive_channels_file)

    excluded_samples = [((excluded_minutes(1) * 60 * sample_rate) + 1):(excluded_minutes(end) * 60 * sample_rate)];

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

    % delete selected channels (rows) from LFP_data
    excluded_channels = [bad_channels, offslice_channels, inactive_channels]
    excluded_channels = unique(excluded_channels)
    LFP_data(excluded_channels(:),:) = [] ;

    % Calculates linelength
    linelength = sum(abs(diff(LFP_data,[],2)'))./size(LFP_data,2);
    linelength = linelength * sample_rate; 
	mean_linelength = mean(linelength);

    % Output data to .csv file
	output_array = ["mean linelength per second per channel", mean_linelength];
	output_file = strcat(LFP_file(1:end-16), output_suffix, '.csv');
	writematrix(output_array, output_file);

    % Plot actually analyzed data for sanity-checking
    %clean_plot_file = strcat(LFP_file, output_suffix, '_analyzed_data.pdf');
    %LFP_samples = 1:length(LFP_data(1,:));
    %num_channels = length(LFP_data(:,1));
    %RAR_plot_traces (LFP_samples, LFP_data, 2000, num_channels, clean_plot_file);

end