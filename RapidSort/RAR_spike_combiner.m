% Put all .mat files containing "spikes" structs into single directory
% (nothing else in there)
% Run the below so that the output is one struct with N levels, which is
% compatible with the RapidSort infrastructure.

function spikes = RAR_spike_combiner (directory)

	% Get a list of all files in the directory
	fileList = dir(fullfile(directory, '*_channel_*.mat'));
	numFiles = numel(fileList);

	% Initialize
	all_spikes = struct('params', {}, 'info', {}, 'waveforms', {}, ...
		'spiketimes', {}, 'trials', {}, 'unwrapped_times', {}, ...
		'assigns', {}, 'labels', {});


	for i = 1:numFiles
		file = fullfile(directory, fileList(i).name);
		data = load(file);
		spikes = data.spikes;
		
		all_spikes(i).params = spikes.params;
		all_spikes(i).info = spikes.info;
		all_spikes(i).waveforms = spikes.waveforms;
		all_spikes(i).spiketimes = spikes.spiketimes;
		all_spikes(i).trials = spikes.trials;
		all_spikes(i).unwrapped_times = spikes.unwrapped_times;
		all_spikes(i).assigns = spikes.assigns;
		all_spikes(i).labels = spikes.labels;
	end
	spikes = all_spikes;

	% FYI: code to iterate through each channel of spikes and tease out
	% good/bad waves and HWs. These four variables need to be saved as a .mat file 
	% if they are to be used in the SpikeReview.mlapp 
	%{
	good_wvs = [];
	bad_wvs = [];
	good_hws = [];
	bad_hws = [];

	for p = 1:length(spikes)
		temp = spikes(p).hws;
		bad_hws = [bad_hws, temp(spikes(p).droppedIndices)];
		temp(spikes(p).droppedIndices) = [];
		good_hws = [good_hws, temp];
		temp = spikes(p).waveforms;
		bad_wvs = [bad_wvs; temp(spikes(p).droppedIndices,:)];
		temp(spikes(p).droppedIndices,:) = [];
		good_wvs = [good_wvs; temp];


	end

	%}
end


