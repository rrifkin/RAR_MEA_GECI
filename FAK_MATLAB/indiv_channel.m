input_data = input_data_upd;
base = (-50:50)/50;

t3s3_means_pc = NaN(1,length(input_data));
response_in_units = NaN(1,length(base));
for i = 1:length(input_data)
    response = extract_spks(round((merged.units(input_data(i)).times(merged.units(input_data(i)).times < 950) - times_resampled(1))*50),calcium_resampled(merged.units(input_data(i)).channel,:),-50:50);
    response_in_units(1,:) = mean(response);    
    interval = response_in_units(:,base>=0 & base<=.2);
    t3s3_means_pc(:,i) = mean(interval,2);
    clear response timing response_in_units interval
end

clear i 

pvals_t3s3_pre950 = NaN(1,size(t3s3means_in_pre950,2));
for i = 1:size(t3s3_means_in_pre950,2)
    pvals_t3s3_pre950(i) = ranksum(t3s3_means_in_pre50(:,i),t3s3_means_pc_pre950(:),'tail','left');
end

a = bonf_holm(pvals_t3s1_post950);
b = length(find(a <.05));