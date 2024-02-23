function RAR_plot_spikes (channel, processed_spikes_file)

	% parameters
	PC_threshold = 0.95; % probability threshold for PC
	IN_threshold = -0.85; % probability threshold for IN, should be NEGATIVE
	max_waveforms = 25; % maximum number you want to plot

	% load spikes already processed by 'The Library'
	load(processed_spikes_file, 'Library_processed_spikes');
	spikes = Library_processed_spikes;

	% RapidSort stuff happens here
    load('Columbia_UMAs_GMM.mat');

	spikes(channel).droppedIndices = unique([spikes(channel).droppedIndices spikes(channel).badZS]);
		
	hwsArray = spikes(channel).hws;
	hwsArray(spikes(channel).droppedIndices) = [];

	spikeArray = spikes(channel).waveforms;
	spikeArray(spikes(channel).droppedIndices,:) = [];

    input_hws = hwsArray;

    posterior_probs = GM.posterior(log(input_hws)');
    muHWs = [mean(input_hws(posterior_probs(:,1) > 0.5)); mean(input_hws(posterior_probs(:,2) > 0.5))];
    [~,wh] = max(muHWs); % keep the probabilities of being excitatory to make -1 mean inhibitory in below line
    scaleProbs = (posterior_probs(:,wh) * 2) - 1;

	% get indexes of spikes meeting threshold criteria
	PC_indexes = find(scaleProbs >= PC_threshold);
	IN_indexes = find(scaleProbs <= IN_threshold);

	num_PC = numel(PC_indexes);
	num_IN = numel(IN_indexes);

	% plot the first however many (per num_waveforms) of PC and IN
	j = min (num_PC, max_waveforms);
	for i = 1:j

		PC_index = PC_indexes(i);
		PC_wave = spikeArray(PC_index,:);
		RAR_plot_trace(PC_wave, 'PC', PC_index, processed_spikes_file, channel);

	end

	j = min (num_IN, max_waveforms);
	for i = 1:j

		IN_index = IN_indexes(i);
		IN_wave = spikeArray(IN_index,:);
		RAR_plot_trace(IN_wave, 'IN', IN_index, processed_spikes_file, channel);

	end

end

function RAR_plot_trace (wave, type, index, processed_spikes_file, channel)

	% parameters
	scalebar_y_offset = -10; % in microvolts
	scalebar_y = 5; % in microvolts
	scalebar_time = 0.5; % in ms
	sample_rate = 30000; % in Hz
	ylimit = [-30,20]; % in microvolts
	xlimit = [0, 50];
	microvolts_per_inch = 5;
	samples_per_inch = 20;
	pad = 2; % in inches
	linewidth = 2;
	fontsize = 20;

	scalebar_x = scalebar_time * (sample_rate / 1000); % in samples
	ax_width = (xlimit(2) - xlimit(1)) / samples_per_inch;
	ax_height = (ylimit(2) - ylimit(1)) / microvolts_per_inch;

	% create fig and axis
	fig = figure;
	ax = axes(fig);
	fig.Visible = 'off';

	% set figure properties
	fig.Position = [0, 0, ax_width + (2 * pad), ax_height + (2 * pad)]; % location and size of figure
	fig.PaperPositionMode = 'manual';
	fig.PaperUnits = 'inches';
	fig.PaperPosition = [0, 0, ax_width + (2 * pad), ax_height + (2 * pad)]; % location and size of figure within paper
	fig.PaperSize = [ax_width + (2 * pad), ax_height + (2 * pad)]; % size of paper

	% set x-axis properties
	ax.XLim = xlimit;
	ax.XAxis.Visible = 'off';

	% set y-axis properties
	ax.YLim = ylimit;
	ax.YAxis.Visible = 'off';

	% sets color of line depending on type of cell
	if strcmp(type,'PC')
		color = "blue";
	elseif strcmp(type,'IN')
		color = "red";
	end

	% make scalebar
	line([0, scalebar_x],[scalebar_y_offset,scalebar_y_offset], 'Color', 'black', 'Linewidth', linewidth); % horizontal line
	line([0,0],[scalebar_y_offset, scalebar_y_offset + scalebar_y], 'Color', 'black', 'Linewidth', linewidth); % vertical line
	y_string = strcat(num2str(scalebar_y), ' µV');
	x_string = strcat(num2str(scalebar_time), ' ms');
	text(-7,-8, y_string, 'FontSize', fontsize);
	text(2, -11, x_string, 'FontSize', fontsize);

	hold (ax, 'on');
	plot(wave, 'Linewidth', linewidth, 'Color', color);
	hold (ax, 'off');

	output_path = strcat(processed_spikes_file, '_channel_', num2str(channel), '_', type, '_spike_', num2str(index), '.pdf');
	print('-painters', '-dpdf', fig, output_path);

end