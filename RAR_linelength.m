function RAR_linelength (LFP_file, artifact_file, bad_channels_file, offslice_channels_file)

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = importdata(artifact_file);
	bad_channels = importdata (bad_channels_file);
    offslice_channels = importdata (offslice_channels_file);

    % Delete selected time ranges (columns) from LFP_data. 
    % artifact_samples is a N x 2 array where N is the number of
    % artifact intervals. These interval ranges are concatenated 
    % into artifact_range, which is then deleted from LFP_data.
    artifact_range = [];
    for i=1:length(artifact_samples(:,1))
        current_range = artifact_samples(i,1):artifact_samples(i,2);
        artifact_range = [artifact_range, current_range];
    end
    LFP_data(:,artifact_range) = [];

    % delete selected channels (rows) from LFP_data
    excluded_channels = [bad_channels, offslice_channels]; 
    LFP_data(excluded_channels(:),:) = [] ; 

    % Calculates linelength
    linelength = sum(abs(diff(LFP_data,[],2)'))./size(LFP_data,2);
	mean_linelength = mean(linelength);

    % Output data to .csv file
	output_array = ["mean linelength per channel per sample", mean_linelength];
	output_file = strcat(LFP_file, '_linelength_v2.csv');
	writematrix(output_array, output_file);

    % Plot actually analyzed data for sanity-checking
    clean_plot_file = strcat(LFP_file, '_linelength_v2_analyzed_data.pdf');
    LFP_samples = 1:length(LFP_data(1,:);
    num_channels = length(LFP_data(:,1));
    RAR_plot_traces (LFP_samples, LFP_data, 2000, num_channels, clean_plot_file);

end