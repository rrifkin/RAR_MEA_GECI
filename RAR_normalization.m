function RAR_normalization (metadata_file, raw_acsf, raw_zmg)

	FullRecord = horzcat(raw_acsf,raw_zmg);  %combining the raw ACSF and ZMG raw matrices into one

	mmx = movmean(FullRecord,[125 125],2); %using a sliding window 125 frames before/after to create normalization matrix

	mmxRecord = rdivide(FullRecord,mmx); %normalizing row by row

	Delta_eleccal = mmxRecord(:,15001:105000); %selecting for just the ZMG portion

	%So this gives you your normalized matrix, which is in terms of electrode numbers. If you want to correlate with ephys, we have to order it in number of channels:

	final_product(2,:)=Delta_eleccal(1,:);
	final_product(4,:)=Delta_eleccal(2,:);
	final_product(6,:)=Delta_eleccal(3,:);
	final_product(8,:)=Delta_eleccal(4,:);
	final_product(10,:)=Delta_eleccal(5,:);
	final_product(12,:)=Delta_eleccal(6,:);
	final_product(14,:)=Delta_eleccal(7,:);
	final_product(16,:)=Delta_eleccal(8,:);
	final_product(18,:)=Delta_eleccal(9,:);
	final_product(20,:)=Delta_eleccal(10,:);
	final_product(22,:)=Delta_eleccal(11,:);
	final_product(24,:)=Delta_eleccal(12,:);
	final_product(26,:)=Delta_eleccal(13,:);
	final_product(28,:)=Delta_eleccal(14,:);
	final_product(30,:)=Delta_eleccal(15,:);
	final_product(32,:)=Delta_eleccal(16,:);
	final_product(1,:)=Delta_eleccal(17,:);
	final_product(3,:)=Delta_eleccal(18,:);
	final_product(5,:)=Delta_eleccal(19,:);
	final_product(7,:)=Delta_eleccal(20,:);
	final_product(9,:)=Delta_eleccal(21,:);
	final_product(11,:)=Delta_eleccal(22,:);
	final_product(13,:)=Delta_eleccal(23,:);
	final_product(15,:)=Delta_eleccal(24,:);
	final_product(17,:)=Delta_eleccal(25,:);
	final_product(19,:)=Delta_eleccal(26,:);
	final_product(21,:)=Delta_eleccal(27,:);
	final_product(23,:)=Delta_eleccal(28,:);
	final_product(25,:)=Delta_eleccal(29,:);
	final_product(27,:)=Delta_eleccal(30,:);
	final_product(29,:)=Delta_eleccal(31,:);
	final_product(31,:)=Delta_eleccal(32,:);
	final_product(34,:)=Delta_eleccal(33,:);
	final_product(36,:)=Delta_eleccal(34,:);
	final_product(38,:)=Delta_eleccal(35,:);
	final_product(40,:)=Delta_eleccal(36,:);
	final_product(42,:)=Delta_eleccal(37,:);
	final_product(44,:)=Delta_eleccal(38,:);
	final_product(46,:)=Delta_eleccal(39,:);
	final_product(48,:)=Delta_eleccal(40,:);
	final_product(50,:)=Delta_eleccal(41,:);
	final_product(52,:)=Delta_eleccal(42,:);
	final_product(54,:)=Delta_eleccal(43,:);
	final_product(56,:)=Delta_eleccal(44,:);
	final_product(58,:)=Delta_eleccal(45,:);
	final_product(60,:)=Delta_eleccal(46,:);
	final_product(62,:)=Delta_eleccal(47,:);
	final_product(64,:)=Delta_eleccal(48,:);
	final_product(33,:)=Delta_eleccal(49,:);
	final_product(35,:)=Delta_eleccal(50,:);
	final_product(37,:)=Delta_eleccal(51,:);
	final_product(39,:)=Delta_eleccal(52,:);
	final_product(41,:)=Delta_eleccal(53,:);
	final_product(43,:)=Delta_eleccal(54,:);
	final_product(45,:)=Delta_eleccal(55,:);
	final_product(47,:)=Delta_eleccal(56,:);
	final_product(49,:)=Delta_eleccal(57,:);
	final_product(51,:)=Delta_eleccal(58,:);
	final_product(53,:)=Delta_eleccal(59,:);
	final_product(55,:)=Delta_eleccal(60,:);
	final_product(57,:)=Delta_eleccal(61,:);
	final_product(59,:)=Delta_eleccal(62,:);
	final_product(61,:)=Delta_eleccal(63,:);
	final_product(63,:)=Delta_eleccal(64,:);
	final_product(66,:)=Delta_eleccal(65,:);
	final_product(68,:)=Delta_eleccal(66,:);
	final_product(70,:)=Delta_eleccal(67,:);
	final_product(72,:)=Delta_eleccal(68,:);
	final_product(74,:)=Delta_eleccal(69,:);
	final_product(76,:)=Delta_eleccal(70,:);
	final_product(78,:)=Delta_eleccal(71,:);
	final_product(80,:)=Delta_eleccal(72,:);
	final_product(82,:)=Delta_eleccal(73,:);
	final_product(84,:)=Delta_eleccal(74,:);
	final_product(86,:)=Delta_eleccal(75,:);
	final_product(88,:)=Delta_eleccal(76,:);
	final_product(90,:)=Delta_eleccal(77,:);
	final_product(92,:)=Delta_eleccal(78,:);
	final_product(94,:)=Delta_eleccal(79,:);
	final_product(96,:)=Delta_eleccal(80,:);
	final_product(65,:)=Delta_eleccal(81,:);
	final_product(67,:)=Delta_eleccal(82,:);
	final_product(69,:)=Delta_eleccal(83,:);
	final_product(71,:)=Delta_eleccal(84,:);
	final_product(73,:)=Delta_eleccal(85,:);
	final_product(75,:)=Delta_eleccal(86,:);
	final_product(77,:)=Delta_eleccal(87,:);
	final_product(79,:)=Delta_eleccal(88,:);
	final_product(81,:)=Delta_eleccal(89,:);
	final_product(83,:)=Delta_eleccal(90,:);
	final_product(85,:)=Delta_eleccal(91,:);
	final_product(87,:)=Delta_eleccal(92,:);
	final_product(89,:)=Delta_eleccal(93,:);
	final_product(91,:)=Delta_eleccal(94,:);
	final_product(93,:)=Delta_eleccal(95,:);
	final_product(95,:)=Delta_eleccal(96,:);
	
	% So now you have your finalized matrix, but now we need the times that each frame was obtained:

	%metadata_file = strcat (name_of_slice, '_zmg_1_MMStack_Pos0_metadata.txt') ;
	[~,Times] = cal_times(metadata_file); 
	%extracting times from the metadata file
	Times_sec = Times/1000;  %convert to seconds

	save('normalized_spikes.mat','final_product');
	save('spike_times.mat', 'Times_sec');

	% plot
	plot(Times_sec, final_product);
	ylim([1 2]);
	y = 1.8;
	line([901,1800],[y,y]);
	saveas(gcf,'output.pdf')

end