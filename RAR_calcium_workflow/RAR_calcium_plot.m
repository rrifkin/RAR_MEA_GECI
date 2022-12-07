% Accepts an arbitrary number of .mat files (in chronological order)
% containing normalized Ca data, and concatenates and
% plots the data.

function RAR_calcium_plot (varargin)

    % Concatenate Ca data into a single array
	concatenated_Ca_data = [];
    for i = 1:nargin
		current_Ca_data = importdata(varargin{i});
		concatenated_Ca_data = [concatenated_Ca_data, current_Ca_data];
    end

    % Determine the length of the concatenated Ca data and make an array
    % representing each sample
	Ca_length = length(concatenated_Ca_data);
    Ca_samples = [1:Ca_length];

    % Determine the final output PDF filename
    [path, current_filename, ~] = fileparts(varargin{1});
    PDF_filename = strcat(path(1:end-6), 'GECI_plot_', current_filename(1:end-36));
    for i = 2:nargin
        [ ~ , current_filename, ~ ] = fileparts(varargin{i});
        PDF_filename = strcat(PDF_filename, "," , current_filename(1:end-36));
    end
    PDF_filename = strcat(PDF_filename, '.pdf');

	RAR_calcium_plot_traces (Ca_samples, concatenated_Ca_data, 50, 96, PDF_filename);

end