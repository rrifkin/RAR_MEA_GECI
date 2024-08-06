function RAR_rapidsort_cross_correl_stats (DMSO_bins_file, GiGA1_bins_file)

	alpha = 0.05;

	DMSO_bins = load(DMSO_bins_file);
	GiGA1_bins = load(GiGA1_bins_file);

	p = nan(1,size(DMSO_bins,2));

    for i = 1:length(DMSO_bins)
		p(i) = signrank (DMSO_bins(:,i), GiGA1_bins(:,i));
	end	

	p
	[corrected_p, significance]=bonf_holm(p,alpha)

end
