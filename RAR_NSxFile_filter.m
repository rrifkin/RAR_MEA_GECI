% Accepts an .NS5 file and bandpass filters it into LFP and MUA bands. 
% The LFP data is downsampled to 2 kHz. Then the data are saved to .mat files.

function [downsampled_LFP_data, MUA_data] = RAR_NSxFile_filter (input_file)

	% Parameters
	channels = 1:96;
	output_sample_rate = 2000; 
	LFP_band = [2,50];
	MUA_band = [500,5000];

	% Create an NSxFile object and read the data from the input file
	nsx = NSxFile('filename', input_file);
	nsx.verbose = true;
	nsx.read('channel', channels);
	raw_data = double(cell2mat(nsx.data));

	% % Filter and downsample LFP data 
	% [b_LFP, a_LFP] = fir1(1024, LFP_band / (nsx.Fs / 2));
	% downsample_factor = nsx.Fs / output_sample_rate;
	% filtered_LFP_data = nan(length(channels), length(raw_data(1,:)));
	% downsampled_LFP_data = nan(length(channels), ceil(length(raw_data(1,:)) / downsample_factor));

	% disp ('Filtering and downsampling the LFP data, channel...');
	% for i = channels
	% 	disp (i);
	% 	filtered_LFP_data(i,:) = filtfilt(b_LFP, a_LFP, raw_data(i,:));
	% 	downsampled_LFP_data(i,:) = downsample(filtered_LFP_data(i,:),downsample_factor); 
	% end
	% LFP_filename = strcat(input_file(1:end-4), '_NSxFile_LFP.mat');
	% save(LFP_filename, 'downsampled_LFP_data', '-v7.3');

	% Filter and detect spikes in MUA data

	for c = 1:96 % or whatever channel numbers you're processing
		try
			nsx.detectSpikes('filterType', 'FIR', 'filterOrder', 1024, 'bandpass', MUA_band, 'channels', c);
		catch err
			disp(['Error on chan ' num2str(c) ': ' err.message])
			[b_MUA, a_MUA] = fir1(1024, MUA_band / (nsx.Fs / 2));
			filtered_data = filtfilt(b_MUA, a_MUA, raw_data(c,:));
			error_filename = strcat(input_file(1:end-4), '_NSxFile_MUA_error_data.mat');
			save(error_filename, 'filtered_data');
		end
	end

	% and now export them to a UMS2k style structure
	MUA_data = nsx.exportSpikesUMS();
	nsx.close();

	% Save the MUA data
	MUA_filename = strcat(input_file(1:end-4), '_NSxFile_MUA_spikes.mat');
	save(MUA_filename, 'MUA_data');

end