[B, A] = uigetfile('*.ns5');
slice_zmg = [A B];

[B, A] = uigetfile('*.ns5');
slice_acsf = [A B];

slice_zmg = DownSamplingAndDetectMUA('seizure_recording', slice_zmg, 'baseline_recording', slice_acsf,'T', [0 1800],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', 'slice_zmg');
slice_acsf = DownSamplingAndDetectMUA('seizure_recording', slice_acsf, 'baseline_recording', slice_acsf,'T', [0 300],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', 'slice_acsf');