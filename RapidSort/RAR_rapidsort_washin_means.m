% Calculates the mean PC and IN firing rate over a given period of time 
% for DMSO and GiGA1 files
% Input 'path' is the path to the folder for the entire slice.

function RAR_rapidsort_washin_means (path, timepoints)

	exp = 	["", "ZMG-DMSO", "ZMG-GiGA1"; 
			"PC", "", "";
			"IN", "", ""]

	for i = 2:numel(exp(1,:))
		cd (path);
		search_term = strcat('*', exp(1,i), '_NSxFile_MUA_spikes');
		folder = dir(search_term);
		folder_path = strcat(path, '/', folder.name);
		cd (folder_path);
		firing_rates_file = dir('*_rapidsort_gaussian_firing_rates.mat');
		firing_rates_path = strcat(folder_path, '/', firing_rates_file.name);
		load (firing_rates_path, 'rapidINfr', 'rapidINt', 'rapidPCfr', 'rapidPCt');

		% find index values of arrays that are equivalent to start and end times
		indexIN = find(rapidINt > timepoints(1) & rapidINt < timepoints(2));
		indexPC = find(rapidPCt > timepoints(1) & rapidPCt < timepoints(2));

		exp(2,i) = mean(rapidPCfr(indexPC(:)))
		exp(3,i) = mean(rapidINfr(indexIN(:))) 
	end

	cd (path);
	% Output data to .csv file
	pathparts = strsplit(path,filesep);
	file_stem = string(pathparts(end));
	str_timepoints = string(timepoints);
	str_timepoints = strjoin(str_timepoints, '-');
	output_path = strcat(path, '/', file_stem, str_timepoints, '_sec_rapidsort_mean_firing_rates.csv');
	writematrix(exp, output_path);
	
end