function [hw,totalMissing] = interpSpikeHW(spks,Fs,keypoint,uprate,onlyPost)
if nargin < 3 || isempty(spks) || isempty(keypoint)
    error('Need at least 3 inputs: waveforms, Fs, keypoint')
end
if nargin < 4 || isempty(uprate)
    uprate = 4;
end
if nargin < 5 || isempty(onlyPost)
    onlyPost = false;
end

spks = spks - spks(:,keypoint);
if onlyPost
    spks = spks./max(spks(:,keypoint:end),[],2);
else
    spks = spks./max(spks,[],2);
end
spks = 2*(spks - 0.5);
new_spks = NaN(size(spks,1),uprate*size(spks,2));
for s = 1:size(spks,1)
    new_spks(s,:) = interp(spks(s,:),uprate);
end
spks = new_spks;
clear new_spks

hw = NaN(1,size(spks,1));
totalMissing = 0;

for s = 1:size(spks,1)
    inds = find(spks(s,:) >= 0);
    pre_inds = inds(inds < keypoint*uprate);
    post_inds = inds(inds > keypoint*uprate);
    if ~isempty(pre_inds) && ~isempty(post_inds)
        pre_ind = pre_inds(end);
        post_ind = post_inds(1);

        n = spks(s,pre_ind);
        m = spks(s,pre_ind+1);
        addition = n/(n-m);

        n = spks(s,post_ind);
        m = spks(s,post_ind-1);
        subtraction = n/(n-m);

        hw(s) = ((post_ind-subtraction) - (pre_ind+addition))/((Fs/1e3)*uprate);
    else
        if nargout >= 2
            totalMissing = totalMissing+1;
        else
            disp([9 'Couldn''t find FWHM for wave ' num2str(s)])
        end
    end
end