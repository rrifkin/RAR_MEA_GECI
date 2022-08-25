% Accepts an arbitrary number of .NS5 files (in chronological order), 
% downsamples them to 2 kHz to produce an LFP file; then plots the LFP data.
% Also saves a band-pass filtered MUA file.

function RAR_NSxFile_downsample_and_plot (varargin)

    % Filter and downsample files; save LFP filename
	concatenated_LFP_data = [];
    for i = 1:nargin
		[current_LFP_data, ~] = RAR_NSxFile_downsample (varargin{i});
		concatenated_LFP_data = [concatenated_LFP_data, current_LFP_data];
    end

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(concatenated_LFP_data);
    LFP_samples = [1:LFP_length];

    % Determine the final output PDF filename
    [ ~ , current_filename, ~ ] = fileparts(varargin{1});
    PDF_filename = current_filename;
    for i = 2:nargin
        [ ~ , current_filename, ~ ] = fileparts(varargin{i});
        split_products = split(current_filename, ",");
        current_suffix = char(split_products(end));
        PDF_filename = strcat(PDF_filename, "," , current_suffix);
    end
    PDF_filename = strcat(PDF_filename, '.pdf');

	RAR_plot_traces (LFP_samples, LFP_data, 2000, 96, PDF_filename);

end