function [Y] = slice_caintensity(img,mask)
% Treats the slice as its own ROI and calculates the whole field intensity
% of the slice at any point in time in an effort to obtain a calcium based correlate to
% the whole slice firing rate analysis.
%   img = the image stack;  f = number of frames in img stack; mask of
%   slice created using drawfreehand tool using code below. 
% h=drawfreehand;
% mask=createMask(h));
%Ultimately then take the values obtained here and divide by the baseline
%recording values - say the first 2040 frames of the acsf recording -  to
%get a ratio. Can then plot those values over time. 

X1=[];
map1=[];
mask = [];
values = [];
Y=[];
for i=1:(f)
    [X1, map1] = imread(img,i);
    values = X1(mask);
    Y(i,:) = mean(values);
    i=i+1;
end

end

