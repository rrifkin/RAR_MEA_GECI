
function RAR_rapidsort_batch_WT_Non_Tumor_histogram

	DMSO_experiments = {
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
	% outlier '/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.05 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.05 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 1',
	};

	GiGA1_experiments = {
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 2',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.25 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 4',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 2',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.07.27 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 4',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 2',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.01 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 4 (washout)',
	% outlier '/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 2',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.02 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 4 (washout)',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 2 (washout)',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.04 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 3 (washout)',
	'/Volumes/Electrophysiology Portable/Electrophysiology/2022.08.05 WT Non-Tumor MEA GiGA1 vs. Vehicle/2022.08.05 WT Non-Tumor MEA GiGA1 vs. Vehicle, slice 2 (washout)',
	};

	all_half_widths = [];

	for i = 1:numel(DMSO_experiments)
		cd (DMSO_experiments{i});
		processed_spikes = dir('**/*DMSO_NSxFile_MUA_spikes_rapidsort_processed_spikes.mat');
		processed_spikes_file = strcat(processed_spikes.folder, '/', processed_spikes.name)
		temp_half_widths = RAR_rapidsort_histogram(processed_spikes_file);

		all_half_widths = [all_half_widths temp_half_widths];

	end

	% for i = 1:numel(GiGA1_experiments)
	% 	cd (GiGA1_experiments{i});
	% 	processed_spikes = dir('**/*GiGA1_NSxFile_MUA_spikes_rapidsort_processed_spikes.mat');
	% 	processed_spikes_file = strcat(processed_spikes.folder, '/', processed_spikes.name)
	% 	temp_half_widths = RAR_rapidsort_histogram(processed_spikes_file);

	% 	all_half_widths = [all_half_widths temp_half_widths];

	% end

	RAR_rapidsort_combined_histogram (all_half_widths);

end

function RAR_rapidsort_combined_histogram (hwsArray)

    load('Columbia_UMAs_GMM.mat');
    
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

	cd('/Users/robert');

	print('-painters', '-dpdf', fig, "combined_histogram.pdf");

end