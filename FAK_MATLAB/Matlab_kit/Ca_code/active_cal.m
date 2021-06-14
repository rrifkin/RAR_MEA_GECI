function [C] = active_cal(delta_intensities)
%active_cal - figure out which channels have the most values above a
%certain threshold
%   Finds out the mean, and std of the delta intensities for the slice
%   experiment. Then calculates the percentage of the time that roi for
%   that channel spends at intensities which are 3 times the std for the
%   entire set of rois.

all_delta_values = delta_intensities(:);
meanvalue = mean(all_delta_values);
stdvalue = std(all_delta_values);
threshold = meanvalue + (3*stdvalue);
A = [];
B = [];
C = [];
for i = 1:96
    A = delta_intensities(i,:);
    B = A>threshold;
    C(i,:) = numel(B(B>0));
    i=i+1;
end

C = (C/numel(delta_intensities(1,:)))*100;

end

