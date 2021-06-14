function spikes = ss_reset(spikes)

if isfield(spikes,'assigns')
    spikes = rmfield(spikes,'assigns');
end
if isfield(spikes,'labels')
    spikes = rmfield(spikes,'labels');
end

if isfield(spikes.info,'kmeans'), spikes.info = rmfield(spikes.info,'kmeans'); end
if isfield(spikes.info,'interface_energy'), spikes.info = rmfield(spikes.info,'interface_energy'); end
if isfield(spikes.info,'tree'), spikes.info = rmfield(spikes.info,'tree'); end