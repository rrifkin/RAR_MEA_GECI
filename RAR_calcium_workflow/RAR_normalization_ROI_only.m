function RAR_normalization_ROI_only (metadata_file, raw_acsf, raw_zmg)

	FullRecord = horzcat(raw_acsf,raw_zmg);  %combining the raw ACSF and ZMG raw matrices into one

	mmx = movmean(FullRecord,[125 125],2); %using a sliding window 125 frames before/after to create normalization matrix

	mmxRecord = rdivide(FullRecord,mmx); %normalizing row by row

	Delta_eleccal = mmxRecord(:,15001:105000); %selecting for just the ZMG portion

	% So now you have your finalized matrix, but now we need the times that each frame was obtained:

	[~,Times] = cal_times(metadata_file); 
	%extracting times from the metadata file
	Times_sec = Times/1000;  %convert to seconds

	save('normalized_ROI.mat','Delta_eleccal');
	save('times_ROI.mat', 'Times_sec');

end