% Performs parallel processing of calcium intensity within defined ROIs

function output_filename = RAR_caproc_parloop (eleclocs_file, list_of_tifs)

	tif_filename_suffix = '.ome.tif';

	number_of_tifs =  length (list_of_tifs) ; % count number of tifs in the directory
	current_path = list_of_tifs(1).folder;
	tif_filename_prefix = erase(list_of_tifs(1).name, tif_filename_suffix); % extract filename prefix from first element of list of tifs
	output_filename = strcat(current_path, '/', tif_filename_prefix, '_channel_intensities.csv');
	radius_filename = strcat(current_path, '/', tif_filename_prefix, '_radius.csv');

	% eleclocs_file should be a csv file with x coordinates in first column, y 
	% coordinates in 2nd column. Rows are electrodes 1-96 in increasing order.
	eleclocs = readmatrix(eleclocs_file);

	% find radius in pixels
	radius = find_radius (eleclocs)

	% creates a cell array with 1 row and as many columns as number_of_tifs
	channel_intensities = cell(1, number_of_tifs);

	% Run chan_intensity on the first file (which does not have a number)
	filename = strcat(current_path, '/', tif_filename_prefix, tif_filename_suffix)
	info = imfinfo(filename);
	num_frames = length(info);
	channel_intensities{1} = chan_intensity(filename, radius, num_frames, eleclocs);

	% Run chan_intensity on the remaining files (which have a number)
	parfor i = 1:(number_of_tifs - 1)
		filename = strcat(current_path, '/', tif_filename_prefix, '_', num2str(i), tif_filename_suffix);
		info = imfinfo(filename);
		num_frames = length(info);
		channel_intensities{i+1} = chan_intensity(filename, radius, num_frames, eleclocs);
	end

	% save channel intensities to a csv file
	writecell (channel_intensities, output_filename);

	% save radius to csv file
	writematrix (radius, radius_filename);

end


% Calculates the scale of the image (pixels per micron), then returns the
% desired ROI radius (e.g. 140 µm) in pixels.

function radius_in_pixels = find_radius (eleclocs)

	microns_between_electrodes = 400;
	radius_in_microns = 140; % Per Gill 2022

	indices = find(eleclocs(:,1) > -1, 2, 'first'); % Finds first two electrodes that aren't -1 
	index_difference = indices(2) - indices(1); % Finds how many rows apart they are
	pixel_difference = eleclocs(indices(2)) - eleclocs(indices(1)); % Finds how many pixels apart they are
	pixels_between_electrodes = pixel_difference / index_difference; % i.e. scale

	pixels_per_micron = pixels_between_electrodes / microns_between_electrodes;
	radius_in_pixels = radius_in_microns * pixels_per_micron;

end