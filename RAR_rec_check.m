[b_lp50, a_lp50] = fir1(512,[500,1000]/(2000/2));
freq50 = filtfilt(b_lp50, a_lp50,LFP(51,1:3600000));
lc_ts = linspace(1,1800, 3600000);
figure; plot(lc_ts,LFP(51,:))