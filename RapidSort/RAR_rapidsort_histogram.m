% provides a visual comparison of the input spike half-widths to the GMM

function hwsArray = RAR_rapidsort_histogram (processed_spikes_file)

	load(processed_spikes_file);
	spikes = Library_processed_spikes;

    epoch_start = 0;
    epoch_end = spikes(1).info.detect.dur;

    load('Columbia_UMAs_GMM.mat');
    
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
        

	xSpace = linspace(log(min(hwsArray)),log(max(hwsArray)),100);
	a = normpdf(xSpace,GM.mu(1),sqrt(GM.Sigma(:,:,1)));
	b = normpdf(xSpace,GM.mu(2),sqrt(GM.Sigma(:,:,2)));
	probs = GM.posterior(log(hwsArray)');
	v = [mean(hwsArray(probs(:,1) > 0.5)); mean(hwsArray(probs(:,2) > 0.5))];
	[~,w] = max(v);
	probs = probs(:,w);
	
	% instantiate the figure and axes with names
	fig = figure;
	ax = axes(fig);
	fig.Visible = 'off';

	%figure('Position',[90 250 1500 680]);
	hold(ax,'on');
	histogram(log(hwsArray),'Normalization','pdf');
	plot(xSpace,a.*GM.ComponentProportion(1),'linewidth',2, 'color','b');
	plot(xSpace,b.*GM.ComponentProportion(2),'linewidth',2, 'color','r');
	xline(log(max(hwsArray(probs < 0.5))),'color','k','linewidth',2);
	xlabel('_{log}FWHM');
	ylabel('PDF');

	histogram_file = strcat(processed_spikes_file(1:end-4), '_histogram.pdf');

	print('-painters', '-dpdf', fig, histogram_file);

end