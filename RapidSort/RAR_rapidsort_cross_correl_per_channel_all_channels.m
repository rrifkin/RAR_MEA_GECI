function whole_slice_normalized_PC_bins = RAR_rapidsort_cross_correl_per_channel_all_channels (processed_spikes_file, epoch)

	% parameters
	PC_threshold = 0; % probability threshold for PC
	IN_threshold = 0; % probability threshold for IN, should be NEGATIVE (or zero)
	window = 0.020; % time in seconds before and after spike
	bin_width = 0.001; % bin width in seconds

	% load spikes already processed by 'The Library'
	load(processed_spikes_file, 'Library_processed_spikes');
	spikes = Library_processed_spikes;

	% RapidSort stuff happens here
    load('Columbia_UMAs_GMM.mat')

	spikes = rejectSimulDetects(spikes);
    
	per_channel_normalized_PC_bins = [];
    for p = 1:length(spikes)
        if ~isempty(spikes(p).waveforms)
            spikes(p).droppedIndices = unique([spikes(p).droppedIndices spikes(p).badZS spikes(p).simultaneousDetections]);
    
            keptSpikeTimes = spikes(p).spiketimes;
            keptSpikeTimes(spikes(p).droppedIndices) = [];
            
            hwsArray = spikes(p).hws;
            hwsArray(spikes(p).droppedIndices) = [];
    
            spikeArray = spikes(p).waveforms;
            spikeArray(spikes(p).droppedIndices,:) = [];

			posterior_probs = GM.posterior(log(hwsArray)');
			muHWs = [mean(hwsArray(posterior_probs(:,1) > 0.5)); mean(hwsArray(posterior_probs(:,2) > 0.5))];
			[~,wh] = max(muHWs); % keep the probabilities of being excitatory to make -1 mean inhibitory in below line
			scaleProbs = (posterior_probs(:,wh) * 2) - 1;

			SD = 1000;
			scaleByConf = true; % If true, it'll use the confidences to weight the resultant firing rate

			% Rapids:
			rapidPC = SingleUnit('times',keptSpikeTimes(scaleProbs > 0));
			rapidPC.metrics = UnitMetrics();
			rapidPC.metrics.matchConfidence = scaleProbs(scaleProbs > 0);
			
			[rapidPCfr,rapidPCt] = rapidPC.gaussian_fr(SD,epoch,scaleByConf);

			% mean rapidsort population firing rates over epoch
			mean_PC_firing_rate = mean(rapidPCfr);

			% get indexes of spikes meeting threshold and epoch criteria
			PC_indexes = find(scaleProbs >= PC_threshold);
			PC_times = keptSpikeTimes(PC_indexes);
			PC_indexes = find(PC_times >= epoch(1) & PC_times <= epoch(2));
			PC_times = PC_times(PC_indexes);

			IN_indexes = find(scaleProbs <= IN_threshold);
			IN_times = keptSpikeTimes(IN_indexes);
			IN_indexes = find(IN_times >= epoch(1) & IN_times <= epoch(2));
			IN_times = IN_times(IN_indexes);
			IN_num = numel(IN_times);

			% IN-triggered PC
			all_PC_times_relative = []; 

			for i = 1:IN_num

				start_time = IN_times(i) - window; 
				stop_time = IN_times(i) + window; 
				PC_indexes_within_window = find(PC_times >= start_time & PC_times <= stop_time);
				if ~isempty(PC_indexes_within_window)
					PC_times_within_window = PC_times(PC_indexes_within_window);
					PC_times_relative = PC_times_within_window - IN_times(i);

					% delete PC and IN pair that happens at exact same time (probably artifact)
					PC_times_relative(PC_times_relative == 0) = []; 

					all_PC_times_relative = [all_PC_times_relative PC_times_relative];
				end
			end

			[PC_bins,~] = histcounts(all_PC_times_relative,-window:bin_width:window);
			normalized_PC_bins = (PC_bins / mean_PC_firing_rate) / IN_num;
			
			per_channel_normalized_PC_bins = [per_channel_normalized_PC_bins; normalized_PC_bins];
		

        else
            continue
        end
    end

	whole_slice_normalized_PC_bins = sum(per_channel_normalized_PC_bins,1,"omitnan");

	output_file = strcat(processed_spikes_file(1:end-20), 'IN-triggered_PC_bins_per_channel_all_channels.csv');
	writematrix(per_channel_normalized_PC_bins, output_file);

	output_file = strcat(processed_spikes_file(1:end-20), 'IN-triggered_PC_bins_per_channel_whole_slice_all_channels.csv');
	writematrix(whole_slice_normalized_PC_bins, output_file);

end

function spikes = rejectSimulDetects(spikes,simultaneousProportion,simultaneousMinimum,tolerance)
	% "Layer 2" rejection of simultaneous detections across N electrodes
	if nargin < 2 || isempty(simultaneousProportion)
		simultaneousProportion = 0.03; % Proportion of channels across which a simultaneous detection should be treated as noise
	end
	if nargin < 3 || isempty(simultaneousMinimum)
		simultaneousMinimum = 3; % Minimum number of channels for above (i.e., round up to this number if the proportion of available channels is fewer)
	end
	if nargin < 4 || isempty(tolerance)
		tolerance = 0; % tolerance to accept as simultaneous across channels (in milliseconds)
	end
	
	minChans = max([simultaneousProportion * length(spikes) simultaneousMinimum]);
	
	% Concatenate all spike times, with checks for any being the wrong
	% dimensions: (they should all be rows by default because
	% RapidSortSpikes forces it, but just in case)
	rowSpikes = arrayfun(@(x)isrow(x.spiketimes), spikes);
	if sum(rowSpikes) == length(spikes)
		spkt = horzcat(spikes.spiketimes);
	elseif sum(rowSpikes) == 0
		spkt = vertcat(spikes.spiketimes);
	else
		for r = find(rowSpikes == false)
			spikes(r).spiketimes = spikes(r).spiketimes';
		end
		spkt = horzcat(spikes.spiketimes);
	end
	spkt = spkt * 1e3; % use milliseconds
	
	% pad before and after to ensure picking up both values when tolerance > 0:
	badList = spkt(abs(diff([NaN spkt])) <= tolerance | abs(diff([spkt NaN])) <= tolerance);
	
	% check for which bad times occurred across enough channels:
	wasBad = zeros(1,length(badList));
	badInds = cell(length(badList),length(spikes));
	for b = 1:length(badList)
		badInds(b,:) = arrayfun(@(x)ismember(x.spiketimes*1e3,badList(b)),spikes,'UniformOutput',false);
		if length(find(cellfun(@sum,badInds))) > minChans
			wasBad(b) = 1;
		end
	end
	badInds(~wasBad,:) = []; % Only keep the list of times that occurred on enough channels
	
	% Mark each spikes struct accordingly:
	for b = 1:size(badInds,1)
		for s = 1:length(badInds(b,:))
			spikes(s).simultaneousDetections = find(badInds{b,s});
		end
	end
end