function [spks,spkt] = extract_spks(locs,mua,spkwin)
if nargin < 3 || isempty(spkwin)
    spkwin = -18:30;
end

locs(locs < (-spkwin(1)+1) | locs > length(mua)-spkwin(end)) = [];
spks = zeros(length(locs),length(spkwin));
for p = 1:length(locs)
    spks(p,:) = mua(locs(p)+spkwin);
end
spkt = locs/3e4;