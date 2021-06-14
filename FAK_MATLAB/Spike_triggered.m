calcium_resampled = zeros(96,88689);
for i = 1:96
    [calc_resampled, times_resampled] = resample(t7s1(i,:), times_v3, 50);
    calcium_resampled(i,:) = calc_resampled;
end

clear i calc_resampled 

input_data = pc_t3s3;
for i  = 1:length(input_data)
%for c = 1:96
    %n = 1; 
    %for i = 41
    [response, timing] = extract_spks(round((merged.units(input_data(i)).times(merged.units(input_data(i)).times > 950) - times_resampled(1))*50),calcium_resampled(merged.units(input_data(i)).channel,:),-50:50);
    %[response, timing] = extract_spks(round((merged.units(i).times - times_resampled(1))*50),calcium_resampled(c,:),-50:50);
    %response_temp(n,:) = mean(response);
    %n = n + 1;
    %end
    %response_in_units(c,:) = mean(response); %mean(response_temp);
    response_in_units(i,:) = mean(response);
    clear timing response
end

clear i 

%figure; plot((-50:50)/50,response_in_units(35,:))
figure; plot((-50:50)/50,(response_in_units))

clear c i n response response_temp timing clear response_in_units