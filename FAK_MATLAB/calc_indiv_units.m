input_data = in_t3s1;
base = (-50:50)/50;

t3s1_means_in = NaN(96,length(input_data));
for i = 1:length(input_data)
    response_in_units = NaN(96,length(base));
    %for c = 1:96
        response = extract_spks(round((merged.units(input_data(1)).times(merged.units(input_data(1)).times > 950) - times_resampled(1))*50),calcium_resampled(merged.units(input_data(1)).channel,:),-50:50);
        response_in_units(c,:) = mean(response);
    end
    interval = response_in_units(:, base>=0 & base<=.2);
    t3s1_means_in(:,i) = mean(interval,2);
    clear response timing response_in_units interval
end

clear i c

pvals_combined = NaN(1,size(t3s1_means_in_pre950,2));
for i = 1:size(t3s1_means_in_pre950,2)
    pvals_combined(i) = ranksum(t3s1_means_in_pre950(:,i),t3s1_means_pc_pre950(:),'tail','left');
end