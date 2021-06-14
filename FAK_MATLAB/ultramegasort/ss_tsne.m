function spikes = ss_tsne(spikes,perplexity,theta)

if nargin < 2 || isempty(perplexity)
    perplexity = spikes.params.perplexity;
end
if nargin < 3 || isempty(theta)
    theta = spikes.params.theta;
end

mappedX = fast_tsne(spikes.waveforms,spikes.params.output_dims,spikes.params.initial_dims,perplexity,theta);

spikes.tsne.data = mappedX;
spikes.tsne.perplexity = perplexity;
spikes.tsne.theta = theta;