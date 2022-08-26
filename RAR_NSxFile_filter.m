% Accepts an arbitrary number of .NS5 files (in chronological order), 
% and bandpass filters them into LFP and MUA bands. The LFP data is
% downsampled to 2 kHz. Then the data are saved to .mat files.

function [LFP_data, MUA_data] = RAR_NSxFile_filter (input_file)

	% Parameters
	channels = [1:96];
	output_sample_rate = 2000; 
	LFP_band = [2,50];
	MUA_band = [500,5000];

	% Create an NSxFile object and read the data from the input file
	nsx = NSxFile('filename', input_file);
	nsx.useRam = false; % to prevent out of memory crashes
	nsx.read('channel', channels);

	raw_data = double(cell2mat(nsx.data));

	% Filter and downsample LFP data 
	[b_LFP, a_LFP] = fir1(1024, LFP_band / (nsx.Fs / 2));
	downsample_factor = nsx.Fs / output_sample_rate;
	filtered_LFP_data = nan(length(channels), length(raw_data(1,:)));
	seizure_downsampled = nan(length(channels), length(raw_data(1,:)) / downsample_factor);
	disp ('Filtering and downsampling the LFP data, channel...');
	for i = channels
		disp (i);
		filtered_LFP_data(i,:) = filtfilt(b_LFP, a_LFP, raw_data(i,:));
		seizure_downsampled(i,:) = downsample(filtered_LFP_data(i,:),downsample_factor); 
	end
	LFP_filename = strcat(input_file(1:end-4), '_NSxFile_LFP.mat');
	save(LFP_filename, seizure_downsampled);

	% Filter MUA data
	[b_MUA, a_MUA] = fir1(1024, MUA_band / (nsx.Fs / 2));
	filtered_MUA_data = nan(length(channels), length(raw_data(1,:)));
	disp ('Filtering the MUA data, channel...');
	for i = channels
		disp(i);
		filtered_MUA_data(i,:) = filtfilt(b_MUA, a_MUA, raw_data(i,:));
	end
	MUA_filename = strcat(input_file(1:end-4), '_NSxFile_MUA.mat');
	save(MUA_filename, filtered_MUA_data);

end