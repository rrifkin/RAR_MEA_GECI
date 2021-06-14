function [ freq50, freq5k ] = BJAG_filt(COI, start, finish)
%UNTITLED2 Takes the undownsampled 30kHz data and using bandpass filters
%creates a 2-50Hz and 500-5000Hz data for futher analysis.
%   Input: channel of interest from NS5 data

%2-50Hz bandpass filter
[b_lp50, a_lp50] = fir1(512,[2,50]/(30000/2));
%500-5kHz bandpass filter
[b_lp5k, a_lp5k] = fir1(512,[500,5000]/(30000/2));
%Obtain 2-50Hz bandpass filter data
freq50 = filtfilt(b_lp50, a_lp50, COI);
%Obtain 500-5kHz bandpass filter data
freq5k = filtfilt(b_lp5k, a_lp5k, COI);
%Create length constant
%lc = linspace(start, finish, (length(COI)));
%plot data
%figure;
%plot(lc, freq5k); 
%hold on; 
%plot(lc, freq50); 
%title({'Multi-Unit Activity vs Time'});xlabel({'Time', 'Seconds'}); ylabel({'Multi-Unit Activity'});legend('MUA(500-5kHz)');

end