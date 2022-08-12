% Accepts variable number of .mat files containing downsampled LFP data,
% and concatenates and plots them. The files are assumed to be in
% chronological order.

function LFP_data = RAR_plot_LFP (varargin)

    LFP_data = [];
    for i = 1:nargin
        load (varargin{i});
        LFP_data = [LFP_data, seizure_downsampled];
        size (LFP_data)
    end

end