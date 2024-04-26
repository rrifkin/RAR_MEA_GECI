function RAR_linelength_peritumoral_by_ch (LFP_file, artifact_file, bad_channels_file, offslice_channels_file, inactive_channels_file, peritumoral_file, excluded_minutes)

    % Parameters
    sample_rate = 2000; % in Hz
    output_suffix = '_linelength_peritumoral_excluding_min_by_ch';

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = readmatrix(artifact_file);
	bad_channels = readmatrix (bad_channels_file);
    offslice_channels = readmatrix (offslice_channels_file);
    inactive_channels = readmatrix (inactive_channels_file);
	peritumoral_channels = readmatrix (peritumoral_file);

	nonperitumoral_channels = [1:96];
	nonperitumoral_channels(peritumoral_channels) = [];

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

    % Define peritumoral data
    peritumoral_data = LFP_data;
    peri_excluded_channels = [bad_channels, offslice_channels, inactive_channels, nonperitumoral_channels];
    peri_excluded_channels = unique(peri_excluded_channels);
    peritumoral_data(peri_excluded_channels(:),:) = [] ;

    % Define non-peritumoral data
    nonperitumoral_data = LFP_data;
    nonperi_excluded_channels = [bad_channels, offslice_channels, inactive_channels, peritumoral_channels];
    nonperi_excluded_channels = unique(nonperi_excluded_channels);
    nonperitumoral_data(nonperi_excluded_channels(:),:) = [] ;

    % Calculates linelength
    peri_linelength = sum(abs(diff(peritumoral_data,[],2)'))./size(peritumoral_data,2);
    peri_linelength = peri_linelength * sample_rate;

	non_linelength = sum(abs(diff(nonperitumoral_data,[],2)'))./size(nonperitumoral_data,2);
    non_linelength = non_linelength * sample_rate;

    % Output data to .csv file
	peri_output_file = strcat(LFP_file(1:end-16), output_suffix, excluded_min_string, 'peritumoral.csv');
	writematrix(peri_linelength', peri_output_file);

	non_output_file = strcat(LFP_file(1:end-16), output_suffix, excluded_min_string, 'nonperitumoral.csv');
	writematrix(non_linelength', non_output_file);


end