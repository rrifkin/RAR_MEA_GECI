function [] = view_caphys(Deltacal,RDchan,chan,Times,tstart,tend)
%view_caphys Allows the viewer to visualize both time series information
%extracted from the calcium imaging and blackrock recordings on the same
%axis on a channel by channel basis.
%   Input: Deltacal--> matrix with the change in intensities listed by
%   ELECTRODE.
%RDchan --> raw data for that channel obtained from the NS5 datafile
%channel of interest
%tstart and tend - period of interest in seconds
%Times = array of timestamps at which the calcium imaging frames were taken
%by the camera. Datapoints should be in seconds.


%Change the order of the deltacal input so it reflects the channel map as
%opposed to the electrode map. Failure to do this wound be upsetting to say
%the least.
Chancal(2,:)=Deltacal(1,:);
Chancal(4,:)=Deltacal(2,:);
Chancal(6,:)=Deltacal(3,:);
Chancal(8,:)=Deltacal(4,:);
Chancal(10,:)=Deltacal(5,:);
Chancal(12,:)=Deltacal(6,:);
Chancal(14,:)=Deltacal(7,:);
Chancal(16,:)=Deltacal(8,:);
Chancal(18,:)=Deltacal(9,:);
Chancal(20,:)=Deltacal(10,:);
Chancal(22,:)=Deltacal(11,:);
Chancal(24,:)=Deltacal(12,:);
Chancal(26,:)=Deltacal(13,:);
Chancal(28,:)=Deltacal(14,:);
Chancal(30,:)=Deltacal(15,:);
Chancal(32,:)=Deltacal(16,:);
Chancal(1,:)=Deltacal(17,:);
Chancal(3,:)=Deltacal(18,:);
Chancal(5,:)=Deltacal(19,:);
Chancal(7,:)=Deltacal(20,:);
Chancal(9,:)=Deltacal(21,:);
Chancal(11,:)=Deltacal(22,:);
Chancal(13,:)=Deltacal(23,:);
Chancal(15,:)=Deltacal(24,:);
Chancal(17,:)=Deltacal(25,:);
Chancal(19,:)=Deltacal(26,:);
Chancal(21,:)=Deltacal(27,:);
Chancal(23,:)=Deltacal(28,:);
Chancal(25,:)=Deltacal(29,:);
Chancal(27,:)=Deltacal(30,:);
Chancal(29,:)=Deltacal(31,:);
Chancal(31,:)=Deltacal(32,:);
Chancal(34,:)=Deltacal(33,:);
Chancal(36,:)=Deltacal(34,:);
Chancal(38,:)=Deltacal(35,:);
Chancal(40,:)=Deltacal(36,:);
Chancal(42,:)=Deltacal(37,:);
Chancal(44,:)=Deltacal(38,:);
Chancal(46,:)=Deltacal(39,:);
Chancal(48,:)=Deltacal(40,:);
Chancal(50,:)=Deltacal(41,:);
Chancal(52,:)=Deltacal(42,:);
Chancal(54,:)=Deltacal(43,:);
Chancal(56,:)=Deltacal(44,:);
Chancal(58,:)=Deltacal(45,:);
Chancal(60,:)=Deltacal(46,:);
Chancal(62,:)=Deltacal(47,:);
Chancal(64,:)=Deltacal(48,:);
Chancal(33,:)=Deltacal(49,:);
Chancal(35,:)=Deltacal(50,:);
Chancal(37,:)=Deltacal(51,:);
Chancal(39,:)=Deltacal(52,:);
Chancal(41,:)=Deltacal(53,:);
Chancal(43,:)=Deltacal(54,:);
Chancal(45,:)=Deltacal(55,:);
Chancal(47,:)=Deltacal(56,:);
Chancal(49,:)=Deltacal(57,:);
Chancal(51,:)=Deltacal(58,:);
Chancal(53,:)=Deltacal(59,:);
Chancal(55,:)=Deltacal(60,:);
Chancal(57,:)=Deltacal(61,:);
Chancal(59,:)=Deltacal(62,:);
Chancal(61,:)=Deltacal(63,:);
Chancal(63,:)=Deltacal(64,:);
Chancal(66,:)=Deltacal(65,:);
Chancal(68,:)=Deltacal(66,:);
Chancal(70,:)=Deltacal(67,:);
Chancal(72,:)=Deltacal(68,:);
Chancal(74,:)=Deltacal(69,:);
Chancal(76,:)=Deltacal(70,:);
Chancal(78,:)=Deltacal(71,:);
Chancal(80,:)=Deltacal(72,:);
Chancal(82,:)=Deltacal(73,:);
Chancal(84,:)=Deltacal(74,:);
Chancal(86,:)=Deltacal(75,:);
Chancal(88,:)=Deltacal(76,:);
Chancal(90,:)=Deltacal(77,:);
Chancal(92,:)=Deltacal(78,:);
Chancal(94,:)=Deltacal(79,:);
Chancal(96,:)=Deltacal(80,:);
Chancal(65,:)=Deltacal(81,:);
Chancal(67,:)=Deltacal(82,:);
Chancal(69,:)=Deltacal(83,:);
Chancal(71,:)=Deltacal(84,:);
Chancal(73,:)=Deltacal(85,:);
Chancal(75,:)=Deltacal(86,:);
Chancal(77,:)=Deltacal(87,:);
Chancal(79,:)=Deltacal(88,:);
Chancal(81,:)=Deltacal(89,:);
Chancal(83,:)=Deltacal(90,:);
Chancal(85,:)=Deltacal(91,:);
Chancal(87,:)=Deltacal(92,:);
Chancal(89,:)=Deltacal(93,:);
Chancal(91,:)=Deltacal(94,:);
Chancal(93,:)=Deltacal(95,:);
Chancal(95,:)=Deltacal(96,:);

%Identify channel of interest
cachan = Chancal(chan,:);

%Identify the calcium imaging data relevant to that time period for that
%channel
%1. find the timestamps
ts = find(Times > tstart & Times < tend);
% find the calcium imaging data for that period
a = numel(ts);
b = ts(1);
c = ts(a);
cachan=cachan';
cachan_tdata = cachan([b:c],:);

%create array with timestamps which correlate to cachan_tdata variable
times_cachan = Times([b:c],:);
times_cachan=times_cachan';

%Bring in the time period of interest and downsample appropriately
%2-50Hz bandpass filter
[b_lp50, a_lp50] = fir1(512,[2,50]/(30000/2));
%500-5kHz bandpass filter
[b_lp5k, a_lp5k] = fir1(512,[500,5000]/(30000/2));
%Obtain 2-50Hz bandpass filter data
freq50 = filtfilt(b_lp50, a_lp50, RDchan);
%Obtain 500-5kHz bandpass filter data
freq5k = filtfilt(b_lp5k, a_lp5k, RDchan);
%time issues
t1 = tstart*30000;
t2 = tend*30000;
fl=freq50';
fh=freq5k';
lc = linspace(1,(length(fl)),(length(fl)));
lc=lc';
tr = find(lc > t1 & lc < t2);
d = numel(tr);
e = tr(1);
f = tr(d);
fl = fl([e:f],:);
fh = fh([e:f],:);

%for plotting purposes add 1000 to the multiunit band
fh = fh+1000;

%Create length constant for ephys data
lc2 = linspace(tstart, tend, (length(fl)));
lc3 = linspace(tstart, tend, (length(fh)));

%plot data
figure;
yyaxis left
plot(lc2, fl,'LineWidth',2); 
hold on;
plot(lc3, fh, '-k'); 
hold on; 
yyaxis right
plot(times_cachan,cachan_tdata,'LineWidth',2);
end

