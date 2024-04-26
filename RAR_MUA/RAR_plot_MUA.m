% Accepts an arbitrary number of .mat files (in chronological order)
% containing filtered and downsampled LFP data, and concatenates and
% plots the data.

function RAR_plot_MUA (varargin)

    % Concatenate MUA data into a single array
	concatenated_MUA_data = [];
    for i = 1:nargin
		current_MUA_data = importdata(varargin{i});
		concatenated_MUA_data = [concatenated_MUA_data, current_MUA_data];
    end

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	MUA_length = length(concatenated_MUA_data);
    MUA_samples = [1:MUA_length];

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

	RAR_plot_traces (MUA_samples, concatenated_MUA_data, 10000, 96, PDF_filename);

end