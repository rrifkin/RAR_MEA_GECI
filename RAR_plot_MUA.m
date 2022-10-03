% Accepts an .NS5 file and bandpass filters it into LFP and MUA bands. 
% The LFP data is downsampled to 2 kHz and then saved to a .mat file.
% The MUA data is spike-detected and aligned, and then spikes are saved 
% in UMS2K format. 

function RAR_plot_MUA (varargin)

	% Parameters
	channels = 1:96;
	output_sample_rate = 10000; 
	MUA_band = [500,5000];

	concatenated_MUA_data = [];
    for i = 1:nargin

		% Create an NSxFile object and read the data from the input file
		nsx = NSxFile('filename', varargin{i});
		nsx.verbose = true;
		nsx.read('channel', channels);
		raw_data = double(cell2mat(nsx.data));

		% Filter and downsample MUA data 
		[b_MUA, a_MUA] = fir1(1024, MUA_band / (nsx.Fs / 2));
		downsample_factor = nsx.Fs / output_sample_rate;
		filtered_MUA_data = nan(length(channels), length(raw_data(1,:)));
		downsampled_MUA_data = nan(length(channels), ceil(length(raw_data(1,:)) / downsample_factor));

		disp ('Filtering and downsampling the MUA data, channel...');
		for i = channels
			disp (i);
			filtered_MUA_data(i,:) = filtfilt(b_MUA, a_MUA, raw_data(i,:));
			downsampled_MUA_data(i,:) = downsample(filtered_MUA_data(i,:),downsample_factor); 
		end
		concatenated_MUA_data = [concatenated_MUA_data, downsampled_MUA_data];
	end

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

	MUA_samples = 1:length(concatenated_MUA_data(1,:))

	RAR_plot_traces(MUA_samples, concatenated_MUA_data, output_sample_rate, length(channels), PDF_filename)

end