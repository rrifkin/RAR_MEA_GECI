function worstZS = TheLibrary_SingleMatrix(wvs, allMu, allSD)
% Takes a single matrix of waveforms, or can be used by helper function to
% iterate through a number of spikes


worstZS = zeros(1, size(wvs, 1));
for i = 1:size(wvs,1)
    wv = zscore(wvs(i,:));
    wv_tiled = repmat(wv, size(allMu, 1), 1);
    
    thisProb = (wv_tiled - allMu) ./ allSD;
    worstZS(i) = min(max(abs(thisProb), [], 2));
end



end
