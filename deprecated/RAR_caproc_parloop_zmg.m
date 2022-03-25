% set variables for this run
r = 28; % radius
load('slice1_eleclocs.mat');

pi_int = cell(1,45);
nFrames = 2040 * ones(1,45);
nFrames(45) = 240;
pi_int{1} = chan_intensity_saturn('slice1_zmg_1_MMStack_Pos0.ome.tif',r,2040,Eleclocs);
parfor i = 1:44
    disp([9 'Working on tiff ' num2str(i) ' of 44'])
    pi_int{i+1} = chan_intensity_saturn(['slice1_zmg_1_MMStack_Pos0_' num2str(i) '.ome.tif'],r,nFrames(i+1),Eleclocs);
end
RR_slice1_zmg_pi_int = cell2mat(pi_int); % this may need to be transposed, (i.e. cell2mat(pi_int');) need to test with the actual data first

% save workspace to a file
output = 'output_file.mat';
save (output);