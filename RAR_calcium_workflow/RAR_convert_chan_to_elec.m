function output_electrodes_list = RAR_convert_chan_to_elec (input_channels_file)

	channel_map = [-1,81,83,85,87,89,91,93,95,-1;
	94,96,65,67,69,71,73,75,77,79;
	74,76,78,80,82,84,86,88,90,92;
	53,55,57,59,61,63,66,68,70,72;
	33,35,37,39,41,43,45,47,49,51;
	46,48,50,52,54,56,58,60,62,64;
	25,27,29,31,34,36,38,40,42,44;
	5,7,9,11,13,15,17,19,21,23;
	18,20,22,24,26,28,30,32,1,3;
	-1,2,4,6,8,10,12,14,16,-1];
	
	electrode_map = [-1,89,90,91,92,93,94,95,96,-1;
	79,80,81,82,83,84,85,86,87,88;
	69,70,71,72,73,74,75,76,77,78;
	59,60,61,62,63,64,65,66,67,68;
	49,50,51,52,53,54,55,56,57,58;
	39,40,41,42,43,44,45,46,47,48;
	29,30,31,32,33,34,35,36,37,38;
	19,20,21,22,23,24,25,26,27,28;
	9,10,11,12,13,14,15,16,17,18;
	-1,1,2,3,4,5,6,7,8,-1];

	input_channels_list = readmatrix(input_channels_file);

	output_electrodes_list = [];
	for i=1:length(input_channels_list)
		channel_number = input_channels_list(i);
		location = find(channel_map == channel_number);
		electrode_number = electrode_map(location);
		output_electrodes_list = [output_electrodes_list, electrode_number];
	end

end