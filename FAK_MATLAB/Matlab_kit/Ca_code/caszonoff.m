function [ChanThresh] = caszonoff(Deltaint,catimes)
%caszonoff. Takes the moving average of the delta intensities on a channel
%by channel bases. 50frames at a time (this corresponds to approx 1
%second), with a sliding window of 1 frame = 0.02seconds or 20ms.
%It then looks for periods where that channels intensities are at least
%sustained one std above the mean for at least 5 seconds.

%Get line lengths

Linelength = [];
for i = 1:96;
    x= abs(diff(Deltaint(i,:),1,2));
    x(:,end+1) = 0;
    Linelength(i,:) = x;
    i=i+1;
end

%Get moving means
MovMean = [];
for j = 1:96;
    y = movmean(Linelength(j,:),[0 50]);
    MovMean(j,:) = y;
    j=j+1;
end
    
%Get thresholds (one std above the mean for each channel). 
%Figure out times where moving mean lies above that threshold for 5 seconds, ~250 frames.

for k = 1:96;
    %find threshold for that channel
    Thresh = mean(MovMean(k,:)) + std(MovMean(k,:));
    %find the threshold crossings for that channel
    ThreshBin = ((MovMean(k,:))>Thresh);
    ThreshBin(1) = 0;
    evstart1 = catimes(strfind(ThreshBin,[0 1]));
    evstop1 = catimes(strfind(ThreshBin,[1 0])); 
    evduration = (evstop1-evstart1);
    eventSummary = [evstart1,evstop1,evduration];
    sort_evsum = sortrows(eventSummary, [3], 'descend');
    indices = find(sort_evsum(:,3)<5);
    sort_evsum(indices,:) = [];
    ChanThresh.evstart{k,1} = evstart1;
    ChanThresh.evstop{k,1} = evstop1;
    ChanThresh.evsum{k,1} = sort_evsum;
    %clear values for the next channel
    Thresh = [];
    ThreshBin = [];
    evstart1 = [];
    evstop1 = [];
    evduration = [];
    eventSummary = [];
    sort_evsum = [];
    indices = [];
    k=k+1;
end


end

