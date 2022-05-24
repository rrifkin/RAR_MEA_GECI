function RAR_caproc_parloop (radius, eleclocs_file, number_of_tifs, tif_filename_prefix, tif_filename_suffix, last_tif_frames, output_filename)

	load(eleclocs_file,'-mat','Eleclocs');

	pi_int = cell(1, number_of_tifs);
	nFrames = 2040 * ones(1, number_of_tifs);
	nFrames(number_of_tifs) = last_tif_frames;

	% Run chan_intensity on the first file (which does not have a number)
	filename = strcat(tif_filename_prefix, tif_filename_suffix);
	disp (strcat('Working on file ', {' '}, filename));
	pi_int{1} = chan_intensity(filename,radius,2040,Eleclocs);

	% Run chan_intensity on the remaining files (which have a number)
	parfor i = 1:(number_of_tifs - 1)
		filename = strcat(tif_filename_prefix, '_', num2str(i), tif_filename_suffix);
		disp (strcat('Working on file ', {' '}, filename));
		pi_int{i+1} = chan_intensity(filename,radius,nFrames(i+1),Eleclocs);
	end
	output = cell2mat(pi_int); % this may need to be transposed, (i.e. cell2mat(pi_int');) need to test with the actual data first

	% save workspace to a file
	disp (strcat('Saving result to', {' '}, output_filename));
	save (output_filename);

end