function spikes = ss_known_noise(spikes,times,cutoff)
% takes in a spikes struct, and some known times of noise. If a proportion 
% of spikes (above cutoff) occurred during the noise then it is assigned to
% mostlyNoise, and given the "garbage" label
if nargin < 3
    cutoff = 0.9; % proportion of spikes to be in noise segments in order to discard
end
[m,n] = size(times);
if n ~= 2
    error('Each set of times should be a pair (start and end time)')
end
unq = unique(spikes.assigns);
spikes.mostlyNoise = zeros(1,max(spikes.assigns));
for u = 1:length(unq)
    inds = get_spike_indices(spikes,unq(u));
    spiket = spikes.spiketimes(inds);
    proportions = zeros(1,m); % will be used to assess the proportion that is in any of them
    for t = 1:m % go through each possible noise segment
        if ~spikes.mostlyNoise(unq(u)) % if this cluster is already noise from a different noise segment, don't bother
            noise = times(t,:); % get these noise boundaries in time
            inNoise = 0; % set none of the times to be in the noise segment at first
            for s = 1:length(spiket)
                if spiket(s) > noise(1) && spiket(s) <= noise(2)
                    inNoise = inNoise + 1; % if this spike was during the noise time, add it to the total inNoise
                end
            end
            if inNoise/length(spiket) > cutoff % if the proportion of spikes during noise is above cut off, assign it to noise
                spikes.mostlyNoise(unq(u)) = 1;
            end
            proportions(t) = inNoise/length(spiket);
        end
    end
    if ~spikes.mostlyNoise(unq(u))
        if sum(proportions) > cutoff % between all the noise points, we're above cut off level
            spikes.mostlyNoise(unq(u)) = 1;
        end
    end
end
% set the ones found to be above cutoff level for only in noise timepoints
% to be "garbage"
for s = 1:length(spikes.mostlyNoise)
    if spikes.mostlyNoise(s)
        spikes.labels(spikes.labels(:,1) == s,2) = 4; % 4 is the label for garbage
    end
end