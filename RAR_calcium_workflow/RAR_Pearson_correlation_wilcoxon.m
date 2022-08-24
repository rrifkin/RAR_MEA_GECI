% Takes normalized calcium imaging data (in ROI order, not rearranged into MEA channel order) and calculates Pearson correltion coefficient of each ROI compared to its 8 immediate neighbors. This is performed for the pre- and post-GiGA1 epochs.

function RAR_Pearson_correlation_wilcoxon (input_file)

	load (input_file, 'Delta_eleccal');
	data = Delta_eleccal;

	% arrays containing the r_values for control and giga1 epochs
	r_values_control = [];
	r_values_giga1 = [];

	% function that compares an index ROI to any neighbor, defined by 'diff'
	function RAR_Pearson_compare(index, diff)
		r_matrix = corrcoef(data(index,1:45000),data(index + diff,1:45000));
		r_values_control (end+1) = r_matrix(1,2);

		r_matrix = corrcoef(data(index,45001:90000),data(index + diff,45001:90000));
		r_values_giga1 (end+1) = r_matrix(1,2);
	end

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

	control_mean = mean(r_values_control,'omitnan');
	control_SEM = RAR_sem(r_values_control);

	giga1_mean = mean(r_values_giga1,'omitnan');
	giga1_SEM = RAR_sem(r_values_giga1);

	disp('Control mean r-value:');
	disp(control_mean);
	disp('Control SEM:');
	disp(control_SEM);

	disp('GIGA1 mean r-value:');
	disp(giga1_mean);
	disp('GIGA1 SEM:');
	disp(giga1_SEM);

	p_value = ranksum(r_values_control,r_values_giga1);
	disp('p value:')
	disp(p_value);

	save('r_values_control.mat','r_values_control');
	save('r_values_giga1.mat','r_values_giga1');

end