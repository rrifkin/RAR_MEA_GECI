function [fintable] = ca_meacomp(Deltaint,LFP,mua,tstart,tend)
%ca_meacomp Compares the line length of the channels delta F calcium trace,
%to the line length of the LFP and number of units during the same period.
%Or at the very least produces a table with of that information.
%tstart and tend are in seconds
%   

%Calcium line length
ca_ll = [];
for i = 1:96;
    x= abs(diff(Deltaint(i,:),1,2));
    x(:,end+1) = 0;
    ca_ll(i,:) = x;
    i=i+1;
end
meanca_ll = mean(ca_ll,2);

%Obtain segment of LFP of interest from 2k downsample data
A = tstart*2000;
B = tend*2000;
LFP = LFP(:,A:B);

%2-50Hz bandpass filter for the 2KHz data
[b_lp50, a_lp50] = fir1(256,[2,50]/(2000/2));
freq50 = [];

%2-50Hz LFP line length
meanlfp_ll = [];
for i = 1:96;
    %Obtain 2-50Hz bandpass filter data
    freq50 = filtfilt(b_lp50, a_lp50,LFP(i,1:end));
    x= abs(diff(freq50,1,2));
    x(:,end+1) = 0;
    mean_x = mean(x);
    meanlfp_ll(i,:) = mean_x;
    i=i+1;
end

% number of units detects during period of interest
C = tend-tstart;
for i=1:96;
    D = mua.timestamps{i,1};
    E = find(D > tstart & D < tend);
    F = length(E)/C;
    chan_fr(i,:) = F;
end

fintable = [meanca_ll,meanlfp_ll,chan_fr];



end

