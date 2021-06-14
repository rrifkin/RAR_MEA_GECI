%
filename = 'slice2_acsf_1_MMStack_Pos0_7.ome.tif';
info = imfinfo(filename);
numframe = length(info);
for K = 1 : numframe
    rawframes(:,:,:,K) = imread(filename, K);
end
cookedframes = mat2gray(rawframes);
implay(cookedframes)
%
FullRecord = horzcat(t1s3_acsf,t1s3_zmg);
MeanFullRecord = mean(FullRecord, 2);
adj_t7s5_zmg = bsxfun(@rdivide,t7s5_zmg,MeanFullRecord);
%
[Frame,Times] = cal_times('slice4_zmg_1_MMStack_Pos0_metadata.txt');
Times = Times/1000;

%openNSx('read','report','c:97'); 
%expt_duration =

openNSx('read', 'c:97','t:0:1800','sec', 'p:double');
cm4s1_c97_pi = NS5.Data;
[c97_50_pi, c97_5k_pi] = BJAG_filt(cm4s1_c97_pi,0,1800);

tend_secs_pi = length(c97_5k_pi)/(30000); 
lc_cm4s1 = linspace(0,tend_secs_pi,length(c97_5k_pi));
figure; plot(lc_cm4s1,c97_5k_pi)

cam_time_500_5k  = cursor_info.Position(1);
cam_deltaT = Times_sec(1) - cam_time_500_5k;
adj_cm4s1_zmg_times = Times_sec - cam_deltaT;
%
pi_int_0 = chan_intensity('_1_MMStack_Pos0.ome.tif',r,2040,Eleclocs);
pi_int_1 = chan_intensity('_1_MMStack_Pos0_1.ome.tif',r,2040,Eleclocs);
pi_int_2 = chan_intensity('_1_MMStack_Pos0_2.ome.tif',r,2040,Eleclocs);
pi_int_3 = chan_intensity('_1_MMStack_Pos0_3.ome.tif',r,2040,Eleclocs);
pi_int_4 = chan_intensity('_1_MMStack_Pos0_4.ome.tif',r,2040,Eleclocs);
pi_int_5 = chan_intensity('_1_MMStack_Pos0_5.ome.tif',r,2040,Eleclocs);
pi_int_6 = chan_intensity('_1_MMStack_Pos0_6.ome.tif',r,2040,Eleclocs);
pi_int_7 = chan_intensity('_1_MMStack_Pos0_7.ome.tif',r,2040,Eleclocs);
pi_int_8 = chan_intensity('_1_MMStack_Pos0_8.ome.tif',r,2040,Eleclocs);
pi_int_9 = chan_intensity('_1_MMStack_Pos0_9.ome.tif',r,2040,Eleclocs);
pi_int_10 = chan_intensity('_1_MMStack_Pos0_10.ome.tif',r,2040,Eleclocs);
pi_int_11 = chan_intensity('_1_MMStack_Pos0_11.ome.tif',r,2040,Eleclocs);
pi_int_12 = chan_intensity('_1_MMStack_Pos0_12.ome.tif',r,2040,Eleclocs);
pi_int_13 = chan_intensity('_1_MMStack_Pos0_13.ome.tif',r,2040,Eleclocs);
pi_int_14 = chan_intensity('_1_MMStack_Pos0_14.ome.tif',r,2040,Eleclocs);
pi_int_15 = chan_intensity('_1_MMStack_Pos0_15.ome.tif',r,2040,Eleclocs);
pi_int_16 = chan_intensity('_1_MMStack_Pos0_16.ome.tif',r,2040,Eleclocs);
pi_int_17 = chan_intensity('_1_MMStack_Pos0_17.ome.tif',r,2040,Eleclocs);
pi_int_18 = chan_intensity('_1_MMStack_Pos0_18.ome.tif',r,2040,Eleclocs);
pi_int_19 = chan_intensity('_1_MMStack_Pos0_19.ome.tif',r,2040,Eleclocs);
pi_int_20 = chan_intensity('_1_MMStack_Pos0_20.ome.tif',r,2040,Eleclocs);
pi_int_21 = chan_intensity('_1_MMStack_Pos0_21.ome.tif',r,2040,Eleclocs);
pi_int_22 = chan_intensity('_1_MMStack_Pos0_22.ome.tif',r,2040,Eleclocs);
pi_int_23 = chan_intensity('_1_MMStack_Pos0_23.ome.tif',r,2040,Eleclocs);
pi_int_24 = chan_intensity('_1_MMStack_Pos0_24.ome.tif',r,2040,Eleclocs);
pi_int_25 = chan_intensity('_1_MMStack_Pos0_25.ome.tif',r,2040,Eleclocs);
pi_int_26 = chan_intensity('_1_MMStack_Pos0_26.ome.tif',r,2040,Eleclocs);
pi_int_27 = chan_intensity('_1_MMStack_Pos0_27.ome.tif',r,2040,Eleclocs);
pi_int_28 = chan_intensity('_1_MMStack_Pos0_28.ome.tif',r,2040,Eleclocs);
pi_int_29 = chan_intensity('_1_MMStack_Pos0_29.ome.tif',r,2040,Eleclocs);
pi_int_30 = chan_intensity('_1_MMStack_Pos0_30.ome.tif',r,2040,Eleclocs);
pi_int_31 = chan_intensity('_1_MMStack_Pos0_31.ome.tif',r,2040,Eleclocs);
pi_int_32 = chan_intensity('_1_MMStack_Pos0_32.ome.tif',r,2040,Eleclocs);
pi_int_33 = chan_intensity('_1_MMStack_Pos0_33.ome.tif',r,2040,Eleclocs);
pi_int_34 = chan_intensity('_1_MMStack_Pos0_34.ome.tif',r,2040,Eleclocs);
pi_int_35 = chan_intensity('_1_MMStack_Pos0_35.ome.tif',r,2040,Eleclocs);
pi_int_36 = chan_intensity('_1_MMStack_Pos0_36.ome.tif',r,2040,Eleclocs);
pi_int_37 = chan_intensity('_1_MMStack_Pos0_37.ome.tif',r,2040,Eleclocs);
pi_int_38 = chan_intensity('_1_MMStack_Pos0_38.ome.tif',r,2040,Eleclocs);
pi_int_39 = chan_intensity('_1_MMStack_Pos0_39.ome.tif',r,2040,Eleclocs);
pi_int_40 = chan_intensity('_1_MMStack_Pos0_40.ome.tif',r,2040,Eleclocs);
pi_int_41 = chan_intensity('_1_MMStack_Pos0_41.ome.tif',r,2040,Eleclocs);
pi_int_42 = chan_intensity('_1_MMStack_Pos0_42.ome.tif',r,2040,Eleclocs);
pi_int_43 = chan_intensity('_1_MMStack_Pos0_43.ome.tif',r,2040,Eleclocs);
pi_int_44 = chan_intensity('_1_MMStack_Pos0_44.ome.tif',r,240,Eleclocs);

tm3s1_pi_int = [pi_int_0, pi_int_1, pi_int_2, pi_int_3, pi_int_4, pi_int_5, pi_int_6, pi_int_7, pi_int_8, pi_int_9, pi_int_10, pi_int_11, pi_int_12, pi_int_13, pi_int_14, pi_int_15, pi_int_16, pi_int_17, pi_int_18, pi_int_19, pi_int_20, pi_int_21, pi_int_22, pi_int_23, pi_int_24, pi_int_25, pi_int_26, pi_int_27, pi_int_28, pi_int_29, pi_int_30, pi_int_31, pi_int_32, pi_int_33, pi_int_34, pi_int_35, pi_int_36, pi_int_37, pi_int_38, pi_int_39, pi_int_40, pi_int_41, pi_int_42, pi_int_43, pi_int_44];
%