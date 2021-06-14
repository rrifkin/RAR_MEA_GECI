function spikes = ss_complete(spikes,feedback)
if nargin < 2 || isempty(feedback) || feedback == 1
    spikes = ss_kmeans(spikes);
    spikes = ss_energy(spikes);
    spikes = ss_aggregate(spikes);
elseif feedback == 0
    opts.progress = 0;
    spikes = ss_kmeans(spikes,opts);
    spikes = ss_energy(spikes,1);
    spikes = ss_aggregate(spikes,[],1);
else
    error('Unknown feedback option, should be 0 or 1');
end
