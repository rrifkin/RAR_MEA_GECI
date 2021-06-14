function [meanAClag,alt] = meanAClag(spiketimes,maxLag,Fs)

if nargin < 2 || isempty(maxLag)
    maxLag = 50;
end
if nargin < 3 || isempty(Fs)
    Fs = 3e4;
end

maxLag = maxLag/1000;
[cross,lags] = ss_autocorr(spiketimes,[],Fs,1);
cross(lags < 0) = [];
lags(lags < 0) = [];
lags = lags * 1000; % output of ss_autocorr is in seconds

meanAClag = sum(lags.*cross)/sum(cross);
% or... (i think this is wrong)
%{
total = 0;

for b = 1:length(lags)
    total = total + (lags(b) * cross(b));
end
meanAClag = total/length(lags);
%}
% or... (possibly more accurate?)
ac = [];
for n = 1:length(spiketimes)
    within = spiketimes(spiketimes >= spiketimes(n) - maxLag & spiketimes <= spiketimes(n) + maxLag);
    for nn = 1:length(within)
        if within(nn) ~= spiketimes(n)
            ac = [ac within(nn)-spiketimes(n)];
        end
    end
end
ac(ac < 0) = [];
ac = ac*1000; % into millseconds
alt = mean(ac);