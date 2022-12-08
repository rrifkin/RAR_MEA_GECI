% Takes normalized calcium imaging data (in ROI order, not rearranged into MEA channel order) and calculates Pearson correltion coefficient of each ROI compared to its 8 immediate neighbors. This is performed for the pre- and post-GiGA1 epochs.

function RAR_Pearson_correlation (DMSO_file, GiGA1_file, included_minutes)

	frame_rate = 50;

	DMSO_normalized = importdata (DMSO_file);
	GiGA1_normalized = importdata (GiGA1_file);

    start_frame = included_minutes(1) * 60 * frame_rate;
	end_frame = included_minutes(end) * 60 * frame_rate;
	included_min_string = strcat('_include_min_', num2str(included_minutes(1)), '-', num2str(included_minutes(end)));

	% arrays containing the r_values for control and giga1 epochs
	r_values_DMSO = [];
	r_values_GiGA1 = [];

	% iterate through all ROIs
	for ROI = 1:8
		
		% compare to value RIGHT
		if ROI ~=8
			RAR_Pearson_compare(ROI,1);
		end

		% compare to value UP LEFT
		RAR_Pearson_compare(ROI,8);
		
		% compare to value UP
		RAR_Pearson_compare(ROI,9);

		% compare to value UP RIGHT
		RAR_Pearson_compare(ROI,10);
	end

	for ROI = 9:78
		% compare to value RIGHT
		if rem(ROI,10) ~=8
			RAR_Pearson_compare(ROI,1);
		end

		% compare to value UP LEFT
		if rem(ROI,10) ~= 9
			RAR_Pearson_compare(ROI,9);
		end
		
		% compare to value UP
		RAR_Pearson_compare(ROI,10);

		% compare to value UP RIGHT
		if rem(ROI,10) ~=8
			RAR_Pearson_compare(ROI,11);
		end

	end

	for ROI = 79:88

		% compare to value RIGHT
		if rem(ROI,10) ~=8
			RAR_Pearson_compare(ROI,1);
		end

		% compare to value UP LEFT
		if ((rem(ROI,10) ~= 9) & (rem(ROI,10) ~= 0))
			RAR_Pearson_compare(ROI,8);
		end
		
		% compare to value UP
		if ((rem(ROI,10) ~= 9) & (rem(ROI,10) ~= 8))
			RAR_Pearson_compare(ROI,9);
		end

		% compare to value UP RIGHT
		if ((rem(ROI,10) ~= 7) & (rem(ROI,10) ~= 8))
			RAR_Pearson_compare(ROI,10);
		end

	end

	for ROI = 89:95
		RAR_Pearson_compare(ROI,1);
	end

	DMSO_output_file = strcat(DMSO_file(1:end-25), included_min_string, '_Pearson_r_values.csv');
	writematrix (r_values_DMSO', DMSO_output_file);

	GiGA1_output_file = strcat(GiGA1_file(1:end-25), included_min_string, '_Pearson_r_values.csv');
	writematrix (r_values_GiGA1', GiGA1_output_file);

	% nested function that compares an index ROI to any neighbor, defined by 'diff'
	function RAR_Pearson_compare(index, diff)
		r_matrix_DMSO = corrcoef(DMSO_normalized(index,start_frame:end_frame), DMSO_normalized(index + diff,start_frame:end_frame));
		r_values_DMSO (end+1) = r_matrix_DMSO(1,2);

		r_matrix_GiGA1 = corrcoef(GiGA1_normalized(index,start_frame:end_frame), GiGA1_normalized(index + diff,start_frame:end_frame));
		r_values_GiGA1 (end+1) = r_matrix_GiGA1(1,2);
	end

end

