function [Z_delta] = intensity_delta(Z_intensity,f_baseline)
%Calculates the change in intensity for each channel wtr the baseline
%  Input: Matrix with all the intensities and a matrix with the average
%  intensities during the baseline

%Change in intensity over the baseline for that channels ROI
Z = [];
Z_delta = [];
for i = 1:96
    Z = Z_intensity(i,:)/f_baseline(i);
    Z_delta(i,:) = Z;
    i=i+1;
end

% Z_baseline = Z_intensity(:,1:f_baseline);
% Z_baseline_avg = mean(Z_baseline,2);
% n=f_baseline+1;
% Z_interest = Z_intensity(:,n:(length(Z_intensity)));
% Z = [];
% Z_delta = [];
% for i = 1:96
%     Z = Z_interest(i,:)/Z_baseline_avg(i);
%     Z_delta(i,:) = Z;
%     i=i+1;
% end


% %Change in intensity over baseline average intensity of the entire field
% mean_baseline = mean(Z_baseline_avg);
% Z_delta2 = [];
% Z2 = [];
% for l = 1:96
%     Z2 = Z_interest(l,:)/mean_baseline;
%     Z_delta2(l,:) = Z2;
%     l=i+1;
% end

end

