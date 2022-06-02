function [Z] = chan_intensity(img,r,f,coord)
%chan_intensity calculates the average intensity of the pixels in a circle
%of radius r, around the 96 microelectrodes of the Utah array for a calcium
%imaging video
%   img = the image stack; r = radius; f = frame; coord = array of
%   coordinates for the electrodes on the microarray with X and Y coordinates in columns 1 and 2 resepctively (each channel is represented along the rows).
% it really should be called elec_intensity
X1=[];
map1=[];
xgrid = [];
ygrid = [];
mask = [];
values = [];
Y=[];
for i=1:(f)
    [X1, map1] = imread(img,i);
    for l = 1:96
    [xgrid, ygrid] = meshgrid(1:size(X1,2), 1:size(X1,1));
mask = ((xgrid-(coord(l,1))).^2 + (ygrid-(coord(l,2))).^2) <= r.^2;
values = X1(mask);
Y(l,:) = mean(values);
l=l+1;
    end
    Z(:,i) = Y;
    i=i+1;
end

    
end

