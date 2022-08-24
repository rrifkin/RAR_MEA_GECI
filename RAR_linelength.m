function RAR_linelength (LFP_file, artifact_file, bad_channels_file)

    % Parameters
    sample_rate = 2000; 

    % If no command line arguments, get files via GUI
    if exist ('LFP_file','var') == 0
        [input_file, input_path] = uigetfile('*.mat', 'Select the LFP file');
        LFP_file = [input_path, input_file];

        [input_file, input_path] = uigetfile('*.csv', 'Select the artifact file');
        artifact_file = [input_path, input_file];

        [input_file, input_path] = uigetfile('*.csv', 'Select the bad channels file');
        bad_channels_file = [input_path, input_file];
	end

    % Import LFP data
    LFP_data = importdata (LFP_file);
	artifact_samples = importdata(artifact_file);
	bad_channels = importdata (bad_channels_file);

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(LFP_data(1,:));
    LFP_samples = [1:LFP_length];
    num_channels = length(LFP_data(:,1));

    % Delete selected time ranges (columns) from LFP_data
    % Also records total length of artifact (in samples) for normalization
    total_artifact_length = 0;
    for i=1:length(artifact_samples(:,1))
        LFP_data(:,artifact_samples(i,1):artifact_samples(i,2)) = NaN;
        current_artifact_length = artifact_samples(i,2) - artifact_samples(i,1);
        total_artifact_length = total_artifact_length + current_artifact_length; 
    end

    % delete selected channels (rows) from LFP_data
    LFP_data(bad_channels(:),:) = [] ; 
    num_channels = length(LFP_data(:,1));

    % iterates through channels and determines line length
	linelength = zeros(num_channels, 1);
	for ch = 1:num_channels
		initial_amplitude = LFP_data(ch,1);
		for sample = LFP_samples(2:end)
    		current_amplitude = LFP_data(ch,sample);
            if isnan(current_amplitude) == 0
			    diff = abs(current_amplitude - initial_amplitude);
			    linelength(ch) = linelength(ch) + diff;
			    initial_amplitude = current_amplitude;
            end
        end
    end

    % Corrects LFP length for deleted artifact and converts to seconds
    corrected_LFP_length = LFP_length - total_artifact_length;
    corrected_LFP_length = corrected_LFP_length / sample_rate; 

    % Calculates mean number of peaks per channel
	mean_linelength = mean(linelength);

    % Normalizes for length of non-artifact recording in seconds
    mean_linelength = mean_linelength / corrected_LFP_length; 

	output_array = ["mean linelength per channel per non-artifact second", mean_linelength];
	output_file = strcat(LFP_file, '_linelength.csv');
	writematrix(output_array, output_file);

end