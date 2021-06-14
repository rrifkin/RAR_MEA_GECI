function spikes = ss_detect_emerix(signal,spikes,rqq)
% Really ought to write a help section to this'n.

spikes.info.detect.stds = single(std(signal));
spikes.info.detect.dur = single(length(signal)/spikes.params.Fs);

if strcmp(spikes.params.detect_method,'auto')
    % set threshold from rqq:
    coeff = spikes.params.thresh;
    if nargin < 3 || isempty(rqq)
        rqq = median(abs(signal)/0.6745);
    end
    spikes.info.detect.thresh = single(-coeff*rqq);
    
else
    % manual threshold:
    spikes.info.detect.thresh = single(spikes.params.thresh);
    spikes.info.detect.maxThresh = single(spikes.params.maxThresh);
end
if strcmp(spikes.params.max_method,'auto')
    if ~exist('rqq','var')
        rqq = median(abs(signal)/0.6745);
    end
    spikes.info.detect.maxThresh = single(spikes.params.maxThresh*rqq);
else
    spikes.info.detect.maxThresh = single(spikes.params.maxThresh);
end

[~,locs] = findpeaks(-signal,'minpeakheight',-spikes.info.detect.thresh);
if length(locs) <= 1
    disp([9 'Fewer than 2 spikes detected, returning'])
    return;
end

preN = round(spikes.params.cross_time*(spikes.params.Fs/1000));
spikes.info.detect.align_sample = preN + 1;
windowN = round(spikes.params.window_size*(spikes.params.Fs/1000));
postN = windowN - preN;

locs(locs-preN < 1 | locs+postN > length(signal)) = [];

spkwin = -preN:postN;
spks = zeros(length(spkwin),length(locs));

for t = 1:length(locs)
    spks(:,t) = signal(locs(t)+spkwin);
end
spkt = locs;

% remove the overly large ones:
[~,j] = ind2sub(size(spks),find(abs(spks) > spikes.info.detect.maxThresh));
j = unique(j);
spks(:,j) = [];
spkt(j) = [];

spkt = spkt/spikes.params.Fs;

count = length(spkt);
if count < 2
	disp([9 'Fewer than 2 spikes left after removing high amplitude waveforms, returning'])
	return;
end
spikes.info.detect.event_channel = ones(1,count);
spikes.waveforms = spks';
spikes.spiketimes = single(spkt);
spikes.trials = single(ones(1,count));
spikes.unwrapped_times = single(spkt);

[pca.u,pca.s,pca.v] = svd(detrend(spikes.waveforms(:,:),'constant'), 0);
spikes.info.pca = pca;
spikes.info.detect.cov = get_covs_simple(signal, windowN);
spikes.info.align.aligned = 1; % this detection method is always aligned.

% get covariance matrix of background noise by randomly sampling 10000 timepoints
function c = get_covs_simple(data, samples)
num_samples = length(data);
max_samples = 10000;
waves = zeros([max_samples samples 1]);
tr_index = ceil(rand([1 max_samples]));
data_index = ceil( (num_samples(tr_index)-samples) .* rand([1 max_samples]) );
for j = 1:max_samples
   waves(j,:,:) = data(data_index(j)+[0:samples-1],:);  
end
c = cov(waves(:,:));