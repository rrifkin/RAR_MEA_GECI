% Accepts an .NS5 file and bandpass filters it to the MUA band, then saves
% as a .mat file.

function [filtered_MUA_data] = RAR_NSxFile_filter_MUA (input_file)

	% Parameters
	channels = 1:96;
	output_sample_rate = 10000; 
	MUA_band = [500,5000];

	% Create an NSxFile object and read the data from the input file
	nsx = NSxFile('filename', input_file);
	nsx.verbose = true;
	nsx.read('channel', channels);
	raw_data = double(cell2mat(nsx.data));

	% Filter MUA data 
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
	MUA_filename = strcat(input_file(1:end-4), '_NSxFile_MUA.mat');
	save(MUA_filename, 'downsampled_MUA_data', '-v7.3');

	RAR_plot_MUA(MUA_filename);

end