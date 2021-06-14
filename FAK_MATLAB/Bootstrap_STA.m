% settings
input_data = in_t7s2;
sta_window = -50:50;
bootstrap_n = 10000;
% end settings.

pVals = NaN(96,length(input_data));
n_significant = 0;

for c = 1:96
    disp(['---- Working on channel ' num2str(c) '----'])
    response_temp = NaN(length(input_data),length(sta_window));
    calc_data = calcium_resampled(c,:);
    for i = 1:length(input_data)
        % True data:
        spkt = round(merged.units(input_data(i)).times*50);
        [response, timing] = extract_spks(spkt,calc_data,sta_window);
        response_temp(i,:) = mean(response);
        
        % Shuffled data:
        null_response = NaN(bootstrap_n,length(sta_window));
        parfor n = 1:bootstrap_n
            shuffled = spkt;
            spkdiff = diff(spkt);
            shuffled(2:end) = shuffled(1) + cumsum(spkdiff(randperm(length(spkdiff))));

            [response, timing] = extract_spks(shuffled,calc_data,sta_window);
            null_response(n,:) = mean(response);
        end
        % Find probability of actual lowest calcium STA after spike, based
        % on a Gaussian fit of the null distribution derived from the
        % shuffled data:
        [v,w] = min(response_temp(i,sta_window >= 0));
        [mu,sigma] = normfit(null_response(:,w));
        pVals(c,i) = normpdf(v,mu,sigma)/sum(null_response(:,w));
        if pVals(c,i) < 0.05
            disp([9 'Unit ' num2str(input_data(i)) ' had a significant impact on channel ' num2str(c) ' (p = ' num2str(pVals(c,i)) ')'])
            n_significant = n_significant + 1;
        end
    end
end

totPairs = 96*length(input_data);
disp(['Total neuron/channel pairs showing uncorrected significance: ' num2str(n_significant)])
disp([9 '(' num2str(n_significant/totPairs*100) '% of ' num2str(totPairs) ')'])