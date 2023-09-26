function [rapidINfr,rapidINt,rapidPCfr,rapidPCt] = RAR_rapidsort (spikes)

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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Now RapidSort firing rates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    binWidth = 1;
    binStep = 0.25;
    
    input_hws = hwsArray;
    input_times = keptSpikeTimes;

    epoch = [0, input_times(end)]; % Adjusted so epoch starts at 0. % Need to keep up to date for different datasets, and ensure 'input_times' has been shifted so 0 = seizure onset
    
    tVals = floor(min(input_times)):binStep:ceil(max(input_times));
    posterior_probs = GM.posterior(log(input_hws)');
    muHWs = [mean(input_hws(posterior_probs(:,1) > 0.5)); mean(input_hws(posterior_probs(:,2) > 0.5))];
    [~,wh] = max(muHWs); % keep the probabilities of being excitatory to make -1 mean inhibitory in below line
    scaleProbs = (posterior_probs(:,wh) * 2) - 1;
    
    SD = 1000;
    scaleByConf = true; % If true, it'll use the confidences to weight the resultant firing rate
    % Rapids:
    rapidIN = SingleUnit('times',input_times(scaleProbs < 0));
    rapidIN.metrics = UnitMetrics();
    rapidIN.metrics.matchConfidence = -scaleProbs(scaleProbs < 0);
    
    rapidPC = SingleUnit('times',input_times(scaleProbs > 0));
    rapidPC.metrics = UnitMetrics();
    rapidPC.metrics.matchConfidence = scaleProbs(scaleProbs > 0);
    
    [rapidINfr,rapidINt] = rapidIN.gaussian_fr(SD,epoch,scaleByConf);
    [rapidPCfr,rapidPCt] = rapidPC.gaussian_fr(SD,epoch,scaleByConf);
end