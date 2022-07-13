% This file downsample from 30K sampled data (NS5) & detect MUA.
% Input: NSx file
%        Optional inputs - Please read the input parser part of the code
% Output: Downsampled data
%         Spike train timestamps & waveforms
% Summary of algorithm for dowmsampling
%    1) The original data is low-pass filtered
%    2) Sample 1 point for every Fs/Fi points
% Summary of algorithm for MUA spike detection
%    1) The original 30K-sampled data is band-pass filtered 
%    2) Pick up the time stamps where the filtered data
%       a) We prefer to use a baseline recording to calculate standard
%          deviation of the signal. (file.full.baseline);  If it is empty,
%          signal rms would be calculated from the seizure_recording
%       b) falls over -4 standard deviation (modifiable)
%       c) have an inflection (anti-peak)
%       d) does not have another spike detected within refractory period
%       e) does not fulfill artifact rejection criteria 
% To adjust the spike detection algorithm parameters, please see the code
% 'MUA' part.
%
% Author: Jyun-you Liou, final update: 2015/07/23
%
% Notice: The relation of analog unit and digital signal unit under gain=1.
% is not 1uV to 1unit.  It's actually 0.25 uV to 1 unit!  Be aware of the
% scaling problem
% 
function [mua_data, seizure_downsampled] = DownSamplingAndDetectMUA(varargin)
p = inputParser;
% --- Data source ---
addParameter(p,'baseline_recording',[]);
addParameter(p,'seizure_recording',[]);
addParameter(p,'T',[]); % Options: Empty - ask the user range of processing
                        %          0 - process all data
                        %          [T_start T_end] - process a this range
                        % Unit: second
% --- Function switches ---
% You can only use either MUA spike detection or downsampling function
% alone by adjusting these switches
addParameter(p,'Downsampling_switch',1);
addParameter(p,'MUA_detection_swtich',1);
addParameter(p,'Realtime_spike_monitor_switch',1);
                                % switch if you want to see detected
                                % waveforms in real time; this may
                                % slow down this program's performance
% --- Downsampling settings ---
addParameter(p,'Fi',2000); % Down-sampling frequency
% --- MUA detection settings ---
addParameter(p,'T_baseline',[0 60]); % Baseline range, used only if no 
                                    % separated baseline file is given
                                    % Unit: sec
addParameter(p,'rms_estimation','median'); 
       % Methods to estimate background noise root mean square
       % Options: 'std' - simple take std of the baseline recording
       %          'median' - rms will be estimated as median{abs(x)/0.6745}
       %                     ref: Neural Comput. 2004 Aug;16(8):1661-87.
                                        
% --- Save file setting ---
addParameter(p,'savefile','savename'); 
% --- Others ---
addParameter(p,'AD_factor',1); % The default unit in uV in integer format 
                               % if NSx file doesn't provide this information
                               % After 2013, this should be 0.25 and NSx
                               % file has this information.  Before 2012,
                               % it should be 1.
parse(p,varargin{:});

%% Get input file (GUI) if necessary
if p.Results.baseline_recording
    file.full.baseline_recording = p.Results.baseline_recording;
else
    [file.name.baseline_recording,file.path.baseline_recording] = uigetfile('.ns5','Please select the baseline recording NSx file');
    file.full.baseline_recording = [file.path.baseline_recording file.name.baseline_recording];
end
if p.Results.seizure_recording
    file.full.seizure_recording = p.Results.seizure_recording;
else
    [file.name.seizure_recording,file.path.seizure_recording] = uigetfile('.ns5','Please select the seizure recording NSx file');
    file.full.seizure_recording = [file.path.seizure_recording file.name.seizure_recording];
end

%% Low the head of the recording file
NSx = openNSx('report','noread',file.full.seizure_recording);
N_channel = 96; % The number of channels of this recording
Total_time = NSx.MetaTags.DataDurationSec; % unit: second
Fs = NSx.MetaTags.SamplingFreq; % Original sampling frequency 
display(['This experiment is ' num2str(Total_time) ' seconds long with ' num2str(N_channel) ' channels.']);

%% Select the range of data to be processed
if isempty(p.Results.T)
    if input('Only process a subset of the original data? (1=Select subset of data, 0=Select all data)')
        T(1) = input('Please enter the start time in second. ');
        T(2) = input('Please enter the end time in second. ');  
    else
        T = [];
    end
elseif ~p.Results.T
    T = [];
else
    T = p.Results.T;
end


%% Downsampling parameters & recording variables
Fi = p.Results.Fi;  % Down-sampling frequency
seizure_downsampled = cell(N_channel,1); % Output cell for 2K downsampling
DSFilter = fir1(100,Fi/(Fs/2)); % Build the vector to contruct band-pass filter

%% MUA detection parameters & recording variables
% We recorded the waveform of detected spike and, Waveform_range is the
% parameter that determines the duration of the original signal is picked.
% unit: millisecond
waveform_range = [-0.6 1]; % unit: millisecond
waveform_range = int32(floor(Fs*waveform_range(1)/1000)):int32(floor(Fs*waveform_range(2)/1000)); % convert millisecond to sample
% Create an output structure for further MUA spike analysis
mua_data.filter.band = [500 5000]; % unit: Hz
mua_data.filter.order = 512; % unit: order
mua_data.filter.type = 'fir1'; 
mua_data.artifact_rejection_threshold = [-100 100]; % unit: microvolt
mua_data.detection_threshold = -5.0; % unit: standard deviation
mua_data.Absolute_refractory_period = 1; % unit: millisecond
mua_data.nchannels = N_channel;
mua_data.fs = Fs;
mua_data.baseline_rms = cell(N_channel,1);
mua_data.baseline_rms_method = p.Results.rms_estimation;
mua_data.timestamps = cell(N_channel,1);
mua_data.waveforms = cell(N_channel,1);
mua_data.nspikes = zeros(N_channel,1);
mua_data.baseline_file = file.full.baseline_recording;
mua_data.seizure_file = file.full.seizure_recording;
mua_data.range_of_data = T;
mua_data.ElectrodeInfo = struct2table(NSx.ElectrodesInfo);
mua_data.MetaTags = NSx.MetaTags;
mua_data.Channel_ID = mua_data.ElectrodeInfo.ElectrodeID;
% Construct the band pass filter
MUAFilter = fir1(mua_data.filter.order,mua_data.filter.band/(Fs/2)); % Build the vector to contruct band-pass filter

%% Baseline setting
% For situation you don't have a seperated baseline recording
if or(~file.full.baseline_recording,strcmp(file.full.baseline_recording,file.full.seizure_recording))
    disp('No seperated baseline recording found.');
    disp(['The seizure recording from ' num2str(p.Results.T_baseline(1)) ' to ' num2str(p.Results.T_baseline(2)) ' second will be used as baseline.']);
end
baseline_text = ['t:' num2str(p.Results.T_baseline(1)) ':' num2str(p.Results.T_baseline(2))];

%% Working Code
for i = 1:N_channel
    %% Preliminary step, obtain information from baseline
    tic;    
    display(['Opening channel ' num2str(i) ' for baseline rms calculation']); 
    NSx = openNSx(file.full.baseline_recording, ...
           ['c:' num2str(i)], ...
           baseline_text,'sec', ...
           'p:double');
    % Convert digital unit into analog unit (microV)
    try
        AD_factor = (double(NSx.ElectrodesInfo(1).MaxAnalogValue) - double(NSx.ElectrodesInfo(1).MinAnalogValue)) ... 
                  /(double(NSx.ElectrodesInfo(1).MaxDigiValue) - double(NSx.ElectrodesInfo(1).MinDigiValue)); 
    catch
        AD_factor = p.Results.AD_factor;
    end
    NSx.Data = NSx.Data * AD_factor; % AD_factor: the ratio between analog signal and digitized signal
    baseline_band_pass_filtered = filtfilt(MUAFilter,1,NSx.Data);
    switch p.Results.rms_estimation
        case 'std'
            std_baseline = std(baseline_band_pass_filtered);
        case 'median'
            std_baseline = median(abs(baseline_band_pass_filtered)/0.6745);
    end
    display(['Channel ' num2str(i) ' has baseline rms ' num2str(std_baseline) ' uV']); 
    mua_data.baseline_rms{i} = std_baseline;
    toc;
    
    %% Analyze the recorded signals
    % First, load the data from the original NSx file 
    tic; 
    display(['Opening channel ' num2str(i) ' for downsampling / spike detection.']);
    if isempty(T)
        NSx = openNSx(file.full.seizure_recording, ...
                      ['c:' num2str(i)], ...
                      'p:double');  
    else
        NSx = openNSx(file.full.seizure_recording, ...
                      ['c:' num2str(i)], ...
                      ['t:' num2str(T(1)) ':' num2str(T(2))],'sec', ...
                      'p:double');     
    end
    % Convert digital unit into analog unit (microV)
    try
        AD_factor = (double(NSx.ElectrodesInfo(1).MaxAnalogValue) - double(NSx.ElectrodesInfo(1).MinAnalogValue)) ... 
                  /(double(NSx.ElectrodesInfo(1).MaxDigiValue) - double(NSx.ElectrodesInfo(1).MinDigiValue)); 
    catch
        AD_factor = p.Results.AD_factor;
    end
    NSx.Data = NSx.Data * AD_factor;
    toc;
        
    % [Downsampling part]: Down filter the signal and then down sample it 
    if p.Results.Downsampling_switch
        tic;
        disp(['Down-filtering&sampling channel ' num2str(i)]);     
        seizure_downfiltered = filtfilt(DSFilter,1,NSx.Data); 
        seizure_downsampled{i} = seizure_downfiltered(1,1:(Fs/Fi):end);
        toc;
    end;

    % [MUA spike detection part]: 
    if p.Results.MUA_detection_swtich
        % Step-1: Band-pass filter the signal  
        tic;
        disp(['Band-pass-filtering channel ' num2str(i) ' for spike detection']);
        seizure_band_pass_filtered = filtfilt(MUAFilter,1,NSx.Data);
        toc;
        % Step-2: Detect spikes by 3 parameters: 
        %         1) DETECTION_THRESHOLD, unit: standard deviation
        %         2) ARTIFACT_THRESHOLD, unit: standard deviation
        %         3) Absolute_refractory_period, unit: millisecond
        tic;
        display(['Detecting spikes at channel ' num2str(i)]);
        % Step 2-1: spike detection & 2-3, Absolute_refractory_period
        [spike_voltage,spike_address] = findpeaks(-seizure_band_pass_filtered, ...
                                                     'minpeakheight',std_baseline*(-mua_data.detection_threshold), ...
                                                     'minpeakdistance',mua_data.Absolute_refractory_period*Fs/1000);
        spike_voltage = -spike_voltage; % correct back the true voltage, unit: mV                               
        if isempty(spike_address);continue;end; % if no spike is detect, proceed to next round of for loop
        % Step 2-2: Reject artifacts.
        %      Part A: Reject the peak below lower limit of artifact criteria.
        spike_address = nonzeros(spike_address .* (spike_voltage>min(mua_data.artifact_rejection_threshold)));  
        %      Part B: Reject if there is any nearby recording beyond artifact upper criteria
        for k = 1:length(spike_address)
            waveform_address = spike_address(k) + waveform_range;
            if all([(waveform_address>0) (waveform_address<length(seizure_band_pass_filtered))]) 
                                              % only check those waveforms which all nearby sampling spots exist
                current_waveform = seizure_band_pass_filtered(waveform_address);
                if any(current_waveform > max(mua_data.artifact_rejection_threshold))
                    spike_address(k) = 0; % if there is anything beyound upper limit, delete and don't save this waveform.
                else
                    mua_data.waveforms{i} = [mua_data.waveforms{i};seizure_band_pass_filtered(waveform_address)];
                                              % if there is nothing beyound upper limit, save this waveform.
                end    
            else
                mua_data.waveforms{i} = [mua_data.waveforms{i};zeros(1,length(waveform_address))]; 
                                              % If there is not enough nearby spots can be checked, just put its
                                              % waveform = all zero.                                            
            end
        end
        spike_address = nonzeros(spike_address); % Squeeze out those deleted data (0)
        mua_data.timestamps{i} = spike_address/Fs; % unit: second     

        % Step-3: Plot the detection quality in real time
        %if p.Results.Realtime_spike_monitor_switch
            %close;clear h;
            %h = figure('Units','Normalized','Position',[1/3 0.1 1/3 0.8]);
            %if ~isempty(mua_data.waveforms{i})
                %T_local_grid = double(waveform_range)/Fs*1000;
                %subplot(3,1,1),
                %plot(T_local_grid,mua_data.waveforms{i},'k');drawnow; % Raw trace
                %title(['Channel ' num2str(i) ' waveform detected']);
                %ylabel('uV');
                %ylim([-60 30]);
                %subplot(3,1,2),
                %mu_waveform = mean(mua_data.waveforms{i},1);
                %sig_waveform = std(mua_data.waveforms{i},0,1);
                %plot(T_local_grid,mu_waveform);drawnow;hold on; % Mean
                %plot(T_local_grid,mu_waveform+sig_waveform,'y');drawnow;hold on; % Mean + std
                %plot(T_local_grid,mu_waveform-sig_waveform,'y');drawnow;hold on; % Mean - std
                %ylabel('uV');                
                %subplot(3,1,3), % Monitor interspike interval
                %hist(diff(mua_data.timestamps{i}*1000),0:5:500);
                %xlim([0,500]);drawnow;
                %xlabel('Millisecond');
                %title('Interspike interval');
            %end
        %end
    end

end
seizure_downsampled = cell2mat(seizure_downsampled);
mua_data.nspikes = cellfun(@(x) length(x),mua_data.timestamps);
if p.Results.Downsampling_switch
    save(['LFPDownSampled' p.Results.savefile '.mat'],'seizure_downsampled','-v7.3');
end
if p.Results.MUA_detection_swtich
    save(['MUAData' p.Results.savefile '.mat'],'mua_data','-v7.3');
end