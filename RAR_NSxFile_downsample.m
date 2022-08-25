% Accepts an arbitrary number of .NS5 files (in chronological order), 
% downsamples them to 2 kHz to produce an LFP file; then plots the LFP data.
% Also saves a band-pass filtered MUA file.

function [LFP_data, MUA_data] = RAR_NSxFile_downsample (filename)

	nsx = NSxFile('filename', filename);
	nsx.read();

	raw_data = double(cell2mat(nsx.data));
	num_channels = length(raw_data(:,1));

	% Construct window-based, 512th order, 2-50Hz bandpass FIR filter
	[b_lp50, a_lp50] = fir1(512,[2,50]/(30000/2));

	% Construct window-based, 512th order, 500-5kHz bandpass FIR filter
	[b_lp5k, a_lp5k] = fir1(512,[500,5000]/(30000/2));

	% Obtain 2-50Hz bandpass filter data
	disp ('Filtering the LFP data');
	for i = 1:num_channels
		i
		LFP_data(i,:) = filtfilt(b_lp50, a_lp50, raw_data(i,:));
	end

	% Obtain 500-5kHz bandpass filter data
	disp ('Filtering the MUA data');
	for i = 1:num_channels
		i
		MUA_data(i,:) = filtfilt(b_lp5k, a_lp5k, raw_data(i,:));
	end

	LFP_filename = strcat(filename(1:end-4), '_LFP.mat');
	save(LFP_filename, LFP_data);

	MUA_filename = strcat(filename(1:end-4), '_MUA.mat');
	save(MUA_filename, MUA_data);

end