function RAR_downsample (slice_acsf, slice_zmg)

	output_acsf = DownSamplingAndDetectMUA('seizure_recording', slice_acsf, 'baseline_recording', slice_acsf,'T', [0 300],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', 'output_acsf');
	output_zmg = DownSamplingAndDetectMUA('seizure_recording', slice_zmg, 'baseline_recording', slice_acsf,'T', [0 1800],'T_baseline',[0 60], 'rms_estimation', 'median', 'savefile', 'output_zmg');

end