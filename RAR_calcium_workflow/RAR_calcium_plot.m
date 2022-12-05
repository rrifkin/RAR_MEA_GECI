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
    current_filename = varargin{1};
    PDF_filename = current_filename(1:end-4);
    for i = 2:nargin
        [ ~ , current_filename, ~ ] = fileparts(varargin{i});
        current_suffix = erase(current_filename, '_1_MMStack_Pos0_normalized_intensity.mat');
        PDF_filename = strcat(PDF_filename, "," , current_suffix);
    end
    PDF_filename = strcat(PDF_filename, '_GECI.pdf');

	RAR_calcium_plot_traces (Ca_samples, concatenated_Ca_data, 50, 96, PDF_filename);

end