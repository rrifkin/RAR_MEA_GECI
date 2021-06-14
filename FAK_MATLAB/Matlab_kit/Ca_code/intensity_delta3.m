function [Z_delta] = intensity_delta3(Z_intensity,Z_baseline)
%Calculates the change in intensity for each channel wtr the baseline.
%Slightly different to intensity delta 2 in that it incorporates
%subtraction of the baseline into the formula. 
%  Input: Matrix with all the intensities of interest and a separate matrix
%  with the baseline area

%Change in intensity over the baseline for that channels ROI
Z_baseline_avg = mean(Z_baseline,2);
Z = [];
Z_delta = [];
for i = 1:96
    Z = ((Z_intensity(i,:)-Z_baseline_avg(i))/Z_baseline_avg(i));
    Z_delta(i,:) = Z;
    i=i+1;
end

end

