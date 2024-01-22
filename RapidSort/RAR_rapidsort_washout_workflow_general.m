% Main function for doing RapidSort for wash-in experiments
% Input 'path' is the path to the folder for the entire slice.

function RAR_rapidsort_washout_workflow_general (path, timepoints, seconds_per_inch, PC_Hz_per_inch)

	exp(1).name = 'ACSF';
	exp(2).name = 'ZMG-GiGA1';
	exp(3).name = 'ZMG-DMSO';

	for i = 1:length(exp)
		cd (path);
		exp(i).search_term = strcat('*', exp(i).name, '*_NSxFile_MUA_spikes');
		exp(i).folder = dir(exp(i).search_term);
		exp(i).path = strcat(path, '/', exp(i).folder.name);
		%RAR_rapidsort_workflow (exp(i).path);
		cd (exp(i).path);
		exp(i).firing_rates_file = dir('*_rapidsort_gaussian_firing_rates.mat');
		exp(i).firing_rates_path = strcat(exp(i).firing_rates_file.folder, '/', exp(i).firing_rates_file.name);
		load (exp(i).firing_rates_path, 'rapidINfr', 'rapidINt', 'rapidPCfr', 'rapidPCt');
		exp(i).rapidINfr = rapidINfr;
		exp(i).rapidINt = rapidINt;
		exp(i).rapidPCfr = rapidPCfr;
		exp(i).rapidPCt = rapidPCt;
	end

	cd (path);

	RAR_rapidsort_plot_general (exp, path, timepoints, seconds_per_inch, PC_Hz_per_inch)
	
end