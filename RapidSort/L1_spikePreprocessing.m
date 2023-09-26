function spikes = L1_spikePreprocessing(spikes)
chiCutoff = 0.001; % 0.1%
sdCutoff = 1;
echoLimit = 1; % in milliseconds
fprintf(['Cutoff parameters:\n' ...
    'Chi square cutoff: ', num2str(chiCutoff), ...
    '\nSD Cutoff: ', num2str(sdCutoff), ...
    '\nEcho Limit: ', num2str(echoLimit), '\n'])
   
for p = 1:length(spikes)
    if ~isempty(spikes(p).waveforms)
    fprintf(['Processing channel ', num2str(p), '\n'])

    isi = diff(spikes(p).spiketimes*1e3);
    % spikes(p).badEcho = [find(isi < echoLimit), find(isi < echoLimit) + 1]; % Maybe try this?
    spikes(p).badEcho = find(isi < echoLimit) + 1; % should be the waveform after the detection (because diff gives no answer for first)
    
    [~,pc,~,~,expl] = pca(spikes(p).waveforms);
    nPC = find(cumsum(expl) > 80, 1);
    
    mh = mahal(pc(:,1:nPC),pc(:,1:nPC));
    spikes(p).mh = mh;
    xSp = linspace(0,max(mh),1e4); % fairly high resolution
    chiProbs = chi2cdf(xSp,nPC,'upper');
    cutoff = xSp(find(chiProbs < chiCutoff, 1));
    cutoff = max(cutoff, mean(mh) + (sdCutoff*std(mh))); % e.g., either < 0.1% chance of occurring or further than N SD away, whichever is larger
    spikes(p).badMahal = find(mh > cutoff);
    
    % HALF WIDTHS
    [spikes(p).hws,totMissing] = interpSpikeHW(spikes(p).waveforms,3e4,19);
    spikes(p).badHWs = find(isnan(spikes(p).hws));
    
    flds = fieldnames(spikes(p));
    flds = flds(contains(flds,'bad'));
    for f = 1:length(flds)
        if iscolumn(spikes(p).(flds{f}))
            spikes(p).(flds{f}) = spikes(p).(flds{f})';
        end
    end
    
    spikes(p).droppedIndices = unique([spikes(p).badEcho spikes(p).badMahal spikes(p).badHWs]);

    else
        fprintf(['Skipping empty channel ', num2str(p), '\n'])
        spikes(p).badEcho = [];
        spikes(p).badMahal = [];
        spikes(p).badHWs = [];
        spikes(p).droppedIndices = [];
    end

end