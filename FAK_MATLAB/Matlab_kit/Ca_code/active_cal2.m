function [LL] = active_cal2(delta_intensities,p1,p2)
%active_cal - figure out which channels have the most values above a
%certain threshold during a period of interest (POI). Threshold is set on a
%channel by channel basis.
%THIS NEEDS ALOT OF WORK. 

POI = delta_intensities(:,p1:p2);
A = [];
B = [];
LL = [];
for i = 1:96
    x= abs(diff(POI(i,:),1,2));
    x(:,end+1) = 0;
    LL(i,:) = x;
    i=i+1;
end


% RX = LL > (mean(LL)+std(LL));
% E = [1:96]';
% F = E(RX);
end

