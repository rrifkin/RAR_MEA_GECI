% Main script for processing a multielectrode recording experiment.
% Accepts an arbitrary number of .NS5 files (in chronological order) and
% filters / downsamples them into LFP and MUA files; then plots the LFP data.

function RAR_ephys_workflow (varargin)

    % Filter and downsample the baseline file; save LFP filename
    [ ~ , current_filename, ~ ] = fileparts(varargin{1});
    DownSamplingAndDetectMUA('seizure_recording', varargin{1}, 'baseline_recording', varargin{1},'T', [0 600],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', current_filename);
    current_filename = strcat('LFPDownSampled', current_filename, '.mat');
    LFP_filenames = {current_filename};

    % Filter and downsample remaining files; save LFP filename
    for i = 2:nargin
        [ ~ , current_filename, ~ ] = fileparts(varargin{i});
        DownSamplingAndDetectMUA('seizure_recording', varargin{i}, 'baseline_recording', varargin{1},'T', [0],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', current_filename);
        current_filename = strcat('LFPDownSampled', current_filename, '.mat');
        LFP_filenames = [LFP_filenames, current_filename];
    end

    % Load and concatenate LFP data in chronological order based on
    % filenames saved above
    LFP_data = RAR_plot_LFP (LFP_filenames{:});

    % Determine the length of the concatenated LFP data and make an array
    % representing each sample
	LFP_length = length(LFP_data);
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