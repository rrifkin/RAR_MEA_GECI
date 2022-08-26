% Accepts an arbitrary number of .mat files (in chronological order)
% containing filtered and downsampled LFP data, and concatenates and
% plots the data.

function RAR_plot_LFP (varargin)

    % Concatenate LFP data into a single array
	concatenated_LFP_data = [];
    for i = 1:nargin
		load(varargin{i});
		concatenated_LFP_data = [concatenated_LFP_data, seizure_downsampled];
    end

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(concatenated_LFP_data);
    LFP_samples = [1:LFP_length];

    % Determine the final output PDF filename
    current_filename = varargin{1};
    PDF_filename = current_filename(1:end-4);
    for i = 2:nargin
        [ ~ , current_filename, ~ ] = fileparts(varargin{i});
        split_products = split(current_filename, ",");
        current_suffix = char(split_products(end));
        PDF_filename = strcat(PDF_filename, "," , current_suffix);
    end
    PDF_filename = strcat(PDF_filename, '.pdf');

	RAR_plot_traces (LFP_samples, concatenated_LFP_data, 2000, 96, PDF_filename);

end