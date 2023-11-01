% Main function for doing RapidSort for prevention experiments
% Input is spike directories in chronological order

function RAR_rapidsort_prevention_workflow (path)

	names = ["ACSF", "ZMG-GiGA1", "ZMG-DMSO", "ZMG-DMSO part 2"];
	exp = struct;

	j = 1;
	for i = 1:length(names)
		cd (path);
		search_term = strcat('*', names(i), '_NSxFile_MUA_spikes');
		folder = dir(search_term);
		if isempty(folder) ~= 1
			exp(j).path = strcat(path, '/', folder.name);
			RAR_rapidsort_workflow (exp(j).path)
			cd (exp(j).path);
			exp(j).firing_rates_file = dir('*_rapidsort_gaussian_firing_rates.mat');
			exp(j).firing_rates_path = strcat(exp(j).firing_rates_file.folder, '/', exp(j).firing_rates_file.name);
			load (exp(j).firing_rates_path, 'rapidINfr', 'rapidINt', 'rapidPCfr', 'rapidPCt');
			exp(j).rapidINfr = rapidINfr;
			exp(j).rapidINt = rapidINt;
			exp(j).rapidPCfr = rapidPCfr;
			exp(j).rapidPCt = rapidPCt;
			j = j + 1;
		end
	end

	cd (path);

	RAR_rapidsort_prevention_plot (exp, path)
	RAR_rapidsort_prevention_means (path, [0,1800])
	
end