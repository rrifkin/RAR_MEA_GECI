% Accepts an indeterminate number of 

function normalized_filenames = RAR_normalization (varargin)

	% Concatenate intensity data into a single array
	concatenated_intensity_data = [];
	for i = 1:nargin
		current_intensity_data = importdata(varargin{i});
		concatenated_intensity_data = [concatenated_intensity_data, current_intensity_data];
	end

	% Normalize data using sliding window
	mmx = movmean(concatenated_intensity_data, [125 125], 2); %using a sliding window 125 frames before/after to create normalization matrix
	mmxRecord = rdivide (concatenated_intensity_data, mmx); %normalizing row by row

	% Divide data back into discrete files and output
	normalized_filenames = {};
	first_frame = 1;
	for i = 1:nargin
		disp(i)
		filename = varargin{i};
		current_intensity_data = readmatrix(filename);
		num_frames = length(current_intensity_data);
		last_frame = first_frame + num_frames;
		normalized_intensity = mmxRecord(:,first_frame:last_frame);
		first_frame = last_frame + 1;

		metadata_file = strcat(filename(1:end-24), '_metadata.txt');
		[~,times] = cal_times(metadata_file); 
		times_sec = times/1000;  %convert to seconds

		normalized_intensity_file = strcat(filename(1:end-24), '_normalized_intensity.mat');
		normalized_filenames{i} = normalized_intensity_file; 
		save (normalized_intensity_file, 'normalized_intensity', '-v7.3');

		times_file = strcat(filename(1:end-24), '_normalized_times.mat');
		save (times_file, 'times_sec', '-v7.3');

	end

end