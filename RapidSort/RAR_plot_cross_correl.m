function normalized_PC_bins = RAR_plot_cross_correl (processed_spikes_file, epoch)

	% parameters
	PC_threshold = 0; % probability threshold for PC
	IN_threshold = 0; % probability threshold for IN, should be NEGATIVE (or zero)
	window = 0.010; % time in seconds before and after spike
	bin_width = 0.002; % bin width in seconds

	% load spikes already processed by 'The Library'
	load(processed_spikes_file, 'Library_processed_spikes');
	spikes = Library_processed_spikes;

	% RapidSort stuff happens here
    load('Columbia_UMAs_GMM.mat')
    
    keptSpikeTimes = [];
    hwsArray = [];
    spikeArray = [];
    for p = 1:length(spikes)
        if ~isempty(spikes(p).waveforms)
            spikes(p).droppedIndices = unique([spikes(p).droppedIndices spikes(p).badZS]);
    
            temp = spikes(p).spiketimes;
            temp(spikes(p).droppedIndices) = [];
            keptSpikeTimes = [keptSpikeTimes, temp];
            
            temp = spikes(p).hws;
            temp(spikes(p).droppedIndices) = [];
            hwsArray = [hwsArray, temp];
    
            temp = spikes(p).waveforms;
            temp(spikes(p).droppedIndices,:) = [];
            spikeArray = [spikeArray; temp]; 
    
        else
            continue
        end
    end
            
    posterior_probs = GM.posterior(log(hwsArray)');
    muHWs = [mean(hwsArray(posterior_probs(:,1) > 0.5)); mean(hwsArray(posterior_probs(:,2) > 0.5))];
    [~,wh] = max(muHWs); % keep the probabilities of being excitatory to make -1 mean inhibitory in below line
    scaleProbs = (posterior_probs(:,wh) * 2) - 1;

	SD = 1000;
    scaleByConf = true; % If true, it'll use the confidences to weight the resultant firing rate

    % Rapids:
    rapidIN = SingleUnit('times',keptSpikeTimes(scaleProbs < 0));
    rapidIN.metrics = UnitMetrics();
    rapidIN.metrics.matchConfidence = -scaleProbs(scaleProbs < 0);
    
    rapidPC = SingleUnit('times',keptSpikeTimes(scaleProbs > 0));
    rapidPC.metrics = UnitMetrics();
    rapidPC.metrics.matchConfidence = scaleProbs(scaleProbs > 0);
    
    [rapidINfr,rapidINt] = rapidIN.gaussian_fr(SD,epoch,scaleByConf);
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

	output_file = strcat(processed_spikes_file(1:end-20), 'IN-triggered_PC_bins.csv');
	writematrix(normalized_PC_bins, output_file);

end
