%% Go from raw NS5 file to spikes structs in files:
raw = openNSx('/mnt/mfs/home/NIMASTER/fak2121/Raw Data/FK_10_21_CTL_Non_Treated/slice3/slice3_zmg.ns5');
if iscell(raw.Data) % paused files introduce multiple cells
    raw.Data = cell2mat(raw.Data(2:end)); % keep all but the first syncing cell
end

badChans = [];
if size(raw.Data,1) > 96 % only keep the actual channels if extra analog inputs were recorded
    raw.Data = raw.Data(1:96,:);
end
mnData = mean(double(raw.Data(setdiff(1:96,badChans),:))); % calculate the mean of the good channels
raw.Data = double(raw.Data) - mnData;
Fs = raw.MetaTags.SamplingFreq;
[b,a] = fir1(1024,[300 5000]/(Fs/2)); % 1024th order FIR bandpass between 300 & 5,000 Hz

% go through each channel, extracting and saving the spikes struct each
% time:
for c = 1:size(raw.Data,1)
    disp([9 'Working on channel ' num2str(c) ' of ' num2str(size(raw.Data,1))])
    %mua = filtfilt(b,a,double(raw.Data(c,:)) - mnData);
    mua = filtfilt(b,a,double(raw.Data(c,:)));
    % if the ns5 file was version 2.3, need to divide by scale for raw uV:
    if isfield(raw,'ElectrodesInfo')
        scaling = raw.ElectrodesInfo(c).MaxDigiValue / raw.ElectrodesInfo(c).MaxAnalogValue;
        mua = mua./double(scaling);
    end

    spikes = ss_default_params(Fs);
    spikes = ss_detect_emerix(mua',spikes);

    if ~isfield(spikes,'waveforms') || size(spikes.waveforms,1) < 20
        disp([9 'Not enough spikes, skipping channel'])
    elseif size(spikes.waveforms,1) > 200*(length(mua)/3e4)
        disp([9 'Too many spikes, skipping channel (' num2str(size(spikes.waveforms,1)/(length(mua)/3e4)) ' per second)'])
    else
        opts.progress = 0;
        spikes = ss_kmeans(spikes,opts);
        spikes = ss_energy(spikes,true);
        spikes = ss_aggregate(spikes,[],true);
        % SAVE!
        save(['/mnt/mfs/home/NIMASTER/fak2121/ProcessedSorting/102120/CM4S3_ZMG/channel' num2str(c) '.mat'],'spikes')
    end
    clear mua spikes
end


%% Now the manual stage:
app = SplitMerge('Directory','path/to/this/session');
app = SplitMerge('Width', 1440, 'Height', 775, 'TreeWidth', 250, 'Directory','/mnt/mfs/home/NIMASTER/fak2121/ProcessedSorting/100219/EG4S3_ACSF_reref');